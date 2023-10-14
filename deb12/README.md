# 

- deb9
  - box04-slim `91.811 MB` #gw
  - box04 `174.405 MB` #audio
  - box04-full `296.650 MB` #extend
- deb12
  - compile/compile2
  - slim/base/core
  - latest/sogou

## DONE@deb9

- ~~compile: xrdp/xrdp-pulse, rofi, stterm~~
- ~~novnc: change_pw, readonly~~; UI:input_pass
- ~~multi: xvnc0-de +offset;~~ pulsePort_N;
- ~~bunsen-grey-theme: Papirus-Bunsen-grey~~
- ~~xrdp_disk_mount @xvnc0~~
- ~~novnc: postLogin(curPage not support), tls~~
- ~~multi pulse; 4713 > 4701, 02, 03..(/etc/pulse/default.pa > /home/xxx/.config/pulse/...)~~
- ~~novnc-audio: ffmpeg?+jsmpeg~~

## Compile

- https://github.com/neutrinolabs/xrdp
- https://gitee.com/g-system/pulseaudio-module-xrdp #v0.5; 仓库无改动
  - https://github.com/pulseaudio/pulseaudio #`v16.1; v16.99.1`
- 
- https://distrowatch.com/table.php?distribution=ubuntu `xorg 1.20.8 @ubt2004`
- https://distrowatch.com/table.php?distribution=debian `xorg 1.21.1 @deb12/ubt2204`
- https://github.com/TigerVNC/tigervnc/releases
  - ubt2004选用: `xorg-server-1.20.7 -- tiger:v1.12.0`
  - xorg1.20.7+ -- @tiger 1.11.0
  - xorg1.21 -- @tiger 1.13.0

```bash
# @23.10.14
xrdp 0.9.16 > v0.9.23.1
xorg-server-1.20.7 -- tiger:v1.12.0  >> tiger:v1.13.1


# ERR1 tigervnc v1.12.0:
 149 |     #0 16.95   Could NOT find X11 (missing: X11_X11_LIB)
 #apt-get install libx11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev


# ERR2: xrdp @after stage-base apt-deps-merged.
39.72 /usr/include/openssl/dh.h:204:28: note: declared here
39.72   204 | OSSL_DEPRECATEDIN_3_0 void DH_free(DH *dh);


##ERR x3########
xrdpERR: cc1-openssl3-warn-as-err;
pulseERR: /opt/pulseaudio-16.1+dsfg1/ 无./configure;
tigerERR: (missing: X11_X11_LIB); `export CMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu;`

```

**xrdp**

```bash
v0.9.5 #deb9?
v0.9.16 #ubt2004 ##err @deb12:(cc1-openssl3-warn-as-err)
v0.9.19 #(thunar@gemmi-deb11卡死)
v0.9.23 deb12-try @23.10.14 #编译OK
```

**pulse.xrdp**

```bash
# /opt/pulseaudio-16.1+dsfg1/ 无./configure;
pulseaudio --version | awk '{print $2}'
# deb12: pulseaudio ver: 16.1
# deb9: pulseaudio ver: 10.0 #old_dockerfile_notes
# ubt2004: pulseaudio ver: 13.99.1

# https://github.com/pulseaudio/pulseaudio/tree/v16.1 #README
# meson build #v14.99.1开始;
HACKING:
	In order to run pulseaudio from the build dir:
	  meson build
	  meson compile -C build
	  #build/src/daemon/pulseaudio -n -F build/src/daemon/default.pa -p $(pwd)/build/src/modules/

# https://github.com/pulseaudio/pulseaudio/tree/v13.99.3 #README
HACKING:
	In order to run pulseaudio from the build dir __OPTIMIZE__ should be
	disabled (look at src/pulsecore/core-util.h::pa_run_from_build_tree()),
	this can be done by passing "CFLAGS=-O0" to the configure script:
	  ./autogen.sh
	  CFLAGS="-ggdb3 -O0" LDFLAGS="-ggdb3" ./configure
	  make
	  #./src/pulseaudio -n -F src/default.pa -p $(pwd)/src/

# ERR1:
5.758 ERROR: Current directory is not a meson build directory: `/opt/pulseaudio-16.1+dfsg1/build`.
# 直接注释? #需要config.h;


# 手动ct-compile环境下跑：
root@71754fc0de6d:/opt/pulseaudio-16.1+dfsg1# meson  build
root@71754fc0de6d:/opt/pulseaudio-16.1+dfsg1# 
root@71754fc0de6d:/opt/pulseaudio-16.1+dfsg1# find |grep config.h
./build/config.h
root@71754fc0de6d:/opt/pulseaudio-16.1+dfsg1# ls build/
PulseAudioConfig.cmake.tmp     compile_commands.json  libpulse-mainloop-glib.pc  man         meson-private     src
PulseAudioConfigVersion.cmake  config.h               libpulse-simple.pc         meson-info  po                vala
build.ninja                    doxygen                libpulse.pc                meson-logs  shell-completion

# 之后拷贝文件，编译ok;
cp -a /opt/pulseaudio-${pulseaudio}*dfsg*/build/config.h .; \
cp -a /opt/pulseaudio-${pulseaudio}*dfsg*/build/src/pulsecore/ .; \
make;
```


**tiger-update**

- https://ghproxy.com/https://github.com/TigerVNC/tigervnc/archive/v1.13.1/tigervnc-1.13.1.tar.gz
- https://www.x.org/pub/individual/xserver/xorg-server-21.1.7.tar.gz
- patches
  - unix/xserver/../tiger-$ver.patch
  - /build/tigervnc-1.13.1-configuration_fixes-1.patch #orig?

**ubt's-tigervnc:** (手动编译)

- cat /build/tigervnc-1.12.0/CMakeFiles/CMakeError.log; #cmake: `首次也有iconv的错`
- cmake: cmake > libfltk1.3-dev  > `cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr ...` OK; 
  - gitac: **不执行`apt build-dep -y tigervnc`**, 则cmake正常; >> 再make也OK;(无：`(missing: X11_X11_LIB)`)
  - git patch> cmake连一块: 前后都正常，都是个五个static库`libos|librfb|librdr|libnetwork|libunixcommon`
- make: libxi-dev > `export CMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu` OK; 无`Could NOT find X11 (missing: X11_X11_LIB)`
  - gitac: 无Xvnc找不到la的错，但依旧未生成Xvnc(common 无make>>  XServer:有common五个la文件，但无Xvnc目录构建及生成)
  - gitac: gitPatch> cmake> make; >> XServer ./configure> make; 有Xvnc生成了;

```bash
root@VM-12-9-ubuntu:/opt/working/_ee/docker-headless/deb12# docker run -it --rm -v $(pwd):/mnt -v $(pwd)/src/arm:/src/arm infrastlabs/docker-headless:deb12-compile bash
root@71754fc0de6d:/opt# cd /src/arm/

=configure==
# CMAKE:
#  +cmake
#  apt install -y libfltk1.3-dev ##Could NOT find FLTK (missing: FLTK_LIBRARIES FLTK_INCLUDE_DIR)


=make==
# MAKR-ERR11: (tools-bin)
/build/tigervnc-1.12.0/vncviewer/touch.cxx:32:10: fatal error: X11/extensions/XInput2.h: No such file or directory
   32 | #include <X11/extensions/XInput2.h>
apt install libxi-dev; #OK


# ERR12:
[ 77%] Linking CXX executable vncviewer
/usr/bin/ld: cannot find -lX11_Xi_LIB-NOTFOUND: No such file or directory
collect2: error: ld returned 1 exit status
# https://github.com/glfw/glfw/issues/1957
  # export CMAKE_LIBRARY_ARCHITECTURE=x86_64-unknown-linux-gnu; \ ##ff-cause-err
  export CMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu; \ #with this line, fixed;

==OK;


# ERR21: (Xvnc)
checking for sigaction... yes
checking for xshmfence >= 1.1... no
configure: error: DRI3 requested, but xshmfence not found.
make: *** No targets specified and no makefile found.  Stop.
# apt install libxcb-dri3-0 #已装
# https://github.com/forgiare/accendino/commit/99cd862760ec611210636034c6727599b9a68eed
# libdrm-dev libxfont-dev mesa-common-dev #已装

# https://community.st.com/t5/stm32-mpus-embedded-software/error-when-trying-to-combine-x11-with-weston-in-ecosystem/td-p/96675  ##libxshmfence
libxshmfence-dev


# ERR22:
Making all in dri3
make[1]: Entering directory '/build/tigervnc-1.12.0/unix/xserver/dri3'
  CC       dri3.lo
dri3.c:29:10: fatal error: drm_fourcc.h: No such file or directory
   29 | #include <drm_fourcc.h>

# https://github.com/TigerVNC/tigervnc/issues/740
# deb12: --enable-dri3 >> --disable-dri3
==OK;
```

**GitAction err**

```bash
# ERR3: (gitac)
#24 181.0 Making install in hw
#24 181.0 make[1]: Entering directory '/build/tigervnc-1.12.0/unix/xserver/hw'
#24 181.0 Making install in vnc
#24 181.1 make[2]: Entering directory '/build/tigervnc-1.12.0/unix/xserver/hw/vnc'
#24 181.1 make[2]: Leaving directory '/build/tigervnc-1.12.0/unix/xserver/hw/vnc'
#24 181.1 make[2]: *** No rule to make target '../../../../common/network/libnetwork.la', needed by 'Xvnc'.  Stop.
#24 181.1 make[1]: Leaving directory '/build/tigervnc-1.12.0/unix/xserver/hw'
#24 181.1 make[1]: *** [Makefile:627: install-recursive] Error 1
#24 181.1 make: *** [Makefile:829: install-recursive] Error 1

# 注释：apt build-dep -y tigervnc 
#24 222.4 make[2]: Entering directory '/build/tigervnc-1.12.0/unix/xserver/hw/vnc'
#24 222.4   CXXLD    Xvnc
#24 223.0 /usr/bin/ld: cannot find ../../../../common/network/.libs/libnetwork.a: No such file or directory
#24 223.0 /usr/bin/ld: cannot find ../../../../common/rfb/.libs/librfb.a: No such file or directory
#24 223.0 /usr/bin/ld: cannot find ../../../../common/rdr/.libs/librdr.a: No such file or directory
#24 223.0 /usr/bin/ld: cannot find ../../../../common/os/.libs/libos.a: No such file or directory
#24 223.0 /usr/bin/ld: cannot find ../../../../unix/common/.libs/libunixcommon.a: No such file or directory
#24 223.0 collect2: error: ld returned 1 exit status


# root@71754fc0de6d:/build/tigervnc-1.12.0# cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr \
>     -DCMAKE_BUILD_TYPE=Release -DINSTALL_SYSTEMD_UNITS=OFF -Wno-dev . ; \
>   cat /build/tigervnc-1.12.0/CMakeFiles/CMakeError.log; 
-- CMAKE_BUILD_TYPE = Release
-- VERSION = 1.12.0
-- BUILD_TIMESTAMP = 2023-10-14 17:55
-- 64-bit build
-- Could NOT find GnuTLS (missing: GNUTLS_LIBRARY GNUTLS_INCLUDE_DIR) 
-- Creating static libtool control file for target os
-- Creating static libtool control file for target rdr
-- Creating static libtool control file for target network
-- Creating static libtool control file for target rfb
-- Creating static libtool control file for target unixcommon
-- Configuring done
-- Generating done
-- Build files have been written to: /build/tigervnc-1.12.0
cat: /build/tigervnc-1.12.0/CMakeFiles/CMakeError.log: No such file or directory


# gitPatch> cmake> +make; 
# XServer: hw/vnc/ >> Xvnc生成OK;

# 验证： libjpeg8@ubt2004 >> libjpeg62-turbo
# error while loading shared libraries: libjpeg.so.62: cannot open shared object file
root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc# dpkg -l |grep libjpeg
ii  libjpeg-dev:amd64                    1:2.1.5-2                      amd64        Development files for the JPEG library [dummy package]
ii  libjpeg62-turbo:amd64                1:2.1.5-2                      amd64        libjpeg-turbo JPEG runtime library
ii  libjpeg62-turbo-dev:amd64            1:2.1.5-2                      amd64        Development files for the libjpeg-turbo JPEG library
root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc#

# apt install libjpeg62-turbo



# error while loading shared libraries: libcrypto.so.3: cannot open shared object file
root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc# find /usr |grep libcrypto.so.3
/usr/lib/x86_64-linux-gnu/libcrypto.so.3
# root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc# ls -l /usr/lib/x86_64-linux-gnu/libcrypto.so.3 -h
-rw-r--r-- 1 root root 4.5M Sep 26 19:08 /usr/lib/x86_64-linux-gnu/libcrypto.so.3


# openssl    3.0.11-1~deb12u1
# root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc# dpkg -l |grep crypt
ii  gpg-agent                            2.2.40-1.1                     amd64        GNU privacy guard - cryptographic agent
ii  libcrypt-dev:amd64                   1:4.4.33-2                     amd64        libcrypt development files
ii  libcrypt1:amd64                      1:4.4.33-2                     amd64        libcrypt shared library
ii  libcryptsetup12:amd64                2:2.6.1-4~deb12u1              amd64        disk encryption support - shared library
ii  libgcrypt20:amd64                    1.10.1-3                       amd64        LGPL Crypto library - runtime library
ii  libhogweed6:amd64                    3.8.1-2                        amd64        low level cryptographic library (public-key cryptos)
ii  libk5crypto3:amd64                   1.20.1-2+deb12u1               amd64        MIT Kerberos runtime libraries - Crypto Library
ii  libnettle8:amd64                     3.8.1-2                        amd64        low level cryptographic library (symmetric and one-way cryptos)
ii  openssl                              3.0.11-1~deb12u1               amd64        Secure Sockets Layer toolkit - cryptographic utility
root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc# 



# RUNNING ERR: Failed to compile keymap

# exclude:
# XKB: Failed to compile keymap
# path-exclude /usr/share/X11/*\n\


# root@71754fc0de6d:/build/tigervnc-1.12.0/unix/xserver/hw/vnc# ./Xvnc -ac :50 -listen tcp -rfbauth=/etc/xrdp/vnc_pass -depth 16 -BlacklistThreshold=3 -BlacklistTimeout=1
Xvnc TigerVNC 1.12.0 - built Oct 14 2023 11:35:05
Copyright (C) 1999-2021 TigerVNC Team and many others (see README.rst)
See https://www.tigervnc.org for information on TigerVNC.
Underlying X server release 12007000, The X.Org Foundation
Sat Oct 14 20:31:03 2023
 vncext:      VNC extension running!
 vncext:      Listening for VNC connections on all interface(s), port 5950
 vncext:      created VNC server for screen 0
XKB: Failed to compile keymap
Keyboard initialization failed. This could be a missing or incorrect setup of xkeyboard-config.
(EE) 
Fatal server error:
(EE) Failed to activate virtual core keyboard: 2(EE)
```
