FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:ubt-v4-slim

RUN \  
  # VIDEO: 30.5 MB
  # libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
  apt.sh libgl1-mesa-glx mesa-utils libglu1-mesa \
  \
  tumbler gtk2-engines-pixbuf gnupg \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans \
  \
  # FULL(icon,ibus,git,flameshot) 49.1 MB
  # \12.3 MB (默认不含输入法: IBus/Fcitx)
  # ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  # \20.5 MB
  flameshot arandr \
  # \12.6 MB
  git;

# 2868 kB #fcitx ##img:78.095 MB
RUN apt.sh fcitx fcitx-bin fcitx-config-common fcitx-config-gtk fcitx-data \
  fcitx-frontend-all fcitx-frontend-gtk2 fcitx-frontend-gtk3 \
  fcitx-frontend-qt5 fcitx-module-dbus fcitx-module-kimpanel fcitx-module-lua \
  fcitx-module-x11 fcitx-modules fcitx-table fcitx-ui-classic

# 15.3 kB #输入法依赖 https://shurufa.sogou.com/linux/guide
# libxss1: needed by sogou, fcitx -r for debug
RUN apt.sh lsb-release libxss1 im-config \
  libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1


# APPS+ #+clipit/-diodon
# #add-apt-repository: software-properties-common
RUN \
  apt.sh tint2 plank rofi \
  clipit pnmixer lxappearance

# 2536 kB
# # REF: docker-gui > ubt2004-mint-cinna
# # http://packages.linuxmint.com/ # https://mirrors.tuna.tsinghua.edu.cn/linuxmint
# RUN \
#   echo "deb https://mirrors.tuna.tsinghua.edu.cn/linuxmint una main upstream import backport">> /etc/apt/sources.list; \
#   LINUX_MINT_KEY=$(apt update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | xargs) && \
#   echo "LINUX_MINT_KEY: $LINUX_MINT_KEY"; \
#   apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 ${LINUX_MINT_KEY}; \
#   apt clean && rm -rf /var/lib/apt/lists/*;
# 18.9 MB > 14.3 MB
# LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4" # deps: cpp cpp-9
RUN apt.sh xfce4-settings xfce4-session xfwm4 xfdesktop4 \
  xfce4-notifyd thunar

# papirus-icon-theme
RUN apt.sh papirus-icon-theme greybird-gtk-theme; \
  rm -f /usr/share/backgrounds/greybird.svg; \
  \
  wget https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -l |grep bunsen && exit 0 || exit 1;  
  # \
  # sed -i "s^value=\"gnome\"^value=\"Papirus-Bunsen-grey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml;

# deps: fcitx 4.x: init when start; TODO fcitx-rime
ADD sogoupinyin_4.0.1.2800_x86_64.deb /.bundle/
# RUN dpkg -i /tmp/sogoupinyin_4.0.1.2800_x86_64.deb

# HEADLESS
# .mint-art 调整过的
ADD --chown=headless:headless src/xf /home/headless
ADD --chown=headless:headless src/.mint-artwork-xfce /home/headless
ADD src/clear3d.theme /usr/share/plank/themes/Default/dock.theme
ADD src/sv.conf /etc/supervisor/conf.d/xrdp.conf

RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  \
  # from ubt-v4-slim
  strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5; \
  sed -i "s/ibus/fcitx/g" /etc/profile; \
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/deploy/assets/bg-debian-liteblue.png; \
  \
  sed -i "s^value=\"Mint-Y\"^value=\"Papirus-Bunsen-grey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml; \
  sed -i "s^OSH_THEME=\"font\"^OSH_THEME=\"axin\"^g" /home/headless/.bashrc; 
CMD ["bash", "-c", "dpkg -i /.bundle/sogoupinyin_4.0.1.2800_x86_64.deb; /entry.sh"]