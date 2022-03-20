FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:xfce-deb9-v1 as loc
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:compile-v1 as xrdpbin
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/novnc-audio:bcs as bcs
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:box07-slim as box07
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-ubuntu-desktop-vnc:x11 as Xvnc
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-ubuntu-desktop-vnc:compile31 as bin2

# ==DO: 用1个空镜像，再转一层： x5+6+2=13 > 1层;
FROM scratch as files
  ARG FULL=""
  # NOVNC +1.352 MB; clear: 6.5M > 5.4M
  COPY --from=box07 /usr/local/novnc /usr/local/novnc
  # locale 9.214 MB
  COPY --from=loc /usr/share/locale1/emp${FULL} /usr/share/locale1
  # xrdp0914, xrdp3: v0916
  COPY --from=xrdpbin /usr/local/appdata/xrdp /usr/local/xrdp
  COPY --from=xrdpbin /usr/local/sysdata/var/lib/xrdp-pulseaudio-installer /var/lib/xrdp-pulseaudio-installer
  COPY --from=bcs /app/broadcast-server /usr/local/novnc-audio/broadcast-server
  # up tigervnc: v1.10.1 for gnome, cinnamon
  COPY --from=Xvnc /usr/bin/Xvnc /usr/bin/Xvnc
  COPY --from=Xvnc /usr/lib64/swrast_dri.so /usr/lib64/swrast_dri.so
  COPY --from=Xvnc /usr/lib64/xorg/protocol.txt /usr/lib64/xorg/protocol.txt
  COPY --from=bin2 /src/webhookd /usr/local/webhook/webhookd
  
FROM scratch as files2
  # COPY --chown=root:root ./src
  ADD src/dot /etc/skel
  ADD src/etc /etc
  ADD src/*.sh /
  ADD src/xrdp.conf /etc/supervisor/conf.d/xrdp.conf
  ADD src/index.tpl.html /usr/local/novnc/index.tpl.html
  Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme
  COPY src/f/dconf.ini /usr/share/dconf.ini 
  ADD src/xdict.* /usr/local/webhook/scripts/
  # RUN bash xxx ##TODO single file bash: goBash?? > xrdp-link; qmmp unpack;

FROM debian:stretch-slim
ENV \
  DEBIAN_FRONTEND=noninteractive \
  LOC_APPS="tint2 plank thunar sakura" \
  LOC_APPS2="gnome-system-monitor engrampa ristretto" \
  LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4"

RUN domain="mirrors.aliyun.com" \
  && echo "deb http://$domain/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
  && echo "deb http://$domain/debian/ stretch-updates main contrib non-free">> /etc/apt/sources.list; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt-get clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
  && chmod +x /usr/local/bin/apt.sh; \
  \
  # XRDP 26.673 MB
  # \18.0 MB
  apt.sh tigervnc-standalone-server tigervnc-common xrdp; \
    mkdir -p /etc/xrdp && xrdp-keygen xrdp auto && apt -y remove xrdp; \
  # \23.4 MB
  apt.sh libfdk-aac1 pulseaudio supervisor; \
  # \5984 kB
  apt.sh wget ca-certificates python-numpy; \
  # \
  apt.sh curl lame sox libsox-fmt-mp3; \
  # \5868 kB
  apt.sh htop rsync tree tmux lrzsz psmisc fuse net-tools iputils-ping procps sudo iproute2 iptables \
  zip unzip xz-utils vim-tiny; \
  # \6248 kB
  apt.sh fluxbox stterm hsetroot xcompmgr  dropbear-bin dropbear-run openssh-sftp-server lftp jq; \
  bash -c "rm -rf /usr/share/fluxbox{nls,styles}";

# --build-arg AUDIO=true --build-arg FULL=/..
ARG AUDIO=""
#XFCE 36.596 MB; #APP1 19.746 MB; #MP3 23.872 MB
RUN test -z "$AUDIO" && exit 0;\
    # \40.1 MB
    apt.sh ${LOC_XFCE} greybird-gtk-theme; \
    rm -f /usr/share/backgrounds/greybird.svg; \
    # \24.4 MB
    apt.sh ${LOC_APPS}; \
    # \18.8 MB
    apt.sh pavucontrol pnmixer qmmp; \
    # \82.0 kB
    apt.sh lxappearance dbus-x11; \
    # \615 kB 
    apt.sh xfce4-notifyd clipit gtk2-engines-pixbuf; \
    \
    apt -y remove stterm; 

# --build-arg FULL=/..
ARG FULL=""
RUN test -z "$FULL" && exit 0;\
  domain="mirrors.aliyun.com" \
  && echo "deb http://$domain/debian/ stretch-backports main non-free contrib">> /etc/apt/sources.list \
  && echo "deb http://$domain/debian-security/ stretch/updates main non-free contrib">> /etc/apt/sources.list; \
  \
  #19.642 MB; #APPS2 5.6 MB #LOCALE 13.4 MB
  # \14.8 MB
  apt.sh at-spi2-core  geany rofi papirus-icon-theme; \
  # \5729 kB
  apt.sh ${LOC_APPS2}; \
  # \11.6 MB
  apt.sh dconf-cli locales tzdata fonts-wqy-zenhei; \
  \
  ##largerApps 63.789 MB  #IBUS: 26.5 MB #PIC: flameshot 10M, tumbler 6666kB(image cache); git 12.4 MB; 
  # \24.8 MB
  apt.sh ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi; \
  # \18.4 MB
  apt.sh flameshot tumbler arandr; \
  # \6160 kB
  apt.sh git; \
  # \2249 kB
  apt.sh gnupg libsecret-1-0 libnss3 libxtst6 libasound2 libglu1-mesa xdg-utils;
  
# asbru-cm: 10.5 MB
RUN test -z "$FULL" && exit 0;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg

# stterm: TERM="xterm|vt100"
ENV \
  TERM=xterm \
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  BCS_PORT=10082 \
  # HEADLESS=headless \ #just static username.
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  # 
  VNC_SSL_ONLY=false \
  VNC_CERT= \
  # TODO: setRange; 再由客户端自行指定所要的端口;
  VNC_OFFSET=0 \
  VNC_LIMIT=1 \
  VNC_INIT="" \
  # VNC_INIT="23|mate,24|cinna,25|xfce,26|flux" \
  # VNC_INIT="21|gnome,22|plama,23|mate,24|cinna,25|xfce,26|flux" \
  # L=zh_CN \
  TZ=Asia/Shanghai

COPY --from=files / /
COPY --from=files2 / /
RUN bash /xconf.sh "param|${AUDIO}" "param|${FULL}"
# /home/headless/.config权限..
COPY --chown=headless:headless src/f/.config/emp${FULL} /home/headless/.config/
RUN test -z "$AUDIO" && exit 0;\ 
  test -z "$FULL" && apt.sh gnome-system-monitor; \
  cd /home/headless/.qmmp/skins/; unzip Dark_Materia.wsz; chmod 755 -R darkmateria; \
  test -z "$FULL" && exit 0;\ 
  # replace bg with: xfce-blue.jpg
  cat /usr/share/backgrounds/xfce/xfce-blue.jpg > /usr/share/backgrounds/xfce/xfce-teal.jpg; \
  cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  bash -c "arr=\"$(cd /usr/share/locale1; ls)\"; for ONE in \${arr[@]}; do rm -rf /usr/share/locale/\$ONE ; ln -s /usr/share/locale1/\$ONE /usr/share/locale/ ; done";

WORKDIR /home/headless
EXPOSE 10089/tcp 10081/tcp 10022/tcp
CMD ["/entry.sh"]