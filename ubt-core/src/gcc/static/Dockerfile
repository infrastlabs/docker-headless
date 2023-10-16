# ARG BASEIMAGE=unknown
ARG BASEIMAGE=ubuntu:20.04
ARG BUILDPLATFORM=linux/amd64
# Define the Alpine packages to be installed into the image.
ARG ALPINE_PKGS="\
    # Needed to generate self-signed certificates
    openssl \
    # Needed to use netcat with unix socket.
    netcat-openbsd \
"
# Define the Debian/Ubuntu packages to be installed into the image.
ARG DEBIAN_PKGS="\
    # Used to determine if nginx is ready.
    netcat \
    # For ifconfig
    net-tools \
    # Needed to generate self-signed certificates
    openssl \
"

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/tonistiigi-xx AS xx

# Build UPX.
FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS upx
# https://gitee.com/infrastlabs/alpine-ext/blob/master/src/build.sh
# https://www.jakehu.me/2021/alpine-mirrors/
# domain="mirrors.ustc.edu.cn"
# domain="mirrors.aliyun.com";
# mirrors.tuna.tsinghua.edu.cn
RUN domain="mirrors.tuna.tsinghua.edu.cn"; \
  echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
  echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
RUN apk --no-cache add build-base curl make cmake git && \
    mkdir /tmp/upx && \
    curl -# -L https://ghproxy.com/https://github.com/upx/upx/releases/download/v4.0.1/upx-4.0.1-src.tar.xz | tar xJ --strip 1 -C /tmp/upx && \
    make -C /tmp/upx build/release-gcc -j$(nproc) && \
    cp -v /tmp/upx/build/release-gcc/upx /usr/bin/upx

# Build TigerVNC server.
FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS tigervnc
RUN domain="mirrors.tuna.tsinghua.edu.cn"; \
  echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
  echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
ARG TARGETPLATFORM
COPY --from=xx / /
COPY src/tigervnc /build
RUN /build/build.sh
RUN xx-verify --static /tmp/tigervnc-install/usr/bin/Xvnc
RUN xx-verify --static /tmp/tigervnc-install/usr/bin/vncpasswd
COPY --from=upx /usr/bin/upx /usr/bin/upx
RUN upx /tmp/tigervnc-install/usr/bin/Xvnc
RUN upx /tmp/tigervnc-install/usr/bin/vncpasswd

# Build Fontconfig.
FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS fontconfig
RUN domain="mirrors.tuna.tsinghua.edu.cn"; \
  echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
  echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
ARG TARGETPLATFORM
COPY --from=xx / /
COPY src/fontconfig/build.sh /tmp/build-fontconfig.sh
RUN /tmp/build-fontconfig.sh

# Build xdpyprobe.
# Used to determine if the X server (Xvnc) is ready.
FROM --platform=$BUILDPLATFORM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15 AS xdpyprobe
RUN domain="mirrors.tuna.tsinghua.edu.cn"; \
  echo "http://$domain/alpine/v3.15/main" > /etc/apk/repositories; \
  echo "http://$domain/alpine/v3.15/community" >> /etc/apk/repositories
ARG TARGETPLATFORM
COPY --from=xx / /
COPY src/xdpyprobe /tmp/xdpyprobe
RUN apk --no-cache add make clang
RUN xx-apk --no-cache add gcc musl-dev libx11-dev libx11-static libxcb-static
RUN CC=xx-clang \
    make -C /tmp/xdpyprobe
RUN xx-verify --static /tmp/xdpyprobe/xdpyprobe
COPY --from=upx /usr/bin/upx /usr/bin/upx
RUN upx /tmp/xdpyprobe/xdpyprobe

# Pull base image.
FROM ${BASEIMAGE}
ARG TARGETPLATFORM
RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  test -z "$(echo $TARGETPLATFORM |grep arm)" && target=ubuntu || target=ubuntu-ports; \
  echo "deb http://${DOMAIN}/$target focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/$target focal-updates main restricted universe multiverse">> /etc/apt/sources.list;
WORKDIR /tmp
# Install system packages.
ARG ALPINE_PKGS
ARG DEBIAN_PKGS
RUN \
    if [ -n "$(which apk)" ]; then \
        add-pkg ${ALPINE_PKGS}; \
    else \
        add-pkg ${DEBIAN_PKGS}; \
    fi && \
    # Remove some unneeded stuff.
    rm -rf /var/cache/fontconfig/*

# Add files.
# COPY helpers/* /opt/base/bin/
# COPY rootfs/ /
# COPY --link
COPY --from=tigervnc /tmp/tigervnc-install/usr/bin/Xvnc /opt/base/bin/
COPY --from=tigervnc /tmp/tigervnc-install/usr/bin/vncpasswd /opt/base/bin/
COPY --from=tigervnc /tmp/xkb-install/usr/share/X11/xkb /opt/base/share/X11/xkb
COPY --from=tigervnc /tmp/xkbcomp-install/usr/bin/xkbcomp /opt/base/bin/
# COPY --from=openbox /tmp/openbox-install/usr/bin/openbox /opt/base/bin/
# COPY --from=openbox /tmp/openbox-install/usr/bin/obxprop /opt/base/bin/
COPY --from=fontconfig /tmp/fontconfig-install/opt /opt
COPY --from=xdpyprobe /tmp/xdpyprobe/xdpyprobe /opt/base/bin/
# COPY --from=yad /tmp/yad-install/usr/bin/yad /opt/base/bin/
# COPY --from=nginx /tmp/nginx-install /opt/base/
# COPY --from=dhparam /tmp/dhparam.pem /defaults/
# COPY --from=noVNC /opt/noVNC /opt/noVNC

# Set environment variables.
ENV \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    DARK_MODE=0 \
    SECURE_CONNECTION=0 \
    SECURE_CONNECTION_VNC_METHOD=SSL \
    SECURE_CONNECTION_CERTS_CHECK_INTERVAL=60 \
    WEB_LISTENING_PORT=5800 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD= \
    ENABLE_CJK_FONT=0

# Expose ports.
#   - 5800: VNC web interface
#   - 5900: VNC
EXPOSE 5800 5900
