Name:				jetson-ffmpeg
Version:			R32
Release:			4.2
BuildArch:			aarch64
License:			GPL
URL:				"https://github.com/jocover/%{name}"
Source0:			CMakeLists.txt
Summary:			Jetson ffmpeg
BuildRequires:		git cmake gcc-c++ 

%if 0%{?fedora}
BuildRequires:	mesa-libEGL-devel
%endif

%if 0%{?suse_version}
BuildRequires: Mesa-libEGL-devel
%endif

%description
	Jetson ffmpeg

%prep
	git clone %url
	cd %name

	git checkout 7d675d4
	# https://github.com/jocover/jetson-ffmpeg/issues/34/
	cp %SOURCE0 .
	mkdir build

%build
	cd %name/build
	cmake -DCMAKE_INSTALL_PREFIX=/usr ..
	make -j$(nproc)

%install
	cd %name/build
	make DESTDIR=%buildroot install

%post
	/sbin/ldconfig

%files
/usr/*

%clean
rm -rf %{buildroot}
