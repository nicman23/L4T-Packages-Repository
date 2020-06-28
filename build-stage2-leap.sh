#!/usr/bin/bash

echo "Building Nvidia drivers"
git clone https://github.com/Azkali/L4T-Packages-Repository /L4T-Packages-Repository
cd /L4T-Packages-Repository/rpmbuilds/nvidia-drivers-package
dnf builddep nvidia-drivers-package.spec
rpmbuild -ba nvidia-drivers-package.spec
cp /usr/src/packages/RPMS/aarch64/*.rpm /L4T-Packages-Repository/
echo "Done!"

echo "Building Switch configs"
cd /L4T-Packages-Repository/rpmbuilds/switch-configs
cp -r ./* /usr/src/packages/SOURCES/
rpmbuild -ba switch-configs.spec
cp /usr/src/packages/RPMS/noarch/*.rpm /L4T-Packages-Repository/
echo "Done!"

echo "Installing XFCE, Nvidia drivers and switch config..."
zypper install -y /L4T-Packages-Repository/*.rpm
zypper up -y && zypper -t pattern xfce && zypper -n clean all
systemctl enable r2p bluetooth NetworkManager
echo "Done!"

echo "Fixing boot stuff..."
rm -r /etc/X11/xorg.conf.d/20-fbdev.conf 
update-alternatives --set default-displaymanager /usr/lib/X11/displaymanagers/lightdm
echo "keyboard=onboard" >> /etc/lightdm/lightdm-gtk-greeter.conf
echo "Done!"

echo "Configuring user..."
groupadd wheel
useradd -m -G wheel,video,audio,users -s /bin/bash suse
echo "suse:suse" | chpasswd
sed -i 's/# %wheel        ALL=(ALL) ALL/%wheel        ALL=(ALL) ALL/g' >> /etc/sudoers
echo "Done!"