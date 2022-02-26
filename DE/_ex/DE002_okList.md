# 

## GNOME @ubt2004:

```bash
# https://github.com/RavenKyu/docker-ubuntu-desktop-vnc  #dcp up -d --build
VNC password: welcome
VNC Viewer    localhost:5901
noVNC         http://localhost:6080
http://172.25.23.197:6080/

apt-get install -y \
    dbus dbus-x11 systemd
apt-get install -y ubuntu-desktop fcitx-config-gtk gnome-tweak-tool gnome-usage
apt-get install -y tigervnc-common tigervnc-scraping-server tigervnc-standalone-server tigervnc-xorg-extension
```

## KDE: @ubt1804-bionic

- https://github.com/ms-jpq/kde-in-docker

```bash
# https://github.com/ms-jpq/kde-in-docker/tree/daddy/base/bionic
docker run -p 8080:8080 -p 5900:5900 msjpq/kde-vnc:bionic  #KDE on 18.04 lts. 620MB   >>docker run -p 8080:8080 -p 5908:5900 jobinbasani/kde_vnc_docker_desktop #kubuntu, plasma;
docker run -p 8080:8080 -p 5908:5900 msjpq/kde-vnc:focal  #KDE on 20.04 lts. 730MB   ##/usr/bin/startplasma-x11: error while loading shared libraries: libQt5Core.so.5 ##Kernel@cent7
http://172.25.21.66:8080/

apt install -y plasma-desktop
apt install -y nautilus konsole
apt install -y tigervnc-standalone-server tigervnc-xorg-extension
ADD https://github.com/novnc/noVNC/archive/v${NO_VNC_VER}.zip /_install

# ---------------------
FROM msjpq/kde-vnc:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install kubuntu-desktop ssh gimp spectacle audacity libreoffice jackd pulseaudio-module-jack \
libodbc1 odbcinst1debian2 chrony libpcre16-3 plasma-workspace-wallpapers plasma-active-default-settings \
gnome-themes-standard samba linux-generic alsa-utils vim sudo -y 
```

