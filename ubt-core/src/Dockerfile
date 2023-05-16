FROM infrastlabs/docker-headless:core-compile as bin
FROM ubuntu:20.04 as files1
  COPY --from=bin /rootfs /rootfs/

FROM ubuntu:20.04 as files2
  ARG TARGETPLATFORM
  RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  test -z "$(echo $TARGETPLATFORM |grep arm)" && target=ubuntu || target=ubuntu-ports; \
  echo "deb http://${DOMAIN}/$target focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/$target focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  apt update && apt -y install curl
  # webhookd, noVNC
  # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/webhookd.tar.gz
  RUN echo a.123; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" && file=webhookd.tar.gz || file=webhookd-arm64.tar.gz; \
    cd /tmp; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
    hookd=/rootfs/usr/local/webhookd; mkdir -p $hookd; tar -zxvf $file -C $hookd; rm -f $file; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" || mv $hookd/webhookd-arm64 $hookd/webhookd; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" || sed -i 's^cmd="go run ./"^cmd=./webhookd^g' $hookd/run.sh; \
    \
    # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/v1.3.0.tar.gz #https://github.com/novnc/noVNC/archive
    cd /rootfs/usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -k -O -fSL https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
    bash down_vnc.sh; rm -f $file;
  RUN \
    # XCursor
    downUrl=https://ghproxy.com/https://github.com/ful1e5/XCursor-pro/releases/download/v2.0.1; \
    # downUrl=https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/assets/theme; \
    mkdir -p /rootfs/usr/share/icons; \
    file=XCursor-Pro-Dark.tar.gz; curl -k -fSL $downUrl/$file |tar -zx -C /rootfs/usr/share/icons/; \
    file=XCursor-Pro-Light.tar.gz; curl -k -fSL $downUrl/$file |tar -zx -C /rootfs/usr/share/icons/; \
    ls -lh /rootfs/usr/share/icons/;
  # 
  COPY src/*.sh /rootfs/
  ADD src/etc /rootfs/etc
  ADD src/dot /rootfs/etc/skel
  ADD src/bin /rootfs/usr/bin
  ADD src/svd.conf /rootfs/etc/supervisor/supervisord.conf
  ADD src/sv.conf /rootfs/etc/supervisor/conf.d/sv.conf
  COPY src/*.service /rootfs/etc/systemd/system/
  RUN cd /rootfs/usr/bin; chmod +x *; \
    cd /rootfs/etc/skel/Desktop; chmod +x *.desktop; \
    # https://github.com/TigerVNC/tigervnc/issues/800 #bernhardu,2019=Tigervnc killed just after connect 
    test -z "$(echo $TARGETPLATFORM |grep arm64)" || sed -i "s^exec Xvnc^LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1 exec Xvnc^g" /rootfs/xvnc.sh;

FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:base-v51-slim
# FROM infrastlabs/docker-headless:base-v51-slim
# 轻量级桌面 openbox + tint2 + conky + stalonetray + pcmanfm + xcompmgr #http://t.zoukankan.com/huapox-p-3516155.html #huapox
#   无thunar/lxappearance: 结合asbru纯SSH,音频场景（管维）
RUN apt.sh \
    # plank \ #compton-plank遮盖去域不可用
    # compton \
    xcompmgr \
    dunst \
    hsetroot pnmixer clipit;
# TODO: drop deps of libgl1
RUN apt.sh libunwind8 libxfont2 libgl1; \
  rm -f /usr/lib/x86_64-linux-gnu/libLLVM-12.so.1; \
  rm -f /usr/lib/aarch64-linux-gnu/libLLVM-12.so.1; 

# +服务器维护工具(gparted, wifiPojie,..); core与latest差异化
RUN apt.sh \
  gparted \
  \
  # +papirus-icon-theme
  # dbus-x11 at-spi2-core
  thunar lxappearance \
  language-pack-gnome-zh-hans papirus-icon-theme greybird-gtk-theme; \
  rm -f /usr/share/backgrounds/greybird.svg; \
  \
  wget https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/assets/bunsen-papirus-icon-theme_10.3-2_all.deb; \
  dpkg -i bunsen-papirus-icon-theme_10.3-2_all.deb; rm -f bunsen-papirus-icon-theme_10.3-2_all.deb; \
  cd /usr/share/icons && rm -rf Papirus-Bunsen-Dark-bluegrey Papirus-Bunsen-Dark-grey Papirus-Dark Papirus-Light ePapirus; \
  \
  # Papirus left: 16x(clipit:21M) 64x(desktop:21M)
  cd /usr/share/icons/Papirus && rm -rf 18x* 22x* 24x* 32x*  48x* 64x* ; \
  ls -lh /usr/share/icons/Papirus; \
  \
  dpkg -l |grep bunsen && exit 0 || exit 1;

RUN apt.sh ibus ibus-gtk ibus-gtk3 ibus-rime librime-data-wubi \
  flameshot
# firefox> midori > ?
# RUN apt.sh midori

# 拆分包体与配置项两块，免频繁变动基础包
# HEADLESS
COPY --from=files1 /rootfs /rootfs/bin
COPY --from=files2 /rootfs /rootfs/conf

# fluxbox's conf
# RUN bash /rootfs/conf/etc/skel/.fluxbox/fluxbox.sh
# RUN bash /xconf.sh

RUN \
  echo "cp -a /rootfs/bin/* /; \n\
cp -a /rootfs/conf/* /; \n\
bash /etc/skel/.fluxbox/fluxbox.sh; \n\
bash /xconf.sh;\n\
touch /rootfs/.core-init-lock\n\
" > /rootfs/.core-init
# .fluxbox/startup >> if -z $DBUS ; eval $(dbus-launch --sh-syntax --exit-with-session)
# ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket"
# WORKDIR /home/headless
CMD ["bash", "-c", "test -f /rootfs/.core-init-lock || bash /rootfs/.core-init;  exec /entry.sh"]
