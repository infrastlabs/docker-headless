
## Build

dfile.sh

- upx
- tiger/build.sh
  - gnutls
  - libxfont2
  - libfontenc
  - libtasn1
  - libxshmfence
  - tigervnc/xorg-server
    - common
    - unix/common
    - unix/passwd
    - unix/xserver
  - X11/xkb:xkeyboard-config
  - xkbcomp
- xdpyprobe/
- 
- fontconfig/build.sh
- openbox
- gtk's yad
- nginx
- novnc



## Built

```bash
# host-21-60:/_ext/working/_ee/ubt-armv7/ubt-core/src/gcc/static # find rootfs/ |grep -v font
rootfs/
rootfs/opt
rootfs/opt/opt
rootfs/opt/opt/base
rootfs/opt/opt/base/share
rootfs/opt/base
rootfs/opt/base/bin
rootfs/opt/base/bin/xdpyprobe
rootfs/opt/base/bin/Xvnc
rootfs/opt/base/bin/vncpasswd
rootfs/opt/base/share
rootfs/opt/base/share/X11

# host-21-60:/_ext/working/_ee/ubt-armv7/ubt-core/src/gcc/static # ll -Sh
total 23M
-rw-r--r--  1 root root 9.0M Oct 16 23:39 xorg-server-1.20.14.tar.gz
-rw-r--r--  1 root root 5.8M Oct 16 23:14 gnutls-3.7.1.tar.xz
-rw-r--r--  1 root root 1.9M Oct 16 23:21 v1.13.1.tar.gz
-rw-r--r--  1 root root 1.7M Oct 16 23:45 xkeyboard-config-2.32.tar.bz2
-rw-r--r--  1 root root 1.7M Oct 16 23:20 libtasn1-4.18.0.tar.gz
-rw-r--r--  1 root root 1.2M Oct 16 23:06 upx-4.0.1-src.tar.xz
-rw-r--r--  1 root root 6.1K Oct 16 23:36 dfile.sh
-rw-r--r--  1 root root 5.3K Oct 16 22:15 Dockerfile
drwxr-xr-x  2 root root 4.0K Oct 17 00:01 _build #32K
drwxr-xr-x 17 root root 4.0K Oct 17 00:08 _tmp   #274M
drwxr-xr-x  3 root root 4.0K Oct 16 23:43 rootfs #6M
drwxr-xr-x  5 root root 4.0K Oct 16 20:54 src
-rw-r--r--  1 root root 3.1K Oct 17 00:00 README.md
-rw-r--r--  1 root root 2.2K Oct 16 23:25 Dockerfile.xx
-rw-r--r--  1 root root  317 Oct 17 00:00 alpine-build.sh
-rw-r--r--  1 root root   31 Oct 16 23:21 .gitignore
```

- xdpyprobe

```bash
host-21-60:/_ext/working/_ee/ubt-armv7/ubt-core/src/gcc/static # rootfs/opt/base/bin/xdpyprobe -h
Usage: xdpyprobe [OPTIONS] [DISPLAY]
Check connectivity of the X server defined by DISPLAY.
If DISPLAY is not specified, use $DISPLAY environment variable.

Options:
  -q, --quiet       do not display any output
  -h, --help        display help message and exit
  -v, --version     display version message and exit

Exit status:
   0  if connection to DISPLAY succeeded;
   1  if connection to DISPLAY failed;
 255  if X server connectivity was not probed (e.g., when
      the help message is displayed).
```

## Ref



- https://gitee.com/infrastlabs/fk-docker-baseimage-gui/blob/master/.github/workflows/build-baseimage.yml


```yml
    strategy:
      fail-fast: false
      matrix:
        info:
          - '{ "tag_prefix": "alpine-3.14",  "baseimage": "jlesage/baseimage:alpine-3.14-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.15",  "baseimage": "jlesage/baseimage:alpine-3.15-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.16",  "baseimage": "jlesage/baseimage:alpine-3.16-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.17",  "baseimage": "jlesage/baseimage:alpine-3.17-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.18",  "baseimage": "jlesage/baseimage:alpine-3.18-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "debian-10",    "baseimage": "jlesage/baseimage:debian-10-v3.4.7",    "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "debian-11",    "baseimage": "jlesage/baseimage:debian-11-v3.4.7",    "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-16.04", "baseimage": "jlesage/baseimage:ubuntu-16.04-v3.4.7", "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-18.04", "baseimage": "jlesage/baseimage:ubuntu-18.04-v3.4.7", "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-20.04", "baseimage": "jlesage/baseimage:ubuntu-20.04-v3.4.7", "platforms": "linux/amd64,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-22.04", "baseimage": "jlesage/baseimage:ubuntu-22.04-v3.4.7", "platforms": "linux/amd64,linux/arm/v7,linux/arm64/v8" }'


```
