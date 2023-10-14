#!/bin/bash
rm -f /xconf.sh

##########################################
# xrdp-link
$RUN export xrdp=/usr/local/xrdp;
if [ -s "$xrdp/sbin/xrdp" ]; then
  ln -s $xrdp/sbin/xrdp /usr/sbin/; ln -s $xrdp/sbin/xrdp-sesman /usr/sbin/;\
  ln -s $xrdp/sbin/xrdp-chansrv /usr/sbin/; ln -s $xrdp/bin/xrdp-keygen /usr/bin/;
  mkdir -p /etc/xrdp && xrdp-keygen xrdp auto #/etc/xrdp/rsakeys.ini
fi

##########################################
  # && ln -s /usr/bin/supervisorctl /usr/bin/sv \
$RUN \
  export user=headless; \
  useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo $user \
  && echo "$user:$user" |chpasswd \
  && echo 'Cmnd_Alias SU = /bin/su' |sudo tee -a /etc/sudoers \
  && echo "$user ALL=(root) NOPASSWD: ALL" |sudo tee -a /etc/sudoers \
  \
  && chmod +x /*.sh; \
  test -f /usr/bin/dbus-daemon && chmod 700 /usr/bin/dbus-* || echo "dbus skip chmod."; \
  test -f /usr/bin/dbus-daemon && chown headless:headless /usr/bin/dbus-* || echo "dbus skip chown."; \
  \
  chmod +x /*.sh \
  && echo "welcome! HeadlessBox." > /etc/motd \
  && ln -s /usr/bin/vim.tiny /usr/bin/vt \
  && rm -f /bin/sh && ln -s /bin/bash /bin/sh; \
  \
  mkdir -p /var/log/supervisor; \
  rm -f /usr/bin/sv; echo -e "#!/bin/bash\ntest -z "\$1" && go-supervisord ctl -h || go-supervisord ctl \$@" > /usr/bin/sv; chmod +x /usr/bin/sv; \
  echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" |sudo tee -a /home/$user/.bashrc


# +002
$RUN \
    # echo "welcome! HeadlessBox." > /etc/motd \
    # && ln -s /usr/bin/vim.tiny /usr/bin/vt \
    # && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
    # && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" |sudo tee -a /home/headless/.bashrc; \
    \
    mkdir -p  /usr/share/man/man1/; \
    su - headless -c "mkdir -p /home/headless/.config/plank/dock1/launchers"; \
    echo "curl mp3.." && su - headless -c "curl --connect-timeout 3 -k -O -fSL https://www.51mp3ring.com/51mp3ring_com3/at20131018141155.mp3";

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
  # 冗余? 复用/.env?
  echo "export XMODIFIERS=@im=ibus" |sudo tee -a /etc/profile;\
  echo "export GTK_IM_MODULE=ibus" |sudo tee -a /etc/profile;\
  echo "export QT_IM_MODULE=ibus" |sudo tee -a /etc/profile;\
  \
  # 独立/.env每次entry都重生成;
  echo "export XMODIFIERS=@im=ibus" |sudo tee -a /.env;\
  echo "export GTK_IM_MODULE=ibus" |sudo tee -a /.env;\
  echo "export QT_IM_MODULE=ibus" |sudo tee -a /.env;\
  \
  # dconf: ibus, plank, engrampa; dconf dump / > xx.ini
  mkdir -p /etc/dconf/db;\
  su - headless -c "dbus-launch dconf reset -f /; dbus-launch dconf load / < /home/headless/dconf.ini; ";\
  dbus-launch dconf update;

# SYSTEMD
$RUN \
  # systemd1
  cd /lib/systemd/system/sysinit.target.wants/ \
    && rm $(ls | grep -v systemd-tmpfiles-setup); \
    \
  rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*; \
    \
  # systemd2
  # find `ls |grep -Ev "^home|^root|^usr|^opt|^mnt|^sys|^proc"`
  find `echo /etc/ /lib/ /var/` -name "*systemd*" |grep ".service$" |grep "supervi" |while read one; do echo $one; rm -f $one; done; \
  \
  dpkg-divert --local --rename --add /sbin/udevadm; ln -s /bin/true /sbin/udevadm; \
  systemctl enable de-entry; systemctl enable de-start; \
  systemctl disable dropbear; systemctl disable supervisor; \
  # systemctl mask supervisor; \
  systemctl disable systemd-resolved; 

# LOCALE, OHMYBASH, SETTINGS
$RUN \
  # ohmybash
  echo "curl oh-my-bash.." && su - headless -c "$(curl --connect-timeout 3 -fsSL https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh)"; \
  rm -rf /home/headless/.oh-my-bash/.git; 
  # danger!
  bash -c 'cd /home/headless/.oh-my-bash/themes && rm -rf `ls |grep -v "axin\|sh$"` || echo "onmybash not exist, skip clear"'; \
  \
  # sed -i "s^value=\"gnome\"^value=\"Papirus-Bunsen-grey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml; \
  sed -i "s^OSH_THEME=\"font\"^OSH_THEME=\"axin\"^g" /home/headless/.bashrc; 

# link: Xvnc, vncpasswd
$RUN rm -f /usr/bin/Xvnc; ln -s /usr/local/tigervnc/bin/Xvnc /usr/bin/Xvnc; \
  rm -f /usr/bin/vncpasswd; ln -s /usr/local/tigervnc/bin/vncpasswd /usr/bin/vncpasswd;

# for core: avoid multi> 'dbus-daemon --syslog --fork --print-pid 4 --print-address 6 --session'; #(headless x2, root x1)
kill -9 `ps -ef |grep dbus |grep -v grep |awk '{print $2}'`