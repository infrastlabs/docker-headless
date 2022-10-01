# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-compile-arm as Xvnc
# FROM infrastlabs/docker-headless:mint-compile-arm as Xvnc
# FROM infrastlabs/docker-headless:core-compile-tiger as tiger
FROM infrastlabs/docker-headless:core-compile-multi as bin
FROM scratch as files1
  # ubt2004: tigervnc-standalone-server 1.10.1+dfsg-3
  # COPY --from=Xvnc /rootfs /rootfs
  # COPY --from=tiger /rootfs/usr/local/tigervnc /rootfs/usr/local/tigervnc
  COPY --from=bin /rootfs /rootfs

# FROM scratch as files2
FROM ubuntu:20.04 as files2
  # Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme
  # COPY src/f/dconf.ini /usr/share/dconf.ini 
  # 
  COPY src/*.sh /rootfs/
  ADD src/etc /rootfs/etc
  ADD src/dot /rootfs/etc/skel
  ADD src/bin /rootfs/usr/bin
  ADD src/sv.conf /rootfs/etc/supervisor/conf.d/sv.conf
  COPY src/*.service /rootfs/etc/systemd/system/
  RUN cd /rootfs/usr/bin; chmod +x *; \
    cd /rootfs/etc/skel/Desktop; chmod +x *.desktop    


FROM ubuntu:20.04
ENV \
  DEBIAN_FRONTEND=noninteractive \
  LOCALE_INCLUDE="zh_CN zh_HK zh_TW en en_AU fr fr_CA pt pt_BR es ar cs de it ru nl tr is sv uk ja ko th vi"
# mirrors.tuna.tsinghua.edu.cn
# mirrors.ustc.edu.cn
# mirrors.aliyun.com
# mirrors.163.com
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  test -z "$(echo $TARGETPLATFORM |grep arm)" && target=ubuntu || target=ubuntu-ports; \
  echo "deb http://${DOMAIN}/$target focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/$target focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  \
  # default:echo -e;
  echo "path-exclude /usr/share/doc/*\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/locale/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/help/*\n\
path-exclude /usr/share/lintian/*\n\
#path-exclude /usr/share/zoneinfo/*\n\
#path-exclude /usr/share/i18n/*\n\
# XKB: Failed to compile keymap
# path-exclude /usr/share/X11/*\n\
# path-include /usr/share/locale/zh_CN/*\n\
" > /etc/dpkg/dpkg.cfg.d/excludes; \
  echo $LOCALE_INCLUDE |sed "s/ /\n/g" |while read one; do echo "path-include /usr/share/locale/$one/*" >> /etc/dpkg/dpkg.cfg.d/excludes; done; \
  cat /etc/dpkg/dpkg.cfg.d/excludes; \
  rm -rf /usr/share/locale/* ; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh
 
# COPY src/excludes /etc/dpkg/dpkg.cfg.d/excludes

# MISC 15.1 MB
RUN \
  # \2487 kB
  apt.sh wget ca-certificates \
  # \5529 kB 
  curl lame sox libsox-fmt-mp3 \
  # \4610 kB
  htop rsync tree tmux lrzsz psmisc fuse net-tools netcat iputils-ping \
  procps sudo iproute2 iptables zip unzip xz-utils vim-tiny \
  # \2476 kB
  dropbear-bin dropbear-run openssh-sftp-server lftp jq;

# VID, AUD, LOC 87.4 MB
# xrdp-chansrv: libfdk-aac1 libopus0
RUN \
  # LOCALE 15.0 MB 
  apt.sh dconf-cli locales tzdata apt-utils fonts-wqy-zenhei \
  # Audio 39.8 MB 
  pulseaudio pavucontrol \
  \
  # 343 kB
  supervisor x11-xkb-utils libfdk-aac1 libopus0 \
  libsecret-1-0 libnss3 libxtst6 libasound2 xdg-utils \
  \
  # APPS 25.7 MB
  # LOC_APPS="tint2 plank thunar sakura" # clipit; +pnmixer: 159 kB; +sv # 7056 kB
  # LOC_APPS2="gnome-system-monitor engrampa ristretto" # 11.2 MB 
  geany sakura \
  gnome-system-monitor engrampa ristretto \
  \
  # 2422 kB #https://github.com/j8r/dockerfiles
  xinit xterm fluxbox systemd systemd-sysv

ARG FULL=""
RUN test -z "$FULL" && exit 0 || echo fullInstall;\  
  # VIDEO: 30.5 MB
  # libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
  apt.sh libgl1-mesa-glx mesa-utils libglu1-mesa \
  \
  tumbler gtk2-engines-pixbuf gnupg \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans \
  \
  # FULL(icon,ibus,git,flameshot) 49.1 MB
  # \12.3 MB
  ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  # \20.5 MB
  flameshot arandr \
  # \12.6 MB
  git;

# vncpasswd: tigervnc-common
# clipit|diodon
# tiger: deps libgl1-mesa-dri?
# RUN apt.sh tigervnc-standalone-server tigervnc-common #pnmixer clipit
RUN apt.sh \
    pnmixer clipit \
    xcompmgr dunst hsetroot
# tiger-compile: libgl1 27M;
# libgl1
RUN apt.sh libunwind8 libxfont2     
# ASBRU: 3586 kB (disk: 15.5 MB)
RUN echo 1;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg; \
  dpkg -l |grep asbru && exit 0 || exit 1;

# webhookd, noVNC
RUN echo a.12; \
  # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/webhookd-arm64.tar.gz
  cd /tmp; file=webhookd-arm64.tar.gz; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
  hookd=/usr/local/webhookd; mkdir -p $hookd; tar -zxvf $file -C $hookd; rm -f $file; \
  mv $hookd/webhookd-arm64 $hookd/webhookd; \
  sed -i 's^cmd="go run ./"^cmd=./webhookd^g' $hookd/run.sh; \
  \
  # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/v1.3.0.tar.gz
  cd /usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
  bash down_vnc.sh; rm -f $file;  

# vncpasswd
# RUN apt.sh tigervnc-common
# libgl1 24M
RUN apt.sh libgl1

# HEADLESS
# COPY --from=files1 /rootfs /rootfs_bin
# COPY --from=files2 /rootfs /rootfs_conf
COPY --from=files1 /rootfs /
COPY --from=files2 /rootfs /
# https://github.com/TigerVNC/tigervnc/issues/800 #bernhardu,2019=Tigervnc killed just after connect 
# LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1 vncserver :2 -localhost no
# link: Xvnc, vncpasswd
RUN rm -f /usr/bin/Xvnc; ln -s /usr/local/tigervnc/bin/Xvnc /usr/bin/Xvnc; \
  rm -f /usr/bin/vncpasswd; ln -s /usr/local/tigervnc/bin/vncpasswd /usr/bin/vncpasswd; \
  test -z "$(echo $TARGETPLATFORM |grep arm64)" || sed -i "s^exec Xvnc^LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1 exec Xvnc^g" /xvnc.sh

# fluxbox's conf
RUN bash /etc/skel/.fluxbox/fluxbox.sh
RUN bash /xconf.sh

ENV \
  # 使得Systemd识别到Docker是它的虚拟化环境
  container=docker \
  # LC_ALL=C \
  \
  # mintwelcome
  # XDG_CURRENT_DESKTOP=XFCE \
  TERM=xterm \
  SHELL=/bin/bash \
  # 默认约定
  # DISPLAY=":10" \ #取VNC_OFFSET
  L="zh_CN" \
  TZ="Asia/Shanghai" \
  \
  # DISPLAY="localhost:35" \
  # PULSE_SERVER="tcp:localhost:4735"
  \
  PORT_SSH=10022 \
  PORT_RDP=10089 \
  PORT_VNC=10081 \
  # 
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  \
  START_SESSION=xfce4-session \
  # 
  # test layer's change
  # AA1=01 \
  VNC_OFFSET=10
  # VNC_LIMIT=1
  # VNC_INIT="21|gnome,22|plama,23|mate,24|cinna,25|xfce,26|flux" \


CMD ["/entry.sh"]
WORKDIR /home/headless
EXPOSE 10089/tcp 10081/tcp 10022/tcp
VOLUME [ "/sys/fs/cgroup" ]
STOPSIGNAL SIGRTMIN+3
