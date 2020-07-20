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


%if 0%{?suse_version}
%define distro leap
%endif


%if 0%{?suse_version}
%define distro fedora
%endif

%description
	Switch boot files

%prep
	mkdir -p %buildroot/boot/bootloader/ini %buildroot/boot/switchroot/%distro/

%install
	sed -i 's/switchroot\/*\//switchroot\/%distro\//g' %SOURCE0
	install %SOURCE0 %buildroot/boot/bootloader/ini/%distro.ini
	install %SOURCE1 %SOURCE2 %buildroot/boot/switchroot/%distro/
	mkimage -A arm -T script -O linux -d %SOURCE1 %buildroot/boot/switchroot/%dist/boot.scr

	mkdir -p %buildroot/boot/%distro
	cp -r bootloader %buildroot/boot/
	cp -r %distro/{boot.scr,coreboot.rom} %buildroot/boot/%distro

%files
/boot/*

%clean
rm -rf %buildroot