# ubt

- 镜像: 包含x86_64, arm64两个体系的镜像
- 版本: 标准版，slim版(不含3D显卡，输入法，Flameshot, Git)
- 集成systemd(2M), 以仿真实际Linux桌面发行版
- 基础能力
  - tigervnc
  - xrdp, pulse
  - webhookd, noVNC
  - misc, 多语言，显卡/输入法，常用软件

**arm64**

```bash
[root@arm-ky10-23-2 ~]# docker  run -it --rm --cap-add SYS_ADMIN  --net=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw  --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock infrastlabs/docker-headless:core-v4-arm
```

**systemd**

```bash
docker  run -it --rm -p 10481:10081 --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup \
 --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock \
 infrastlabs/docker-headless:core-v4


# deb11-gemmibook
# https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva
docker  run -it --rm --cap-add SYS_ADMIN  -p 10281:10081 -p 10289:10089 \
-v /sys/fs/cgroup:/sys/fs/cgroup:rw  --cgroupns=host --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock  \
infrastlabs/docker-headless:core-v4-slim /sbin/init


# headless @ mac23-199 in ~ |13:55:34  
$ docker  run -it --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup --mount type=tmpfs,dst=/run --mount type=tmpfs,dst=/run/lock  jrei/systemd-ubuntu
Status: Downloaded newer image for jrei/systemd-ubuntu:latest
systemd 245.4-4ubuntu3.17 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
Detected virtualization docker.
Detected architecture x86-64.

Welcome to Ubuntu 20.04.4 LTS!

Set hostname to <66e574fa20fb>.
Couldn't move remaining userspace processes, ignoring: Input/output error
[  OK  ] Reached target Paths.
[  OK  ] Reached target Slices.
[  OK  ] Reached target Swap.
[  OK  ] Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket.
         Starting Remount Root and Kernel File Systems...
         Starting Create Static Device Nodes in /dev...
         Starting Journal Service...
[  OK  ] Finished Create Static Device Nodes in /dev.
[  OK  ] Finished Remount Root and Kernel File Systems.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
[  OK  ] Started Journal Service.
         Starting Create Volatile Files and Directories...
[  OK  ] Finished Create Volatile Files and Directories.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.
```

**tigervnc**

```bash
# org's x86_64 binary
root@e981b479d4d5:/tigervnc-pkg/tigervnc-1.12.0.x86_64# ls -lh usr/bin/
total 26M
-rwxr-xr-x 1 984 980  13M Nov  9  2021 Xvnc
-rwxr-xr-x 1 984 980 1.2M Nov  9  2021 vncconfig
-rwxr-xr-x 1 984 980 124K Nov  9  2021 vncpasswd
-rwxr-xr-x 1 984 980 6.8M Nov  9  2021 vncviewer
-rwxr-xr-x 1 984 980 4.9M Nov  9  2021 x0vncserver

# compile ref-default
root@af89f9cbc925:/rootfs/usr/local/tigervnc/bin# ls -lh
total 33M
-rwxr-xr-x 1 root root 16M Aug  5 05:16 Xvfb
-rwxr-xr-x 1 root root 18M Aug  5 05:16 Xvnc

# --disable-static
# deps: apt install libjpeg8 libunwind8 libpixman-1-0 libxfont2 libxau6 libxdmcp6 libgl1 --no-install-recommends
root@e981b479d4d5:/rootfs/usr/local/tigervnc/bin# ls -lh
total 33M
-rwxr-xr-x 1 root root 16M Aug  5 05:58 Xvfb
-rwxr-xr-x 1 root root 18M Aug  5 05:58 Xvnc

# --enable-xvfb > --disable-xvfb #不生成xvfb
root@b4cc6e929d11:/rootfs/usr/local/tigervnc/bin# ls -lh
total 18M
-rwxr-xr-x 1 root root 18M Aug  5 06:21 Xvnc
```

- tiger@master ---- xorg-v21.1.1

```bash
# compile err
configure: error: Package requirements (fixesproto >= 6.0 damageproto >= 1.1 xcmiscproto >= 1.2.0 xtrans >= 1.3.5 bigreqsproto >= 1.1.0 xproto >= 7.0.31 randrproto >= 1.6.0 renderproto >= 0.11 xextproto >= 7.2.99.901 inputproto >= 2.3.99.1 kbproto >= 1.0.3 fontsproto >= 2.1.3 pixman-1 >= 0.27.2 libxcvt videoproto compositeproto >= 0.4 recordproto >= 1.13.99.1 scrnsaverproto >= 1.1 resourceproto >= 1.2.0 dri3proto presentproto >= 1.2 xineramaproto xkbfile  pixman-1 >= 0.27.2 xfont2 >= 2.0.0 xau libsystemd >= 209 xshmfence >= 1.1 xdmcp) were not met:

Requested 'fixesproto >= 6.0' but version of FixesProto is 5.0
Requested 'inputproto >= 2.3.99.1' but version of InputProto is 2.3.2
No package 'libxcvt' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables XSERVERCFLAGS_CFLAGS
and XSERVERCFLAGS_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.
```
