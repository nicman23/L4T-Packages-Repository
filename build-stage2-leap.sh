#!/usr/bin/bash
zypper -y dup && zypper -t pattern xfce && zypper -y clean all 

systemctl enable r2p bluetooth NetworkManager
rm /etc/X11/xorg.conf.d/20-fbdev.conf
# Change DM to lightDM here
echo "keyboard=onboard" >> /etc/lightdm/lightdm-gtk-greeter.conf

groupadd wheel
useradd -m -G wheel,video,audio,users -s /bin/bash suse
echo "suse:suse" | chpasswd
sed -i 's/# %wheel        ALL=(ALL) ALL/%wheel        ALL=(ALL) ALL/g' >> # visudo file here 

ldconfig