# Maintainer: Your Name <youremail@domain.com>
Name:			switch-configs
Version:		1
Release:		4
License:		GPL
BuildArch:		noarch
Summary:		Switch specific config for Linux
Source0:		switch-l4t-configs
Source1:        asound.state
Source2:        10-monitor.conf
Source3:        r2p.service
Source4:        brcmfmac4356-pcie.txt
BuildRequires:  git

%description
Switch specific config for Linux

%install
mkdir -p %buildroot/etc/systemd/system %buildroot/etc/X11/xorg.conf.d %buildroot/usr/bin %buildroot/usr/lib/udev/rules.d %buildroot/etc/dconf/db/local.d %buildroot/etc/dconf/profile %buildroot/usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x/ %buildroot/usr/lib/systemd/system %buildroot/var/lib/alsa/ %buildroot/usr/lib/firmware/brcm/

install %SOURCE1 %buildroot/var/lib/alsa/
install %SOURCE2 %buildroot/etc/X11/xorg.conf.d/
install %SOURCE3 %buildroot/etc/systemd/system/
install %SOURCE4 %buildroot/usr/lib/firmware/brcm/

install %{_sourcedir}/switch-l4t-configs/switch-dock-handler/92-dp-switch.rules %buildroot/usr/lib/udev/rules.d/
install %{_sourcedir}/switch-l4t-configs/switch-dock-handler/dock-hotplug %buildroot/usr/bin/
sed 's/sudo -u/sudo -s -u/g' -i %buildroot/usr/bin/dock-hotplug

install %{_sourcedir}/switch-l4t-configs/switch-dconf-customizations/99-switch %buildroot/etc/dconf/db/local.d/
install %{_sourcedir}/switch-l4t-configs/switch-dconf-customizations/user %buildroot/etc/dconf/profile/
install %{_sourcedir}/switch-l4t-configs/switch-alsa-ucm/* %buildroot/usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x/
install %{_sourcedir}/switch-l4t-configs/switch-bluetooth-service/switch-bluetooth.service %buildroot/usr/lib/systemd/system/
install %{_sourcedir}/switch-l4t-configs/switch-touch-rules/* %buildroot/usr/lib/udev/rules.d/

%clean
rm -rf %buildroot

%files
/usr/*
/etc/*
/var/*