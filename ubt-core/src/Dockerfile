# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core-compile as bin
FROM infrastlabs/docker-headless:core-compile-multi as bin
# FROM scratch as files1
FROM ubuntu:20.04 as files1
  # ubt2004: tigervnc-standalone-server 1.10.1+dfsg-3
  COPY --from=bin /rootfs /rootfs/
  # 
  # # tigervnc 1.10.1 > 1.12.0 
  # # https://udomain.dl.sourceforge.net/project/tigervnc/stable/1.10.1/tigervnc-1.10.1.x86_64.tar.gz
  # ENV ver=1.10.1
  # # ENV ver=1.12.0
  # ADD tigervnc-${ver}.x86_64.tar.gz /tigervnc-pkg
  # RUN mkdir -p /rootfs/usr/bin /rootfs/usr/lib64/xorg; cd /tigervnc-pkg/tigervnc-${ver}.x86_64/; \
  #   \cp -a usr/bin/Xvnc /rootfs/usr/bin/Xvnc; \
  #   \cp -a usr/bin/vncpasswd /rootfs/usr/bin/vncpasswd; \
  #   \cp -a usr/lib64/swrast_dri.so /rootfs/usr/lib64/swrast_dri.so; \
  #   mkdir -p /rootfs/usr/lib/dri; ln -s /usr/lib64/swrast_dri.so /rootfs/usr/lib/dri/; \
  #   \cp -a usr/lib64/xorg/protocol.txt /rootfs/usr/lib64/xorg/protocol.txt

FROM ubuntu:20.04 as files2
  ARG TARGETPLATFORM
  RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  test -z "$(echo $TARGETPLATFORM |grep arm)" && target=ubuntu || target=ubuntu-ports; \
  echo "deb http://${DOMAIN}/$target focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/$target focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  apt update && apt -y install curl
  # webhookd, noVNC
  # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/webhookd.tar.gz
  RUN echo a.12; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" && file=webhookd.tar.gz || file=webhookd-arm64.tar.gz; \
    cd /tmp; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
    hookd=/rootfs/usr/local/webhookd; mkdir -p $hookd; tar -zxvf $file -C $hookd; rm -f $file; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" || mv $hookd/webhookd-arm64 $hookd/webhookd; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" || sed -i 's^cmd="go run ./"^cmd=./webhookd^g' $hookd/run.sh; \
    \
    # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/v1.3.0.tar.gz #https://github.com/novnc/noVNC/archive
    cd /rootfs/usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -k -O -fSL https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
    bash down_vnc.sh; rm -f $file;  
  # 
  COPY src/*.sh /rootfs/
  ADD src/etc /rootfs/etc
  ADD src/dot /rootfs/etc/skel
  ADD src/bin /rootfs/usr/bin
  ADD src/sv.conf /rootfs/etc/supervisor/conf.d/sv.conf
  COPY src/*.service /rootfs/etc/systemd/system/
  RUN cd /rootfs/usr/bin; chmod +x *; \
    cd /rootfs/etc/skel/Desktop; chmod +x *.desktop; \
    # https://github.com/TigerVNC/tigervnc/issues/800 #bernhardu,2019=Tigervnc killed just after connect 
    # LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1 vncserver :2 -localhost no
    test -z "$(echo $TARGETPLATFORM |grep arm64)" || sed -i "s^exec Xvnc^LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1 exec Xvnc^g" /rootfs/xvnc.sh;

# FROM ubuntu:20.04
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:base-v5-slim
FROM infrastlabs/docker-headless:base-v5-slim-multi
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

# 拆分包体与配置项两块，免频繁变动基础包
# HEADLESS
COPY --from=files1 /rootfs /rootfs_bin
COPY --from=files2 /rootfs /rootfs_conf

# fluxbox's conf
# RUN bash /rootfs_conf/etc/skel/.fluxbox/fluxbox.sh
# RUN bash /xconf.sh

# WORKDIR /home/headless
CMD ["bash", "-c", "cp -a /rootfs_bin/* /; cp -a /rootfs_conf/* /; bash /etc/skel/.fluxbox/fluxbox.sh; bash /xconf.sh; exec /entry.sh"]
