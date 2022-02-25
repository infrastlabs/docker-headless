FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:xfce-deb9-v1 as loc
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:compile-v1 as xrdpbin
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/novnc-audio:bcs as bcs
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:box07-slim as box07
FROM debian:stretch-slim
ENV \
  DEBIAN_FRONTEND=noninteractive \
  # LOC_APPS="tint2 plank thunar sakura geany rofi dunst" \
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

# --build-arg AUDIO=true
ARG AUDIO=""
#XFCE 36.596 MB; #APP1 19.746 MB; #MP3 23.872 MB
RUN test -z "$AUDIO" && exit 0;\
    # \40.1 MB
    apt.sh ${LOC_XFCE} greybird-gtk-theme; \
    rm -f /usr/share/backgrounds/greybird.svg; \
    # \24.4 MB
    apt.sh tint2 plank thunar sakura; \
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
  apt.sh at-spi2-core  geany rofi papirus-icon-theme; \
  \
  apt.sh ${LOC_APPS2}; \
  \
  apt.sh dconf-cli locales tzdata fonts-wqy-zenhei; \
  \
  ##largerApps 63.789 MB  #IBUS: 26.5 MB #PIC: flameshot 10M, tumbler 6666kB(image cache); git 12.4 MB; 
  apt.sh ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  \
  apt.sh flameshot tumbler arandr \
  \
  apt.sh curl wget git \
  \
  apt.sh gnupg libsecret-1-0 libnss3 libxtst6 libasound2 libglu1-mesa xdg-utils;
  
# ohmybash, asbru-cm: 10.269 MB
RUN test -z "$FULL" && exit 0;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg


# ==TODO: 用1个空镜像，再转一层： x5+6+2=13 > 1层;
# NOVNC +1.352 MB; clear: 6.5M > 5.4M
COPY --from=box07 /usr/local/novnc /usr/local/novnc
# locale 9.214 MB
COPY --from=loc /usr/share/locale1/emp${FULL} /usr/share/locale1
# xrdp0914, xrdp3: v0916
COPY --from=xrdpbin /usr/local/appdata/xrdp /usr/local/xrdp
COPY --from=xrdpbin /usr/local/sysdata/var/lib/xrdp-pulseaudio-installer /var/lib/xrdp-pulseaudio-installer
COPY --from=bcs /app/broadcast-server /usr/local/novnc-audio/broadcast-server

# COPY --chown=root:root ./src
ADD src/dot /etc/skel
ADD src/etc /etc
ADD src/*.sh /
ADD src/xrdp.conf /etc/supervisor/conf.d/xrdp.conf
ADD src/index.tpl.html /usr/local/novnc/index.tpl.html
Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme

COPY src/f/dconf.ini /usr/share/dconf.ini 
COPY src/f/.config/emp${FULL} /home/headless/.config/


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
  VNC_OFFSET=0 \
  VNC_LIMIT=1 \
  # L=zh_CN \
  TZ=Asia/Shanghai


# xrdp-link
RUN ln -s /usr/local/xrdp/sbin/xrdp /usr/sbin/;\
  ln -s /usr/local/xrdp/sbin/xrdp-sesman /usr/sbin/;\
  ln -s /usr/local/xrdp/sbin/xrdp-chansrv /usr/sbin/;\
  ln -s /usr/local/xrdp/bin/xrdp-keygen /usr/bin/;

# +headless
# sv_user: http://blog.chinaunix.net/uid-26817066-id-5792715.html
RUN useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo headless \
  && echo "headless:headless" |chpasswd \
  && echo 'Cmnd_Alias SU = /bin/su' >> /etc/sudoers \
  && echo "headless ALL=(root) NOPASSWD: ALL" >> /etc/sudoers \
  \
  && chmod +x /*.sh; \
  test -f /usr/bin/dbus-daemon && chmod 700 /usr/bin/dbus-* || echo "dbus skip chmod."; \
  test -f /usr/bin/dbus-daemon && chown headless:headless /usr/bin/dbus-* || echo "dbus skip chown."; \
  \
  line=$(cat /etc/supervisor/supervisord.conf |grep  "^chmod=0700" -n |cut -d':' -f1); \
  sed -i "${line}cchmod=0770" /etc/supervisor/supervisord.conf; \
  sed -i "${line}achown=headless:headless" /etc/supervisor/supervisord.conf; \
  mkdir -p /etc/novnc; rq=`date +%Y%m%d_%H%M%S`; openssl req -new -x509 -days 3650 -nodes -subj "/C=CA/ST=CA2/L=CA3/O=headless@docker/OU=update@image_$rq/CN=headless" -out /etc/novnc/self.pem -keyout /etc/novnc/self.pem;

# +002
#Make sesman read environment variables #locale>xx.mo: dpkg conf, use debian's tpl.
RUN echo "welcome! HeadlessBox." > /etc/motd \
    && ln -s /usr/bin/vim.tiny /usr/bin/vt \
    && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
    && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" >> /home/headless/.bashrc; \
    \
    printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman; \
    sed -i "s^path-exclude /usr/share/locale/\*^# path-exclude /usr/share/locale/\*^g" /etc/dpkg/dpkg.cfg.d/docker; \
    mkdir -p  /usr/share/man/man1/; \
    su - headless -c "mkdir -p /home/headless/.config/plank/dock1/launchers"; \
    # rm -f /home/headless/.config/plank/dock1/launchers/*.dockitem;
    cd /tmp/; wget https://m3.8js.net//20210522/tashanhe-shiqishune.mp3;

##AUDIO###########################
# Setup D-Bus; ;
RUN test -z "$AUDIO" && exit 0;\
  mkdir -p /run/dbus/ && chown messagebus:messagebus /run/dbus/; \
  dbus-uuidgen > /etc/machine-id; \
  ln -sf /etc/machine-id /var/lib/dbus/machine-id; \
  \
  cd /home/headless/.qmmp/skins/; unzip Dark_Materia.wsz; chmod 755 -R darkmateria; \
  wget -qO /usr/share/backgrounds/xfce/pure-blue.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/deploy/assets/pure-blue.jpg; \
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/deploy/assets/bg-debian-litegrey.png;
  


##FULL###########################
# IBUS+DCONF env
RUN test -z "$FULL" && exit 0;\
  find /home/headless/.config |wc; \
  ln -s /usr/share/rime-data/wubi_pinyin.schema.yaml /home/headless/.config/ibus/rime/; \
  chown -R headless:headless /home/headless/.config; \
  \
  # ibus env
  echo "export XMODIFIERS=@im=ibus" >> /etc/profile;\
  echo "export GTK_IM_MODULE=ibus" >> /etc/profile;\
  echo "export QT_IM_MODULE=ibus" >> /etc/profile;\
  \
  # dconf: ibus, plank, engrampa; dconf dump / > xx.ini
  mkdir -p /etc/dconf/db;\
  su - headless -c "dbus-launch dconf reset -f /; dbus-launch dconf load / < /usr/share/dconf.ini; ";\
  dbus-launch dconf update;

# LOCALE, OHMYBASH, SETTINGS
# ref: /usr/share/locale1/emp${FULL} #theme set; bgset;
RUN test -z "$FULL" && exit 0;\
  bash -c "arr=\"$(cd /usr/share/locale1; ls)\"; for ONE in \${arr[@]}; do rm -rf /usr/share/locale/\$ONE ; ln -s /usr/share/locale1/\$ONE /usr/share/locale/ ; done"; \
  \
  # ohmybash
  su - headless -c "$(curl -fsSL https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh)"; \
  rm -rf /home/headless/.oh-my-bash/.git; bash -c 'cd /home/headless/.oh-my-bash/themes; rm -rf `ls |grep -v "axin\|sh$"`'; \
  \
  sed -i "s^value=\"gnome\"^value=\"Papirus-Bunsen-grey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml; \
  sed -i "s^OSH_THEME=\"font\"^OSH_THEME=\"axin\"^g" /home/headless/.bashrc; \
  cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  \
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/deploy/assets/bg-blue-linestar.jpg; \
  # wget http://asia.pkg.bunsenlabs.org/debian/pool/main/b/bunsen-papirus-icon-theme/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  wget https://gitee.com/infrastlabs/docker-headless/raw/dev/deploy/assets/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; 

WORKDIR /home/headless
EXPOSE 10089/tcp 10081/tcp 10022/tcp
CMD ["/entry.sh"]