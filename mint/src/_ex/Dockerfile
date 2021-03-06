FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:mint-compile as Xvnc
FROM scratch as files1
  COPY --from=Xvnc /tigervnc-pkg/tigervnc-1.12.0.x86_64 /
  COPY --from=Xvnc /rootfs /

FROM scratch as files2
  # Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme
  # COPY src/f/dconf.ini /usr/share/dconf.ini 
  # 
  COPY src/*.sh /
  ADD src/etc /etc
  ADD src/dot /etc/skel
  ADD src/xf /etc/skel
  ADD src/.mint-artwork-xfce /etc/skel
  ADD src/sv.conf /etc/supervisor/conf.d/xrdp.conf
  # dest: /bin > /usr/bin; avoid softLink's replace
  ADD src/bin/pkgsize /usr/bin/pkgsize

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
# mirrors.tuna.tsinghua.edu.cn
# mirrors.ustc.edu.cn
# mirrors.aliyun.com
# mirrors.163.com
RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh
 
COPY src/excludes /etc/dpkg/dpkg.cfg.d/excludes

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
RUN \
  # LOCALE 15.0 MB 
  apt.sh dconf-cli locales tzdata apt-utils fonts-wqy-zenhei \
  # Audio 39.8 MB 
  pulseaudio pavucontrol \
  # VIDEO: 30.5 MB
  # libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
  libgl1-mesa-glx mesa-utils 


# APPS 25.7 MB
RUN \
  # LOC_APPS="tint2 plank thunar sakura" # clipit; +pnmixer: 159 kB; +sv # 7056 kB
  apt.sh tumbler tint2 plank rofi \
  clipit pnmixer lxappearance gtk2-engines-pixbuf supervisor gnupg \
  \
  # LOC_APPS2="gnome-system-monitor engrampa ristretto" # 11.2 MB 
  geany sakura \
  gnome-system-monitor engrampa ristretto \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans

# FULL(icon,ibus,git,flameshot) 49.1 MB
# _ex: papirus-icon-theme 
RUN \
  #19.642 MB; #APPS2 5.6 MB #LOCALE 13.4 MB
  # \14.4 MB
  apt.sh  \
  # \12.3 MB
  ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  # \20.5 MB
  flameshot arandr \
  # \12.6 MB
  git \
  # \343 kB
  libsecret-1-0 libnss3 libxtst6 libasound2 libglu1-mesa xdg-utils \
  # xrdp-chansrv
  libfdk-aac1;

# 2536 kB
# REF: docker-gui > ubt2004-mint-cinna
# http://packages.linuxmint.com/ # https://mirrors.tuna.tsinghua.edu.cn/linuxmint
RUN \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/linuxmint una main upstream import backport">> /etc/apt/sources.list; \
  LINUX_MINT_KEY=$(apt update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | xargs) && \
  echo "LINUX_MINT_KEY: $LINUX_MINT_KEY"; \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 ${LINUX_MINT_KEY}; \
  apt clean && rm -rf /var/lib/apt/lists/*;

# 18.9 MB > 14.3 MB
# LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4" # deps: cpp cpp-9
RUN apt.sh xfce4-settings xfce4-session xfwm4 xfdesktop4 \
  xfce4-notifyd thunar

# 70.5 MB --
# mint-x-icons # clean: /usr/share
RUN apt.sh mint-y-icons mint-themes; \
# RUN \
  # cd /usr/share/xfce4/backdrops; rm -f `ls |grep -v "linuxmint.jpg"`; \
  # cd /usr/share/backgrounds; rm -rf linuxmint*; rm -f xfce/{xfce-strips,xfce-verticals}.png; \
  cd /usr/share/icons && rm -rf `ls |grep "Mint-X\|Humanity\|Ubuntu-Mono\|LoginIcons"`; \
  cd /usr/share/themes && rm -rf `ls |grep -v "Mint-Y"`; \
  cd /usr/share/locales && rm -rf `ls |grep -v "locale.alias\|zh\|en"`; \
  cd /usr/share/i18n/locales && rm -rf `ls |grep -v "locale.alias\|zh\|en"`; \
  # 80M > 42M
  cd /usr/share/icons/Mint-Y/apps && rm -rf 256* 96*; 
  # cd /usr/share/applications; rm -rf `ls |grep "kde"`;     

# ASBRU: 3586 kB (disk: 15.5 MB)
RUN echo 1;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg


# webhookd, noVNC
RUN cd /tmp; file=webhookd.tar.gz; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/attach_files/1135812/download/$file; \
  mkdir -p /usr/local/webhookd; tar -zxvf $file -C /usr/local/webhookd; rm -f $file
RUN cd /usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -fSL -k -O https://hub.fastgit.xyz/novnc/noVNC/archive/$file; \
  bash down_vnc.sh; rm -f $file

# HEADLESS
COPY --from=files1 / /
COPY --from=files2 / /
RUN bash /xconf.sh

# libopus0: /usr/local/xrdp/sbin/xrdp-chansrv
RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  apt.sh libopus0
ADD src/bcs_push.sh /usr/local/webhookd/static/bcs_push.sh

ENV \
  # mintwelcome
  XDG_CURRENT_DESKTOP=XFCE \
  TERM=xterm \
  SHELL=/bin/bash \
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
  # 
  VNC_OFFSET=10 \
  VNC_LIMIT=1
  # VNC_INIT="21|gnome,22|plama,23|mate,24|cinna,25|xfce,26|flux" \

STOPSIGNAL SIGRTMIN+3
WORKDIR /home/headless
EXPOSE 10089/tcp 10081/tcp 10022/tcp
CMD ["/entry.sh"]