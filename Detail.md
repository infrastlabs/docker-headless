
**Producttion**

`AMD64/ARM64` supported, Producttion prefer with `docker-compose`. [docker-compose.yml](./docker-compose.yml) [docker-compose-livecd.yml](./docker-compose-livecd.yml)

- [CloudDesktop](./_doc/CloudDesktop.md)
- [生产部署指引](./_doc/生产部署指引.md)
- [使用手册](./_doc/使用手册.md)
- [适用场景与问题](./_doc/适用场景与问题.md)

## 一、Tags

 TAG | Distro | Desktop | Input | Initd | Image |Star |Description 
--- | --- | ---  | ---  | --- | --- | --- | ---
latest |Ubuntu| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Customize,Lightweight
sogou  |Ubuntu| xfce | fcitx | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/sogou)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|sogouInput
core   |Ubuntu| flux | - | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/core)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|ConfigLayer,Firefox
---|---|---|---|---|---|---
cmate   |Mint| mate | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cmate)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|GoodExperience
cxfce   |Mint| xfce | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cxfce)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Xfce 4.16
cinna   |Mint| cinnamon | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cinna)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|VideoCard Notify
gnome   |Ubuntu| gnome | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/gnome)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Best Compatible
plasma   |Kubuntu| plasma | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/plasma)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|Black area with Settings

```bash
# non-production usage with default password!!
SSH_PASS=ChangeMe  VNC_PASS=ChangeMe2  VNC_PASS_RO=ChangeMe3
echo "headless:$SSH_PASS" |sudo chpasswd
echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |sudo vncpasswd /etc/xrdp/vnc_pass; sudo chmod 644 /etc/xrdp/vnc_pass
```

## 二、ImageLayers

- Core: `slim> base` [amd64/arm64/armv7]
- Custom: `slim> core/latest/sogou` [amd64/arm64]
- Ubuntu: `slim> base> gnome/plasma` [amd64/arm64]
- Mint: `slim> base> cxfce/cinna/cmate` [x86_64 only]

![](./_doc/res/design/RDesktop_IMAGE.png)

## 三、发行版选择

Debian9(LTS 5年已到期) > Ubuntu20.04(LTS 10年期)

- https://wiki.debian.org/LTS  #deb9: (July 6, 2020 to June 30, 2022 )  
- https://ubuntu.com/about/release-cycle #ubt20: (2020.4 - 2030.4)

**1)Debian9** `2017, xrdp 0.9.16_OpenSSL 1.1.0l  10 Sep 2019 |Xvnc TigerVNC 1.10.0 |pulseaudio 10.0`

![](./_doc/assets/lts_debian.png)

**2)Ubuntu20.04** `2020.04, xrdp 0.9.16_OpenSSL 1.1.1f  31 Mar 2020 |Xvnc TigerVNC 1.12.0 |pulseaudio 13.99.1`

![](./_doc/assets/lts_ubuntu.png)

**四、Detail**

（Hotkeys, Envs, SysApps）

- Size: latest: `168.347 MB`, slim: `88.929 MB`, full: `289.581 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`, VNCPassReadOnly: `View123`
- Ports
  - novnc 6080 > 10081 (wsvnc+broadcast's mp3-stream)
  - xrdp  3389 > 10089
  - sshd  22   > 10022
  - 
  - vnc: 6000/tcp (+offset: 10)
  - pulse: 4713/tcp (default: uds)
- Entry: xrdp, novnc, dropbear
- oh-my-bash, docker-dind
- Misc: `tree htop gawk expect tmux rsync iproute2`
- GUI: `sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- TZ/Font/Input: tzdata, ttf-wqy-microhei, ibus-rime

**0)HostGUIApps**

```bash
export DISPLAY=:10
export PULSE_SERVER=tcp:127.0.0.1:4721 #audio
# ./guiApps
```

**1)HotKeys**

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

**2)Env**

```bash
# ENV (default); SSH_PASS=headless, VNC_PASS=headless, VNC_PASS_RO=View123; 
ENV \
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  # 
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  # VNC_SSL_ONLY=false \
  # VNC_CERT= \
  VNC_OFFSET=10 \
  L=zh_CN \
  TZ=Asia/Shanghai  
```

**3)Apps**

- xfce4 https://www.xfce.org/projects
- tint2 https://github.com/o9000/tint2
- plank https://github.com/elementary/dock #An elementary fork of Plank
- thunar(lxappearance) https://github.com/xfce-mirror/thunar/graphs/contributors
- geany https://github.com/geany/geany/graphs/contributors #2006+
- sakura https://github.com/dabisu/sakura
- 
- rofi, dunst, conky, dbus #https://github.com/bus1/dbus-broker #https://bus1.org/
- dropbear https://hub.fastgit.org/mkj/dropbear/graphs/contributors
- asbru https://github.com/asbru-cm/asbru-cm #PAC
- ristretto jgmenu compton
- gnome-system-monitor, lxappearance
- gimp, code, idea, browser360, wps
- oth: inkscape, falkon, Xonotic

**4)Refs**

- https://github.com/accetto/xubuntu-vnc-novnc #276.52 MB
- https://github.com/hectorm/docker-xubuntu #633.29 MB
- https://github.com/ConSol/docker-headless-vnc-container
- https://github.com/jlesage/docker-firefox
- https://hub.fastgit.org/aerokube/selenoid
- https://github.com/fadams/docker-gui #book
- https://github.com/frxyt/docker-xrdp #DE
