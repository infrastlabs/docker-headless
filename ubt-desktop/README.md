# desktop

- Gnome: 基于Ubuntu官方版，找遍github只能在systemd下跑 (+elementaryos)
- Plasma: 基于Kubuntu 注：启动plasma需要privilege权限; cent7下跑不起来(Qt依赖库错误，kernel版本有关?)
- Cinna: 基于Mint, 无裁剪，欢迎页，有屏保锁屏
- Mate: 基于Mint, 无裁剪，欢迎页，有屏保锁屏
- Xfce4: 基于Mint, 清理Icon资源，集成Docky

SYS|TYPE|DE|WM
---|---|---|---
ubt2004|GShell|ele|gala/metacity
ubt2004|KShell|neon|kwin
ubt2004|Mint|mate|Marco
ubt2004|Mint|cinna|xx
ubt2004|Mint|xfce|xfwm
ubt2004|Box|flux|flux


## 使用

```bash
# https://github.com/darkdragon-001/Dockerfile-Ubuntu-Gnome #ubt2004: fks 57, star 16
docker  run -it --rm -p 10081:10081 -p 10089:10089 \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
infrastlabs/docker-headless:gnome

# plasma: 需要privileged 否则start_kdeinit: Operation not permitted
docker  run -it --rm -p 11081:10081 -p 11089:10089   --tmpfs /run --tmpfs /run/lock --tmpfs /tmp   --privileged   -v /sys/fs/cgroup:/sys/fs/cgroup infrastlabs/docker-headless:plasma
```

**TODO**

- gnome: ibus-daemon -drx; tray图标才出来

## 问题记录

- ele: gala
- neon: # --: lib err

```bash
# Plasma: cent7下跑不起来(Qt依赖库错误，kernel版本有关?)
#   PVE6.3-2; SUSE12环境下正常
[root@node191 desktop]# docker exec -it 70610f748a4d bash
root@70610f748a4d:/home/headless# startplasma-x11 
startplasma-x11: error while loading shared libraries: libQt5Core.so.5: cannot open shared object file: No such file or directory
root@70610f748a4d:/home/headless# su - headless
headless @ 70610f748a4d in ~ |12:21:55  
$ startplasma-x11
startplasma-x11: error while loading shared libraries: libQt5Core.so.5: cannot open shared object file: No such file or directory
```

**docky**

```bash
# 依赖大；容器下使用体验不好，延迟/卡顿(改用plank/xcompmgr)
# docky@ubt2004: https://blog.csdn.net/Nozidoali/article/details/119838043
RUN export DOMAIN="mirrors.ustc.edu.cn"; mkdir -p /tmp/docky/deps; cd /tmp/docky/deps; \
  wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1_amd64.deb; \
  wget http://archive.ubuntu.com/ubuntu/pool/universe/libg/libgnome-keyring/libgnome-keyring-common_3.12.0-1build1_all.deb; \
  wget http://archive.ubuntu.com/ubuntu/pool/universe/libg/libgnome-keyring/libgnome-keyring0_3.12.0-1build1_amd64.deb; \
  wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gnome-keyring-sharp/libgnome-keyring1.0-cil_1.0.0-5_amd64.deb; \
  wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gnome-sharp2/libgconf2.0-cil_2.24.2-4_all.deb;
  # sudo apt-get install ./*.deb
RUN mkdir -p /tmp/docky; cd /tmp/docky; \
  wget http://archive.ubuntu.com/ubuntu/pool/universe/d/docky/docky_2.2.1.1-1_all.deb;
  # sudo apt-get install ./docky_2.2.1.1-1_all.deb
# docky deps: 14.6M #err-noPkg: libgconf2.0-cil libgnome-keyring1.0-cil  #nonSysd-run-err: DBus not find.
RUN apt.sh mono-runtime libdbus-glib2.0-cil libdbus2.0-cil libgkeyfile1.0-cil libglib2.0-cil libgtk2.0-cil \
  libmono-addins0.2-cil libmono-cairo4.0-cil libmono-corlib4.5-cil libmono-posix4.0-cil libmono-sharpzip4.84-cil libmono-system-core4.0-cil \
  libmono-system-web4.0-cil libmono-system-xml-linq4.0-cil libmono-system-xml4.0-cil libmono-system4.0-cil libnotify0.4-cil libwnck22 gconf2
# docky_2.2.0-2_all.deb	2013-11-19 19:03 	592K
# docky_2.2.1.1-1_all.deb	2015-09-03 09:23 	609K
# http://archive.ubuntu.com/ubuntu/pool/universe/d/docky/
RUN cd /tmp/docky/deps; apt -y install ./*.deb; \
  cd /tmp/docky; apt -y install ./docky_2.2.1.1-1_all.deb; \
  mkdir -p /home/headless/.config/autostart; \
  cp /usr/share/applications/docky.desktop /home/headless/.config/autostart/

```