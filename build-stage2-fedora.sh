#!/usr/bin/bash

echo "Building Nvidia drivers"
rpmdev-setuptree
git clone https://github.com/Azkali/L4T-Packages-Repository /L4T-Packages-Repository
cd /L4T-Packages-Repository/rpmbuilds/nvidia-drivers-package
dnf builddep nvidia-drivers-package.spec
rpmbuild -ba nvidia-drivers-package.spec
cp /root/rpmbuild/RPMS/aarch64/*.rpm /L4T-Packages-Repository/
echo "Done!"

echo "Building Switch configs"
cd /L4T-Packages-Repository/rpmbuilds/switch-configs
cp -r ./* /root/rpmbuild/SOURCES/
rpmbuild -ba switch-configs.spec
cp /root/rpmbuild/RPMS/noarch/*.rpm /L4T-Packages-Repository/
echo "Done!"

echo "Installing XFCE, Nvidia drivers and switch config..."
dnf -y install /L4T-Packages-Repository/*.rpm
dnf -y update && dnf -y groupinstall 'Basic Desktop' 'Xfce Desktop'
dnf -y remove xorg-x11-server-common iscsi-initiator-utils-iscsiuio iscsi-initiator-utils clevis-luks atmel-firmware kernel*
dnf -y clean all

rm -rf /L4T-Packages-Repository/

# TODO: Make kernel rpm
echo '\nexclude=linux-firmware kernel* xorg-x11-server-* xorg-x11-drv-ati xorg-x11-drv-armsoc xorg-x11-drv-nouveau xorg-x11-drv-ati xorg-x11-drv-qxl xorg-x11-drv-fbdev' >> /etc/dnf/dnf.conf

systemctl enable bluetooth lightdm NetworkManager
sed -i 's/#keyboard=/keyboard=onboard/' /etc/lightdm/lightdm-gtk-greeter.conf

useradd -m -G video,audio,wheel -s /bin/bash fedora
echo "fedora:fedora" | chpasswd && echo "root:root" | chpasswd