#!/usr/bin/bash

dnf -y update && dnf -y groupinstall 'Basic Desktop' 'Xfce Desktop'
dnf -y remove xorg-x11-server-common iscsi-initiator-utils-iscsiuio iscsi-initiator-utils clevis-luks atmel-firmware kernel*
dnf -y clean all

# TODO: Make kernel rpm
echo '\nexclude=linux-firmware kernel* xorg-x11-server-* xorg-x11-drv-ati xorg-x11-drv-armsoc xorg-x11-drv-nouveau xorg-x11-drv-ati xorg-x11-drv-qxl xorg-x11-drv-fbdev' >> /etc/dnf/dnf.conf

systemctl enable bluetooth lightdm NetworkManager
sed -i 's/#keyboard=/keyboard=onboard/' /etc/lightdm/lightdm-gtk-greeter.conf

useradd -m -G video,audio,wheel -s /bin/bash fedora
echo "fedora:fedora" | chpasswd && echo "root:root" | chpasswd