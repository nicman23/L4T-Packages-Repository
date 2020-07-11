# Maintainer: Ezekiel Bethel <zek@9net.org>
Name:			switch-boot-files-bin
Version:		R32
Release:		4.2
BuildArch:		noarch
Source0:		fedora.ini
Source1:		boot.scr.txt
Source2:		coreboot.rom
Source3:		leap.ini
License:        GPLv3+
Summary:		Switch boot files
BuildRequires:	uboot-tools

%description
	Switch boot files

%prep
	mkdir -p %buildroot/boot/bootloader/ini %buildroot/boot/switchroot/fedora/

%install
	install %SOURCE0 %buildroot/boot/bootloader/ini/fedora.ini
	install %SOURCE1 %SOURCE2 %buildroot/boot/switchroot/fedora/
	mkimage -A arm -T script -O linux -d %SOURCE1 %buildroot/boot/switchroot/fedora/boot.scr

	mkdir -p %buildroot/boot/l4t-fedora/
	cp -r bootloader %buildroot/boot/
	cp -r l4t-fedora/{boot.scr,coreboot.rom} %buildroot/boot/l4t-fedora

%files
/boot/*

%clean
rm -rf %buildroot