#!/bin/sh -xe

DIST_NAME=$(lsb_release -cs)
RELEASE_DEB="https://apt.puppetlabs.com/puppet5-release-${DIST_NAME}.deb"
NIGHTLY_DEB="https://apt.puppetlabs.com/puppet-nightly/puppet-nightly-release-${DIST_NAME}.deb"

setup_apt() {
    local deb_url="${1}"
    local deb_file=$(basename "${deb_url}")

    wget "${deb_url}"
    sudo dpkg -i "${deb_file}"
}

main() {
    if [ -z "${PDK}" -o "${PDK}" = "release" ]; then
        setup_apt "${RELEASE_DEB}"
    elif [ "${PDK}" = "nightly" ]; then
        setup_apt "${NIGHTLY_DEB}"
    else
        echo "Unknown \$PDK value '${PDK}'. Supported values are 'release' and 'nightly'." >&2
        exit 1
    fi

    sudo apt-get update -qq
    sudo apt-get install -y pdk
}

main "$@"
