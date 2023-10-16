# # $ARG export BASEIMAGE=unknown
# $ARG export BASEIMAGE=ubuntu:20.04
# $ARG export BUILDPLATFORM=linux/amd64
# Define the Alpine packages to be installed into the image.
$ARG export ALPINE_PKGS="\
    # Needed to generate self-signed certificates
    openssl \
    # Needed to use netcat with unix socket.
    netcat-openbsd \
"
# Define the Debian/Ubuntu packages to be installed into the image.
$ARG export DEBIAN_PKGS="\
    # Used to determine if nginx is ready.
    netcat \
    # For ifconfig
    net-tools \
    # Needed to generate self-signed certificates
    openssl \
"

# test
ping -c 2 qq.com
apk update; apk add gawk;
function print_time_cost(){
    local begin_time=$1
	gawk 'BEGIN{
		print "本操作从" strftime("%Y年%m月%d日%H:%M:%S",'$begin_time'),"开始 ,",
		strftime("到%Y年%m月%d日%H:%M:%S",systime()) ,"结束,",
		" 共历时" systime()-'$begin_time' "秒";
	}' 2>&1 | tee -a $logfile
}

# Get Dockerfile cross-compilation helpers.
# FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/tonistiigi-xx AS xx
# # Build UPX.
# FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS upx
# https://gitee.com/infrastlabs/alpine-ext/blob/master/src/build.sh
# https://www.jakehu.me/2021/alpine-mirrors/
# domain="mirrors.ustc.edu.cn"
# domain="mirrors.aliyun.com";
# mirrors.tuna.tsinghua.edu.cn
# $RUN export domain="mirrors.tuna.tsinghua.edu.cn"; \
#   echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
#   echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
# $RUN apk --no-cache add build-base curl make cmake git && \
function do_upx(){
    # pwd; ls -laSh
    mkdir -p /tmp/upx && \
    export file=upx-4.0.1-src.tar.xz; \
    test -s /mnt/$file || curl -# -k -fSL https://ghproxy.com/https://github.com/upx/upx/releases/download/v4.0.1/$file > /mnt/$file
    # pwd; ls -laSh
    cat /mnt/$file | tar xJ --strip 1 -C /tmp/upx && \
    make -C /tmp/upx build/release-gcc -j$(nproc) && \
    cp -v /tmp/upx/build/release-gcc/upx /usr/bin/upx
}
rm -rf  /mnt/logs; mkdir -p /mnt/logs
begin_time="`gawk 'BEGIN{print systime()}'`"; export logfile=/mnt/logs/do_upx.log
do_upx 2>&1|tee $logfile; print_time_cost $begin_time

# export targetDir=/opt/base
export targetDir=/usr

# Build TigerVNC server.
# FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS tigervnc
# $RUN export domain="mirrors.tuna.tsinghua.edu.cn"; \
#   echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
#   echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
# $ARG export TARGETPLATFORM
# COPY --from=xx / /
function do_tiger(){
mkdir -p /build; \cp -a src/tigervnc/* /build/
$RUN sh /build/build.sh
$RUN xx-verify --static /tmp/tigervnc-install/usr/bin/Xvnc
$RUN xx-verify --static /tmp/tigervnc-install/usr/bin/vncpasswd
# COPY --from=upx /usr/bin/upx /usr/bin/upx
$RUN upx /tmp/tigervnc-install/usr/bin/Xvnc
$RUN upx /tmp/tigervnc-install/usr/bin/vncpasswd
}
begin_time="`gawk 'BEGIN{print systime()}'`"; logfile=/mnt/logs/do_tiger.log
do_tiger 2>&1|tee $logfile; print_time_cost $begin_time


# Build Fontconfig.
# FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS fontconfig
# $RUN export domain="mirrors.tuna.tsinghua.edu.cn"; \
#   echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
#   echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
# $ARG export TARGETPLATFORM
# COPY --from=xx / /
function do_fontconfig(){
\cp -a src/fontconfig/build.sh /tmp/build-fontconfig.sh
$RUN sh /tmp/build-fontconfig.sh
}
# 共历时172秒
# begin_time="`gawk 'BEGIN{print systime()}'`"; export logfile=/mnt/logs/do_fontconfig.log
# do_fontconfig 2>&1|tee $logfile; print_time_cost $begin_time

# Build xdpyprobe.
# Used to determine if the X server (Xvnc) is ready.
# FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS xdpyprobe
# $RUN export domain="mirrors.tuna.tsinghua.edu.cn"; \
#   echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
#   echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
# $ARG export TARGETPLATFORM
# COPY --from=xx / /
function do_xdpy(){
mkdir -p /tmp/xdpyprobe
\cp -a src/xdpyprobe/* /tmp/xdpyprobe/
# $RUN apk --no-cache add make clang
# $RUN xx-apk --no-cache add gcc musl-dev libx11-dev libx11-static libxcb-static
$RUN export CC=xx-clang; \
    make -C /tmp/xdpyprobe
$RUN xx-verify --static /tmp/xdpyprobe/xdpyprobe
# COPY --from=upx /usr/bin/upx /usr/bin/upx
$RUN upx /tmp/xdpyprobe/xdpyprobe
}
begin_time="`gawk 'BEGIN{print systime()}'`"; export logfile=/mnt/logs/do_xdpy.log
do_xdpy 2>&1|tee $logfile; print_time_cost $begin_time

# Pull base image.
# FROM ${BASEIMAGE}
# $ARG export TARGETPLATFORM
# $RUN export DOMAIN="mirrors.ustc.edu.cn"; \
#   test -z "$(echo $TARGETPLATFORM |grep arm)" && target=ubuntu || target=ubuntu-ports; \
#   echo "deb http://${DOMAIN}/$target focal main restricted universe multiverse" > /etc/apt/sources.list \
#   && echo "deb http://${DOMAIN}/$target focal-updates main restricted universe multiverse">> /etc/apt/sources.list;
# # WORKDIR /tmp
# # # Install system packages.
# # $ARG export ALPINE_PKGS
# # $ARG export DEBIAN_PKGS
# $RUN \
#     if [ -n "$(which apk)" ]; then \
#         add-pkg ${ALPINE_PKGS}; \
#     else \
#         add-pkg ${DEBIAN_PKGS}; \
#     fi && \
#     # Remove some unneeded stuff.
#     rm -rf /var/cache/fontconfig/*

# Add files.
# # COPY helpers/* /opt/base/bin/
# # COPY rootfs/ /
# # COPY --link
# COPY --from=tigervnc /tmp/tigervnc-install/usr/bin/Xvnc /opt/base/bin/
# COPY --from=tigervnc /tmp/tigervnc-install/usr/bin/vncpasswd /opt/base/bin/
# COPY --from=tigervnc /tmp/xkb-install/usr/share/X11/xkb /opt/base/share/X11/xkb
# COPY --from=tigervnc /tmp/xkbcomp-install/usr/bin/xkbcomp /opt/base/bin/
# # COPY --from=openbox /tmp/openbox-install/usr/bin/openbox /opt/base/bin/
# # COPY --from=openbox /tmp/openbox-install/usr/bin/obxprop /opt/base/bin/
# COPY --from=fontconfig /tmp/fontconfig-install/opt /opt
# COPY --from=xdpyprobe /tmp/xdpyprobe/xdpyprobe /opt/base/bin/
# # COPY --from=yad /tmp/yad-install/usr/bin/yad /opt/base/bin/
# # COPY --from=nginx /tmp/nginx-install /opt/base/
# # COPY --from=dhparam /tmp/dhparam.pem /defaults/
# # COPY --from=noVNC /opt/noVNC /opt/noVNC

rm -rf /mnt/rootfs #clear
mkdir -p /mnt/rootfs${targetDir}/bin/  /mnt/rootfs${targetDir}/share/X11/
\cp -a /usr/bin/upx /mnt/rootfs${targetDir}/bin/ #+upx
\cp -a /tmp/tigervnc-install/usr/bin/Xvnc /mnt/rootfs${targetDir}/bin/
\cp -a /tmp/tigervnc-install/usr/bin/vncpasswd /mnt/rootfs${targetDir}/bin/
\cp -a /tmp/xkb-install/usr/share/X11/xkb /mnt/rootfs${targetDir}/share/X11/xkb
\cp -a /tmp/xkbcomp-install/usr/bin/xkbcomp /mnt/rootfs${targetDir}/bin/
# \cp -a /tmp/fontconfig-install/opt /mnt/rootfs/opt #opt>usr??
\cp -a /tmp/xdpyprobe/xdpyprobe /mnt/rootfs${targetDir}/bin/

# Set environment variables.
# ENV \
#     DISPLAY_WIDTH=1920 \
#     DISPLAY_HEIGHT=1080 \
#     DARK_MODE=0 \
#     SECURE_CONNECTION=0 \
#     SECURE_CONNECTION_VNC_METHOD=SSL \
#     SECURE_CONNECTION_CERTS_CHECK_INTERVAL=60 \
#     WEB_LISTENING_PORT=5800 \
#     VNC_LISTENING_PORT=5900 \
#     VNC_PASSWORD= \
#     ENABLE_CJK_FONT=0

# Expose ports.
#   - 5800: VNC web interface
#   - 5900: VNC
# EXPOSE 5800 5900
