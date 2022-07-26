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
  ADD src/sv.conf /etc/supervisor/conf.d/xrdp.conf
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
  apt.sh tumbler gtk2-engines-pixbuf supervisor gnupg \
  \
  # LOC_APPS2="gnome-system-monitor engrampa ristretto" # 11.2 MB 
  geany sakura \
  gnome-system-monitor engrampa ristretto \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans

# FULL(icon,ibus,git,flameshot) 49.1 MB
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

# ASBRU: 3586 kB (disk: 15.5 MB)
RUN echo 1;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg

RUN apt.sh xinit xterm x11-xkb-utils systemd fluxbox

# HEADLESS
COPY --from=files1 / /
COPY --from=files2 / /
RUN bash /xconf.sh

COPY src/*.service /etc/systemd/system/
RUN dpkg-divert --local --rename --add /sbin/udevadm; \
  ln -s /bin/true /sbin/udevadm; \
  systemctl enable de-entry; \
  systemctl enable de-start; \
  systemctl disable dropbear; \
  systemctl disable supervisor; \
  # systemctl mask supervisor; \
  systemctl disable systemd-resolved; 
RUN find / |grep -v "^/sys\|^/proc" |grep systemd |grep ".service$" |grep "supervi" |while read one; do echo $one; rm -f $one; done  

ENV \
  # XDG_CURRENT_DESKTOP=XFCE \
  TERM=xterm \
  SHELL=/bin/bash \
  L="zh_CN" \
  TZ="Asia/Shanghai" \
  \
  # DISPLAY="localhost:35" \
  # PULSE_SERVER="tcp:localhost:4735"
  \
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
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
# CMD ["/entry.sh"]
# CMD ["/sbin/init"]
CMD ["bash", "-c", "env |while read one; do echo export $one >> /env.txt; done; exec /sbin/init"]
