# docker-healess

[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/slim)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/full)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/infrastlabs/docker-headless.svg)](https://hub.docker.com/r/infrastlabs/docker-headless)
[![Last commit](https://img.shields.io/github/last-commit/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless)
[![GitHub issues](https://img.shields.io/github/issues/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless/issues)

By `XRDP/NOVNC` with `XFCE4` based on `Debian`, Formatting a HeadlessBox/Cloud Desktop.

- Screen shared with both RDP/noVnc. (ReadWrite/ReadOnly)
- MultiScreen support. (mstsc+xrdp+tigervnc)
- Audio support. (xrdp+pulseaudio)
- Locale/TZ support.
- Desktop apps: ibus-rime, flameshot, PAC.

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/docs/res/01rdp-double-screen.png)

**QuickStart**

```bash
# example1: quickStart
docker run -it --rm --shm-size 1g --net=host infrastlabs/docker-headless:full

# example2: VNC_RW=ChangeMe, VNC_RO=View123
# Caution: Please change the SSHPass when the Box started!!!
vols="""
-v /_ext:/_ext 
-v /opt:/opt 
-v /var/run/docker.sock:/var/run/docker.sock
"""
docker run -d --name=devbox --privileged --shm-size 1g --net=host \
 -e L=zh_CN -e VNC_RW=ChangeMe -e VNC_RO=View123 $vols infrastlabs/docker-headless:full

# 290.545 MB
docker container update --restart=always devbox
```

**Detail**

- Size: latest: `168.347 MB`, slim: `88.929 MB`, full: `289.581 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`
- Ports
  - novnc 6080 > 10081
  - xrdp  3389 > 10089
  - sshd  22   > 10022
- HotKeys `super: Alt`
  - `sup+t`: terminal
  - `sup+f`: thunar
  - `sup+d`: rofi
  - `sup+q`: flameshot
  - `sup+h` : hide window
  - `sup+up`: max window
  - `sup+down`: cycle windows
  - `sup+left`: left workspace
  - `sup+right`: right workspace
- Entry: xrdp, novnc, dropbear
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind

**Usage**

- [CloudDesktop](docs/01-CloudDesktop.md)
- [Devbox](docs/02-Devbox.md)
- [X11-Gateway](docs/03-Gateway.md)
- 
- [b0-locale](docs/b0-locale.md)
- [b1-rdp](docs/b1-rdp.md)
- [b2-vnc](docs/b2-vnc.md)
- [b3-apps](docs/b3-apps.md)

**Refs**

- xubuntu
  - https://github.com/accetto/xubuntu-vnc-novnc #276.52 MB
  - https://github.com/hectorm/docker-xubuntu #633.29 MB
- distros
  - peppermint: https://peppermintos.com/guide/downloading/
  - dtx2 https://github.com/gfk-sysenv/dxt2 https://dxt2.co.za
  - LXLE: https://sourceforge.net/projects/lxle/ #greybird; -compact 
- headless
  - https://github.com/ConSol/docker-headless-vnc-container
  - https://github.com/jlesage/docker-firefox
  - https://hub.fastgit.org/aerokube/selenoid
- https://github.com/fadams/docker-gui https://gitee.com/g-system/docker-gui #pdf
- https://github.com/frxyt/docker-xrdp #DE
