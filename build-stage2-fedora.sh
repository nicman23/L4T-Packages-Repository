#!/usr/bin/bash

pre() {
	dnf -y update && dnf -y groupinstall 'Basic Desktop' 'Xfce Desktop'
	dnf -y remove xorg-x11-server-common iscsi-initiator-utils-iscsiuio iscsi-initiator-utils clevis-luks atmel-firmware kernel*
	dnf -y clean all

	# TODO: Make kernel rpm
	echo '\nexclude=linux-firmware kernel* xorg-x11-server-* xorg-x11-drv-ati xorg-x11-drv-armsoc xorg-x11-drv-nouveau xorg-x11-drv-ati xorg-x11-drv-qxl xorg-x11-drv-fbdev' >> /etc/dnf/dnf.conf
}

post() {
	systemctl enable r2p bluetooth lightdm NetworkManager
	sed -i 's/#keyboard=/keyboard=onboard/' /etc/lightdm/lightdm-gtk-greeter.conf

	useradd -m fedora
	usermod -aG video,audio,wheel fedora
	echo "fedora:fedora" | chpasswd && echo "root:root" | chpasswd
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
