#!/usr/bin/bash

pre() {
	zypper -y update && zypper -y upgrade && zypper -y clean all 

	systemctl enable r2p bluetooth NetworkManager
	sed -i 's/#keyboard=/keyboard=onboard/' /etc/lightdm/lightdm-gtk-greeter.conf
}

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
	echo " --pre				Pre config"
	echo " --post				Post config"
    echo " --help               Show this help text"
}

# Parse arguments
options=$(getopt -n "$0" -l "pre,post,help" -- "$@")

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

# Evaluate arguments
eval set -- "${options}"
while true; do
    case "$1" in
	--pre) pre; shift ;;
    --post) post; shift ;;
    ? | --help) usage; exit 0 ;;
    -- ) shift; break ;;
	* ) break ;;
    esac
done
