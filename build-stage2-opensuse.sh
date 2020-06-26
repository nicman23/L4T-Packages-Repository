#!/usr/bin/bash
zypper -y up && zypper -y clean all 

systemctl enable r2p bluetooth NetworkManager
sed -i 's/#keyboard=/keyboard=onboard/' /etc/lightdm/lightdm-gtk-greeter.conf