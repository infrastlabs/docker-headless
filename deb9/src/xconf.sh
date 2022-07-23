#!/bin/bash
AUDIO=$(echo $1|sed "s/param|//g")
FULL=$(echo $2|sed "s/param|//g")
# RUN=
echo -e "AUDIO=$AUDIO\nFULL=$FULL"
rm -f /xconf.sh /xdict.sh #del first, then execute?: avoid nonFULL's exit.

# xrdp-link
$RUN export xrdp=/usr/local/xrdp; \
  ln -s $xrdp/sbin/xrdp /usr/sbin/; ln -s $xrdp/sbin/xrdp-sesman /usr/sbin/;\
  ln -s $xrdp/sbin/xrdp-chansrv /usr/sbin/; ln -s $xrdp/bin/xrdp-keygen /usr/bin/;

# +headless
# sv_user: http://blog.chinaunix.net/uid-26817066-id-5792715.html
$RUN useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo headless \
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
# # /home/headless/.config权限..
# COPY --chown=headless:headless src/f/.config/emp${FULL} /home/headless/.config/

# +002
#Make sesman read environment variables #locale>xx.mo: dpkg conf, use debian's tpl.
# mkdir: cannot create directory '/home/headless/.config/plank': Permission denied
$RUN echo "welcome! HeadlessBox." > /etc/motd \
    && ln -s /usr/bin/vim.tiny /usr/bin/vt \
    && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
    && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" >> /home/headless/.bashrc; \
    \
    printf '%s\n' 'session required pam_env.so readenv=1' >> /etc/pam.d/xrdp-sesman; \
    sed -i "s^path-exclude /usr/share/locale/\*^# path-exclude /usr/share/locale/\*^g" /etc/dpkg/dpkg.cfg.d/docker; \
    mkdir -p  /usr/share/man/man1/; \
    su - headless -c "mkdir -p /home/headless/.config/plank/dock1/launchers"; \
    # rm -f /home/headless/.config/plank/dock1/launchers/*.dockitem;
    su - headless -c "wget https://m3.8js.net//20210522/tashanhe-shiqishune.mp3";
    # cd /tmp/; wget https://m3.8js.net//20210522/tashanhe-shiqishune.mp3;

##AUDIO###########################
# Setup D-Bus; ;
# cd: /home/headless/.qmmp/skins/: No such file or directory
$RUN test -z "$AUDIO" && exit 0;\
  mkdir -p /run/dbus/ && chown messagebus:messagebus /run/dbus/; \
  dbus-uuidgen > /etc/machine-id; \
  ln -sf /etc/machine-id /var/lib/dbus/machine-id; \
  \
  # cd /home/headless/.qmmp/skins/; unzip Dark_Materia.wsz; chmod 755 -R darkmateria; \
  wget -qO /usr/share/backgrounds/xfce/pure-blue.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/pure-blue.jpg; \
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-litegrey.png;
  


##FULL###########################
# IBUS+DCONF env
$RUN test -z "$FULL" && exit 0;\
  find /home/headless/.config |wc; \
  mkdir -p /home/headless/.config/ibus/rime/; \
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
$RUN test -z "$FULL" && exit 0;\
  # bash -c "arr=\"$(cd /usr/share/locale1; ls)\"; for ONE in \${arr[@]}; do rm -rf /usr/share/locale/\$ONE ; ln -s /usr/share/locale1/\$ONE /usr/share/locale/ ; done"; \
  \
  # ohmybash
  su - headless -c "$(curl -fsSL https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh)"; \
  rm -rf /home/headless/.oh-my-bash/.git; bash -c 'cd /home/headless/.oh-my-bash/themes; rm -rf `ls |grep -v "axin\|sh$"`'; \
  \
  sed -i "s^value=\"gnome\"^value=\"Papirus-Bunsen-grey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml; \
  sed -i "s^OSH_THEME=\"font\"^OSH_THEME=\"axin\"^g" /home/headless/.bashrc; \
  # cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  \
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-blue-linestar.jpg; \
  # wget http://asia.pkg.bunsenlabs.org/debian/pool/main/b/bunsen-papirus-icon-theme/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  wget https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; 
