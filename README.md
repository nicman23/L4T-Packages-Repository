# L4T-Packages-Repository

All packages recipes for L4T distributions.

| Supported currently   |
|-----------------------|
| Arch Linux            |
| Fedora ( up to FC32 ) |
| Gentoo                |
| OpenSUSE Leap 15.0    |
| Ubuntu Bionic 18.04   |

| Planning to Support   |
|-----------------------|
| Arch variants         |
| CentOS 8              |
| Debian (and variants) |

## Repository content

`files/` : Ubuntu specific configs \
`pkgbuilds/, rpmbuilds/` : Package recipes \
`scripts/` : Helpers scripts \
`scripts/packages/` : Package building helpers \
`scripts/setup_ide.sh` : VSCode WebView

## Packages

`gcc7` : gcc7 compiler \
`jetson-ffmpeg` : Hardware decoding for Tegra \
`linux-tegra` : Linux 4.9 kernel for tegra \
`nvidia-drivers-package` : Tegra drivers \
`switch-boot-files-bin` : Hekate boot files \
`switch-configs` : Switch specific peripheral confgiurations (ALSA, Dock ...) \
`tegra-ffmpeg` : Patched FFmpeg 4.2 for Tegra \
`xorg-server-tegra` : Xorg 1.19.6