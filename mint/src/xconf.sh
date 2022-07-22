#!/bin/bash
rm -f /xconf.sh

$RUN \
  export user=headless; \
  useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo $user \
  && echo "$user:$user" |chpasswd \
  && echo 'Cmnd_Alias SU = /bin/su' >> /etc/sudoers \
  && echo "$user ALL=(root) NOPASSWD: ALL" >> /etc/sudoers \
  \
  && chmod +x /*.sh; \
  test -f /usr/bin/dbus-daemon && chmod 700 /usr/bin/dbus-* || echo "dbus skip chmod."; \
  test -f /usr/bin/dbus-daemon && chown headless:headless /usr/bin/dbus-* || echo "dbus skip chown."; \
  \
  chmod +x /*.sh \
  && echo "welcome! HeadlessBox." > /etc/motd \
  && ln -s /usr/bin/vim.tiny /usr/bin/vt \
  && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
  && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" >> /home/$user/.bashrc


# +002
$RUN \
    # echo "welcome! HeadlessBox." > /etc/motd \
    # && ln -s /usr/bin/vim.tiny /usr/bin/vt \
    # && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
    # && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" >> /home/headless/.bashrc; \
    \
    mkdir -p  /usr/share/man/man1/; \
    su - headless -c "mkdir -p /home/headless/.config/plank/dock1/launchers"; \
    su - headless -c "wget https://m3.8js.net//20210522/tashanhe-shiqishune.mp3";

##AUDIO###########################
# Setup D-Bus; ;
$RUN \
  mkdir -p /run/dbus/ && chown messagebus:messagebus /run/dbus/; \
  dbus-uuidgen > /etc/machine-id; \
  ln -sf /etc/machine-id /var/lib/dbus/machine-id; 
  

##FULL###########################
# IBUS+DCONF env
$RUN \
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
  su - headless -c "dbus-launch dconf reset -f /; dbus-launch dconf load / < /home/headless/dconf.ini; ";\
  dbus-launch dconf update;

# LOCALE, OHMYBASH, SETTINGS
$RUN \
  # ohmybash
  su - headless -c "$(curl -fsSL https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh)"; \
  rm -rf /home/headless/.oh-my-bash/.git; bash -c 'cd /home/headless/.oh-my-bash/themes; rm -rf `ls |grep -v "axin\|sh$"`'; \
  \
  # sed -i "s^value=\"gnome\"^value=\"Papirus-Bunsen-grey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml; \
  sed -i "s^OSH_THEME=\"font\"^OSH_THEME=\"axin\"^g" /home/headless/.bashrc; \
  \
  # wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/deploy/assets/bg-blue-linestar.jpg; \
  wget https://gitee.com/infrastlabs/docker-headless/raw/dev/deploy/assets/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; 
