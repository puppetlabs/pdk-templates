#!/bin/bash
set -x # echo commands with vars expanded
set -e # exit immediately on error

DIST_NAME=$(lsb_release -cs)
RELEASE_DEB="https://apt.puppetlabs.com/puppet-tools-release-${DIST_NAME}.deb"
# NOTE: still points at puppet6-nightly; out of date.
NIGHTLY_DEB="https://nightlies.puppetlabs.com/apt/puppet6-nightly-release-${DIST_NAME}.deb"
PUPPETCORE_RELEASE_DEB="https://apt-puppetcore.puppet.com/public/puppet8-release-${DIST_NAME}.deb"
PUPPETCORE_AUTH_CONF="/etc/apt/auth.conf.d/apt-puppetcore-puppet.conf"
# Per-commit PDK builds, reachable only once ci.yml has connected Twingate.
NIGHTLY_INDEX_URL="https://builds.delivery.puppetlabs.net/pdk/"
NIGHTLY_SOURCES_LIST="/etc/apt/sources.list.d/pdk-nightly.list"

setup_apt() {
    local deb_url="${1}"
    local deb_file=$(basename "${deb_url}")

    wget "${deb_url}"
    sudo dpkg -i "${deb_file}"

    # Add the non-expiring key from the future endpoint
    curl -fsSL https://apt.puppetlabs.com/DEB-GPG-KEY-future | sudo apt-key add -
}

setup_puppetcore_apt() {
    # Release package installs its own signing key; no apt-key step needed.
    wget --content-disposition "${PUPPETCORE_RELEASE_DEB}"
    sudo dpkg -i "$(basename "${PUPPETCORE_RELEASE_DEB}")"

    sudo mkdir -p "$(dirname "${PUPPETCORE_AUTH_CONF}")"
    set +x
    printf 'machine apt-puppetcore.puppet.com\nlogin forge-key\npassword %s\n' "${PUPPET_FORGE_TOKEN}" \
        | sudo tee "${PUPPETCORE_AUTH_CONF}" > /dev/null
    set -x
    sudo chmod 600 "${PUPPETCORE_AUTH_CONF}"
}

# Per-commit builds ahead of any official release. Requires Twingate already
# connected (ci.yml's job, gated on PDK_CHANNEL=nightly) - builds.delivery.puppetlabs.net
# is unreachable otherwise. Finds "latest" from the directory listing's real
# timestamps rather than a hardcoded SHA, since a fixed SHA goes stale immediately.
setup_nightly_apt() {
    local latest_sha
    latest_sha=$(curl -fsSL --max-time 30 "${NIGHTLY_INDEX_URL}" | ruby -rtime -e '
      best = nil
      STDIN.read.scan(%r{<a href="([0-9a-f]{40})/">[0-9a-f]{40}/</a>\s+(\d{2}-\w{3}-\d{4} \d{2}:\d{2})}).each do |sha, ts|
        t = Time.strptime(ts, "%d-%b-%Y %H:%M")
        best = [t, sha] if best.nil? || t > best[0]
      end
      puts best&.last
    ')

    if [ -z "${latest_sha}" ]; then
        echo "ERROR: could not determine latest PDK nightly build from ${NIGHTLY_INDEX_URL}" >&2
        exit 1
    fi
    echo "Using PDK nightly build ${latest_sha}"

    local list_url="${NIGHTLY_INDEX_URL}${latest_sha}/repo_configs/deb/pl-pdk-${latest_sha}-${DIST_NAME}.list"
    local repo_line
    repo_line=$(curl -fsSL --max-time 30 "${list_url}" | grep '^deb ')

    if [ -z "${repo_line}" ]; then
        echo "ERROR: no apt repo config for '${DIST_NAME}' at ${list_url}" >&2
        exit 1
    fi

    # Per-commit build repo is unsigned (no InRelease/Release.gpg) - mark
    # [trusted=yes] scoped to only this one source, not apt globally.
    echo "${repo_line}" | sed 's/^deb /deb [trusted=yes] /' \
        | sudo tee "${NIGHTLY_SOURCES_LIST}" > /dev/null
}

main() {
    set +x
    if [ "${PDK_CHANNEL}" = "nightly" -a -n "${TWINGATE_PUBLIC_REPO_KEY}" ]; then
        setup_nightly_apt
    elif [ -n "${PUPPET_FORGE_TOKEN}" ]; then
        setup_puppetcore_apt
    elif [ -z "${PDK}" -o "${PDK}" = "release" ]; then
        setup_apt "${RELEASE_DEB}"
    elif [ "${PDK}" = "nightly" ]; then
        setup_apt "${NIGHTLY_DEB}"
    else
        echo "Unknown \$PDK value '${PDK}'. Supported values are 'release' and 'nightly'." >&2
        exit 1
    fi
    set -x

    sudo apt-get update -qq
    sudo apt-get install -y pdk

    /usr/local/bin/pdk --version
}

main "$@"
