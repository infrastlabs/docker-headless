FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:xfce-deb9-v1 as loc
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:compile-v1 as bins
FROM debian:stretch-slim
ENV \
  DEBIAN_FRONTEND=noninteractive \
  LOC_APPS="tint2 plank thunar sakura geany rofi dunst" \
  LOC_APPS2="gnome-system-monitor engrampa ristretto" \
  LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4"

RUN domain="mirrors.163.com" \
  && echo "deb http://$domain/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
  && echo "deb http://$domain/debian/ stretch-updates main contrib non-free">> /etc/apt/sources.list; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt-get clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
  && chmod +x /usr/local/bin/apt.sh

# XRDP 26.673 MB
#  vncpasswd: tigervnc-common #66.6 kB;
# AUDIO 19.893 MB; pavucontrol:2,363 kB pnmixer:815 kB;  +pulseaudio:14.6 MB/ubt:2805kB; +qmmp:28.7 MB
#  chansrv: libfdk-aac.so.1
#  mkdir -p /var/run/dbus #E: [pulseaudio] core-util.c: Failed to connect to system bus: Failed to connect to socket /var/run/dbus/system_bus_socket: 没有那个文件或目录
# noVnc 9.793 MB 
#  python-numpy 4643 kB #warnings.warn("no 'numpy' module, HyBi protocol will be slower")
# BASE 4.279 MB
# FLUX 6.932 MB #dropbear 2M? #openssh-sftp-server 39.5 kB
RUN apt.sh \
  tigervnc-standalone-server tigervnc-common xrdp; \
  mkdir -p /etc/xrdp && xrdp-keygen xrdp auto && apt -y remove xrdp; \
  \
  apt.sh libfdk-aac1 pulseaudio supervisor; \
  \
  apt.sh wget ca-certificates python-numpy; \
  \
  apt.sh htop rsync tree tmux lrzsz psmisc fuse net-tools iputils-ping procps sudo iproute2 iptables \
  zip unzip xz-utils vim-tiny; \
  \
  apt.sh fluxbox stterm hsetroot xcompmgr  dropbear openssh-sftp-server lftp jq; \
  bash -c "rm -rf /usr/share/fluxbox{nls,styles}";

# NOVNC +1.352 MB; clear: 6.5M > 5.4M
# TODO +package.json: ui.js >> packageInfo.version
RUN export NO_VNC_HOME="/usr/local/novnc"; \
  mkdir -p ${NO_VNC_HOME}/utils/websockify \ 
  && wget -qO- https://github.com.cnpmjs.org/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME} \
  && wget -qO- https://github.com.cnpmjs.org/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME}/utils/websockify; \
  bash -c "cd /usr/local/novnc; rm -rf .github package.json README.md .gitignore .eslint* .gitmodules tests docs; rm -rf ./utils/websockify/{tests,Windows,docs}; ";

# --build-arg AUDIO=true
ARG AUDIO=""
# XFCE 36.596 MB; greybird.svg: 2.0M
# APP1 19.746 MB
# MP3 23.872 MB
# FluxEx: 735.819 KB; lxappearance ##xfce4-appearance-settings: no use in box.
# NOTIFY 864.768 KB; notifyd 234 kB; clipit 336 kB;
#  gtk2-engines-pixbuf 58.9 kB; ##Gtk-WARNING **: 11:29:10.844: 无法在模块路径中找到主题引擎：“pixmap”，
# Attach1: 684.210 KB  st.libharfbuzz0b 3447 kB 
#  apt.sh libharfbuzz0b; ln -s /usr/local/st/st /bin/stterm;
RUN test -z "$AUDIO" && exit 0;\
    apt.sh ${LOC_XFCE} greybird-gtk-theme; \
    rm -f /usr/share/backgrounds/greybird.svg; \
    \
    apt.sh tint2 plank thunar sakura dunst; \
    \
    apt.sh pavucontrol pnmixer qmmp; \
    \
    apt.sh lxappearance dbus-x11; \
    \
    apt.sh xfce4-notifyd clipit gtk2-engines-pixbuf && apt -y remove dunst; \
    \
    apt -y remove stterm; 

# --build-arg FULL=/..
ARG FULL=""
RUN test -z "$FULL" && exit 0;\
  domain="mirrors.163.com" \
  && echo "deb http://$domain/debian/ stretch-backports main non-free contrib">> /etc/apt/sources.list \
  && echo "deb http://$domain/debian-security/ stretch/updates main non-free contrib">> /etc/apt/sources.list;

# 19.642 MB; papirus-icon-theme:  backports?@deb9
# APPS2 5.624 MB gnome-system-monitor engrampa ristretto
# LOCALE 13.450 MB --language-pack-gnome-zh-hans 
RUN test -z "$FULL" && exit 0;\
  apt.sh at-spi2-core  geany rofi papirus-icon-theme; \
  \
  apt.sh ${LOC_APPS2}; \
  \
  apt.sh dconf-cli locales tzdata fonts-wqy-zenhei; \

#######largerApps 63.789 MB
# IBUS: 26.5 MB
# PIC: flameshot 10M, tumbler 6666kB(image cache) 10.5 MB (xrandr: x11-xserver-utils)
# AUDIO: mpv 36M;
# DEV: vscode 5.453 MB
# SHELL: git 12.4 MB; on-my-bash; asbru-cm 11.3M
RUN test -z "$FULL" && exit 0;\
  apt.sh ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  flameshot tumbler arandr  curl wget git \
  gnupg libsecret-1-0 libnss3 libxtst6 libasound2;
  

# ohmybash, asbru-cm: 10.269 MB
RUN test -z "$FULL" && exit 0;\
  curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash; \
  apt.sh asbru-cm; rm -f /etc/apt/sources.list.d/asbru-cm-release.list; \
  mv /opt/asbru /usr/local; rm -f /usr/bin/asbru-cm; ln -s /usr/local/asbru/asbru-cm /usr/bin/; \
  cd /usr/share/icons/hicolor/scalable/apps; rm -f asbru-cm.svg; ln -s /usr/local/asbru/res/asbru-logo.svg ./asbru-cm.svg

# Extend
# wps: libglu1-mesa 168Kb; wps_11.1.0.10161: xdg-utils 71.5 kB;
RUN test -z "$FULL" && exit 0;\
  apt.sh libglu1-mesa xdg-utils;

# moveUp 9.214 MB
COPY --from=loc /usr/share/locale1/emp${FULL} /usr/share/locale1

# xrdp0914, xrdp3: v0916
COPY --from=bins /usr/local/appdata/xrdp /usr/local/xrdp
COPY --from=bins /usr/local/sysdata/var/lib/xrdp-pulseaudio-installer /var/lib/xrdp-pulseaudio-installer
# COPY --from=bins /usr/local/st/st /usr/local/st/st
RUN ln -s /usr/local/xrdp/sbin/xrdp /usr/sbin/;\
  ln -s /usr/local/xrdp/sbin/xrdp-sesman /usr/sbin/;\
  ln -s /usr/local/xrdp/sbin/xrdp-chansrv /usr/sbin/;\
  ln -s /usr/local/xrdp/bin/xrdp-keygen /usr/bin/;

# COPY --chown=root:root ./src
ADD src/dot /etc/skel
ADD src/etc /etc
ADD src/*.sh /
ADD src/xrdp.conf /etc/supervisor/conf.d/xrdp.conf
ADD src/index.tpl.html /usr/local/novnc/index.tpl.html
Add src/clear3d.theme /usr/share/plank/themes/Default/dock.theme

# stterm: TERM="xterm|vt100"
ENV \
  TERM=xterm \
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  # HEADLESS=headless \ #just static username.
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  VNC_CERT= \
  VNC_OFFSET=0 \
  VNC_LIMIT=1 \
  # L=zh_CN \
  TZ=Asia/Shanghai


# +headless
# sv_user: http://blog.chinaunix.net/uid-26817066-id-5792715.html
# dbus-x11 fewSize 92.5Kb?, cause xvnc1,2: with two more processes. 
#  700; chown headless: can only run with headless; dbus-daemon/dbus-launch; dbus-*: x8;
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
# Make sesman read environment variables
# locale>xx.mo: dpkg conf, use debian's tpl.
RUN echo "welcome! HeadlessBox." > /etc/motd \
    && ln -s /usr/bin/vim.tiny /usr/bin/vt \
    && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
    && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" >> /home/headless/.bashrc; \
    \
    printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman; \
    sed -i "s^path-exclude /usr/share/locale/\*^# path-exclude /usr/share/locale/\*^g" /etc/dpkg/dpkg.cfg.d/docker; \
    mkdir -p  /usr/share/man/man1/; \
    su - headless -c "mkdir -p /home/headless/.config/plank/dock1/launchers";
    # rm -f /home/headless/.config/plank/dock1/launchers/*.dockitem;

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
#  dconf load / < dconf.ini  ##error: Cannot autolaunch D-Bus without X11 $DISPLAY
#  ADD > COPY
ADD src/f/dconf.ini /usr/share/dconf.ini 
COPY src/f/.config/emp${FULL} /home/headless/.config/
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
# ref: mkdir /usr/share/locale1/emp/
# COPY --from=loc /usr/share/locale1/emp${FULL} /usr/share/locale1
# theme <property name="IconThemeName" type="string" value="gnome"/>
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
  wget http://asia.pkg.bunsenlabs.org/debian/pool/main/b/bunsen-papirus-icon-theme/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; 


WORKDIR /home/headless
# EXPOSE 3389/tcp 6080/tcp 22/tcp 6000/tcp 4713/tcp
# CMD ["supervisord", "-n"]
EXPOSE 10089/tcp 10081/tcp 10022/tcp
CMD ["/entry.sh"]