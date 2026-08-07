#!/bin/bash
set -x # echo commands with vars expanded
set -e # exit immediately on error

DIST_NAME=$(lsb_release -cs)
RELEASE_DEB="https://apt.puppetlabs.com/puppet-tools-release-${DIST_NAME}.deb"
# NOTE: still points at puppet6-nightly; out of date.
NIGHTLY_DEB="https://nightlies.puppetlabs.com/apt/puppet6-nightly-release-${DIST_NAME}.deb"
PUPPETCORE_RELEASE_DEB="https://apt-puppetcore.puppet.com/public/puppet8-release-${DIST_NAME}.deb"
PUPPETCORE_AUTH_CONF="/etc/apt/auth.conf.d/apt-puppetcore-puppet.conf"

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
    printf 'machine apt-puppetcore.puppet.com\nlogin forge-key\npassword %s\n' "${PUPPET_FORGE_TOKEN}" \
        | sudo tee "${PUPPETCORE_AUTH_CONF}" > /dev/null
    sudo chmod 600 "${PUPPETCORE_AUTH_CONF}"
}

main() {
    if [ -n "${PUPPET_FORGE_TOKEN}" ]; then
        setup_puppetcore_apt
    elif [ -z "${PDK}" -o "${PDK}" = "release" ]; then
        setup_apt "${RELEASE_DEB}"
    elif [ "${PDK}" = "nightly" ]; then
        setup_apt "${NIGHTLY_DEB}"
    else
        echo "Unknown \$PDK value '${PDK}'. Supported values are 'release' and 'nightly'." >&2
        exit 1
    fi

    sudo apt-get update -qq
    sudo apt-get install -y pdk

    /usr/local/bin/pdk --version
}

main "$@"
