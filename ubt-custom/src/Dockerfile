# FROM scratch as files1
FROM ubuntu:20.04 as files1
  # .mint-art 调整过的
  ADD src/xf /rootfs_home_headless
  ADD src/.mint-artwork-xfce /rootfs_home_headless
  # 
  ADD src/clear3d.theme /rootfs/usr/share/plank/themes/Default/dock.theme
  RUN find /rootfs* |wc; \
    cd /rootfs_home_headless/Desktop; chmod +x *.desktop
FROM infrastlabs/docker-headless:core as core
FROM infrastlabs/docker-headless:base-v51-slim
RUN \  
# RUN \  
  # VIDEO: 30.5 MB
  # libllvm12 已包含 # libgl1-mesa-glx >libgl1-mesa-dri ##ex:  mesa-utils 
  apt.sh libgl1-mesa-glx mesa-utils libglu1-mesa \
  \
  tumbler gtk2-engines-pixbuf gnupg \
  dbus-x11 at-spi2-core language-pack-gnome-zh-hans \
  \
  # FULL(icon,ibus,git,flameshot) 49.1 MB
  # \12.3 MB (默认不含输入法: IBus/Fcitx)
  ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  # \20.5 MB
  flameshot arandr \
  # \12.6 MB
  git; \
  # flameshot_qt;
  strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5; \
  # LLVM(定制版这里删调它,除gnome,cinna其它de无影响); clear big lib: 88M (qt: flameshot,sogoupinyin) > img: -27M
  rm -f /usr/lib/x86_64-linux-gnu/libLLVM-12.so.1; \
  rm -f /usr/lib/aarch64-linux-gnu/libLLVM-12.so.1; 

# APPS+ #+clipit/-diodon
# #add-apt-repository: software-properties-common
RUN \
  apt.sh tint2 plank rofi \
  clipit pnmixer lxappearance \
# 2536 kB #18.9 MB > 14.3 MB
# LOC_XFCE="xfce4-settings xfce4-session xfwm4 xfdesktop4" # deps: cpp cpp-9
# RUN apt.sh \
  xfce4-settings xfce4-session xfwm4 xfdesktop4 \
  xfce4-notifyd thunar

# papirus-icon-theme
RUN apt.sh papirus-icon-theme greybird-gtk-theme; \
  rm -f /usr/share/backgrounds/greybird.svg; \
  \
  wget https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/assets/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; \
  cd /usr/share/icons && rm -rf Papirus-Bunsen-Dark-bluegrey Papirus-Bunsen-Dark-grey Papirus-Dark Papirus-Light ePapirus; \
  \
  dpkg -l |grep bunsen && exit 0 || exit 1;

# libxss1: wps
# libunwind8 libxfont2: Xvnc-compile
RUN apt.sh libxss1 libunwind8 libxfont2

# core
COPY --from=core /rootfs/bin /
COPY --from=core /rootfs/conf /
RUN bash /xconf.sh

# HEADLESS
COPY --from=files1 /rootfs /
COPY --from=files1 --chown=headless:headless /rootfs_home_headless /home/headless/
RUN cd /home/headless/.config/plank/dock1/launchers; rm -f ristretto* geany* flameshot*; \
  \
  wget -qO /usr/share/backgrounds/xfce/xfce-teal.png https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/assets/bg/bg-debian-liteblue.png; \
  wget -qO /usr/share/backgrounds/xfce/xfce-pure-blue.jpg https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/assets/bg/pure-blue.jpg; \
  \
  # 清理ubt自带图标, keep项: hicolor 
  # locolor gnome bloom
  cd /usr/share/icons && rm -rf Humanity* ubuntu-mono* LoginIcons Tango; \
  \
  sed -i "s^value=\"Mint-Y\"^value=\"Papirus-Bunsen-bluegrey\"^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml; \
  sed -i "s^xfce-teal.png^xfce-pure-blue.jpg^g" /home/headless/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml;

ENV \
  # DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket" \
  START_SESSION=xfce4-session
WORKDIR /home/headless