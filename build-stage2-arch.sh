#!/bin/bash

pre() {
	# Pre install configurations
	## Workaround for flakiness of `pt` mirror.
	sed -i 's/mirror.archlinuxarm.org/eu.mirror.archlinuxarm.org/g' /etc/pacman.d/mirrorlist

	## Arch switchroot repository
	echo -e "[switchrootarch]\nServer = https://archrepo.switchroot.org/" >> /etc/pacman.conf
	curl https://newrepo.switchroot.org/pubkey > /tmp/pubkey
	pacman-key --add /tmp/pubkey
	pacman-key --lsign-key C9DDF6AA7BAC41CF6B893FB892813F6A23DB6DFC

	## Audio fix
	sed 's/.*default-sample-rate.*/default-sample-rate = 48000/' -i /etc/pulse/daemon.conf

	# Installation
	pacman -R linux-aarch64 --noconfirm

	i=5
	echo -e "\n\nBeginning packages installation!\nRetry attempts left: ${i}"
	until [[ ${i} == 0 ]] || pacman -Syu joycond-git switch-boot-files-bin systemd-suspend-modules xorg-server-tegra switch-config tegra-bsp linux-tegra --noconfirm; do
		pacman -Syu joycond-git switch-boot-files-bin systemd-suspend-modules xorg-server-tegra switch-config tegra-bsp linux-tegra --noconfirm
		echo -e "\n\nPackages installation failed, retrying!\nRetry attempts left: ${i}"
		let --i
	done
}

post() {
	# Post install configurations
	yes | pacman -Scc
	systemctl enable r2p bluetooth lightdm NetworkManager
	echo brcmfmac > /etc/suspend-modules.conf
	sed -i 's/#keyboard=/keyboard=onboard/' /etc/lightdm/lightdm-gtk-greeter.conf
	usermod -aG video,audio,wheel alarm
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
