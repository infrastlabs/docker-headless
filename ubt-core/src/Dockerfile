FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core-compile as rdp
# FROM scratch as files1
FROM ubuntu:20.04 as files1
  # ubt2004: tigervnc-standalone-server 1.10.1+dfsg-3
  COPY --from=rdp /rootfs /rootfs/
  # COPY --from=rdp /rootfs/var/lib/xrdp-pulseaudio-installer /rootfs/var/lib/xrdp-pulseaudio-installer/
  # 
  # tigervnc 1.10.1 > 1.12.0 
  # https://udomain.dl.sourceforge.net/project/tigervnc/stable/1.10.1/tigervnc-1.10.1.x86_64.tar.gz
  ENV ver=1.10.1
  # ENV ver=1.12.0
  ADD tigervnc-${ver}.x86_64.tar.gz /tigervnc-pkg
  RUN mkdir -p /rootfs/usr/bin /rootfs/usr/lib64/xorg; cd /tigervnc-pkg/tigervnc-${ver}.x86_64/; \
    \cp -a usr/bin/Xvnc /rootfs/usr/bin/Xvnc; \
    \cp -a usr/bin/vncpasswd /rootfs/usr/bin/vncpasswd; \
    \cp -a usr/lib64/swrast_dri.so /rootfs/usr/lib64/swrast_dri.so; \
    mkdir -p /rootfs/usr/lib/dri; ln -s /usr/lib64/swrast_dri.so /rootfs/usr/lib/dri/; \
    \cp -a usr/lib64/xorg/protocol.txt /rootfs/usr/lib64/xorg/protocol.txt

FROM ubuntu:20.04 as files2
  RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
  apt update && apt -y install curl
  # webhookd, noVNC
  # https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/webhookd.tar.gz
  RUN echo 123; \
    cd /tmp; file=webhookd.tar.gz; curl -fSL -k -O https://gitee.com/infrastlabs/fk-webhookd/releases/download/v22.08.18/$file; \
    hookd=/rootfs/usr/local/webhookd; mkdir -p $hookd; tar -zxvf $file -C $hookd; rm -f $file; \
    \
    cd /rootfs/usr/local/webhookd/static; file=v1.3.0.tar.gz; curl -fSL -k -O https://hub.fastgit.xyz/novnc/noVNC/archive/$file; \
    bash down_vnc.sh; rm -f $file;  
  # 
  COPY src/*.sh /rootfs/
  ADD src/etc /rootfs/etc
  ADD src/dot /rootfs/etc/skel
  ADD src/bin /rootfs/usr/bin
  ADD src/sv.conf /rootfs/etc/supervisor/conf.d/sv.conf
  COPY src/*.service /rootfs/etc/systemd/system/
  RUN cd /rootfs/usr/bin; chmod +x *; \
    cd /rootfs/etc/skel/Desktop; chmod +x *.desktop

FROM ubuntu:20.04
  RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  echo "deb http://${DOMAIN}/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/ubuntu focal-updates main restricted universe multiverse">> /etc/apt/sources.list;

# 拆分包体与配置项两块，免频繁变动基础包
# HEADLESS
COPY --from=files1 /rootfs /rootfs_bin
COPY --from=files2 /rootfs /rootfs_conf
# RUN bash /xconf.sh
