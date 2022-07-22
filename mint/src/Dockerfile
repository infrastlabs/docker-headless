# back-back: https://gitee.com/huapox/fk-docker-ubuntu-desktop-vnc/blob/aa21d6805d25537d68e29aa1d88af46e7e00640c/src/Dockerfile.cxfce
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
RUN export DOMAIN="mirrors.aliyun.com"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh
 
COPY mate/excludes /etc/dpkg/dpkg.cfg.d/excludes

# TOOLS
RUN \
  # \2487 kB
  apt.sh wget ca-certificates; \
  # \5529 kB 
  apt.sh curl lame sox libsox-fmt-mp3; \
  # \4610 kB
  apt.sh htop rsync tree tmux lrzsz psmisc fuse net-tools iputils-ping procps sudo iproute2 iptables \
  zip unzip xz-utils vim-tiny; \
  # \2476 kB
  apt.sh dropbear-bin dropbear-run openssh-sftp-server lftp jq;

#LOCALE 15.0 MB 
RUN apt.sh dconf-cli locales tzdata apt-utils fonts-wqy-zenhei ;
# Audio 39.8 MB 
# pnmixer
RUN apt.sh pulseaudio pavucontrol ;
# VIDEO: 30.5 MB
# libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
RUN apt.sh libgl1-mesa-glx mesa-utils 

# MISC
# rofi clipit 
RUN \
  # \11.2 MB 
  apt.sh geany sakura \
  gnome-system-monitor engrampa ristretto \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans

# RUN apt.sh greybird-gtk-theme gnome-icon-theme  papirus-icon-theme ;
RUN export DOMAIN="mirrors.163.com"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list;

# REF: docker-gui > ubt2004-mint-cinna
# http://packages.linuxmint.com/
# https://mirrors.tuna.tsinghua.edu.cn/linuxmint
# 2536 kB
RUN apt.sh gnupg; \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/linuxmint una main upstream import backport">> /etc/apt/sources.list; \
  LINUX_MINT_KEY=$(apt update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | xargs) && \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 ${LINUX_MINT_KEY}; \
  apt clean && rm -rf /var/lib/apt/lists/*;

# 18.9 MB 
# deps: cpp cpp-9
RUN apt.sh xfce4-settings xfce4-session xfwm4 xfdesktop4 \
  xfce4-notifyd

# XFCE
# ENV \
#   LOC_APPS="tint2 plank thunar sakura" \
#   LOC_APPS2="gnome-system-monitor engrampa ristretto" \
#   LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4"
# RUN apt.sh ${LOC_XFCE} tint2 plank
# clipit; +nc 
# 7056 kB
RUN apt.sh thunar tumbler tint2 plank rofi netcat \
  lxappearance xfce4-notifyd clipit gtk2-engines-pixbuf

# 70.5 MB
  # clean: /usr/share
# RUN apt.sh mint-x-icons
RUN apt.sh mint-y-icons mint-themes; \
# RUN \
  # cd /usr/share/xfce4/backdrops; rm -f `ls |grep -v "linuxmint.jpg"`; \
  # cd /usr/share/backgrounds; rm -rf linuxmint*; rm -f xfce/{xfce-strips,xfce-verticals}.png; \
  cd /usr/share/icons; rm -rf `ls |grep "Mint-X\|Humanity\|Ubuntu-Mono\|LoginIcons"`; \
  cd /usr/share/themes; rm -rf `ls |grep -v "Mint-Y"`; \
  cd /usr/share/locales; rm -rf `ls |grep -v "locale.alias\|zh\|en"`; \
  cd /usr/share/i18n/locales; rm -rf `ls |grep -v "locale.alias\|zh\|en"`; 
  # cd /usr/share/applications; rm -rf `ls |grep "kde"`;     

RUN \
  #19.642 MB; #APPS2 5.6 MB #LOCALE 13.4 MB
  # \14.4 MB
  apt.sh  papirus-icon-theme; \
  \
  # \12.3 MB
  apt.sh ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi; \
  # \20.5 MB
  apt.sh flameshot arandr; \
  # \12.6 MB
  apt.sh git; \
  # \343 kB
  apt.sh gnupg libsecret-1-0 libnss3 libxtst6 libasound2 libglu1-mesa xdg-utils;
  
# asbru-cm: 10.5  (apt down: 3585 kB)
RUN \
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg

# +pnmixer: 159 kB 
RUN apt.sh pnmixer

ADD src/bin/pkgsize /bin/pkgsize
COPY src/*.service /etc/systemd/system/
RUN dpkg-divert --local --rename --add /sbin/udevadm; \
  ln -s /bin/true /sbin/udevadm; \
  systemctl enable de-start; \
  systemctl disable systemd-resolved; 
  # systemctl disable gdm3;

# HEADLESS
COPY src/*.sh /
ADD src/dot /etc/skel
# ADD src/pepper_skel /etc/skel
ADD src/mint-artwork-xfce /etc/skel
# +xf
ADD src/xf /etc/skel
RUN bash /xconf.sh
RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*;

ENV \
  # mintwelcome
  XDG_CURRENT_DESKTOP=XFCE \
  TERM=xterm \
  SHELL=/bin/bash \
  L="zh_CN" \
  TZ="Asia/Shanghai" \
  SKIP_X11CHECK="true" \
  DESKTOP="xfce" \
  DISPLAY="localhost:35" \
  PULSE_SERVER="tcp:localhost:4735"


STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup"]
# ENTRYPOINT /entry.sh
ENTRYPOINT ["/entry.sh"]
CMD ["xfce4-session"]
