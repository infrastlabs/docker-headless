
**Tags**

 TAG | Distro | DESK | INPUT | STARTER | IMAGE |Star|Descrition 
--- | --- | ---  | ---  | --- | --- | --- | ---
latest |Ubuntu| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Customize,Lightweight
sogou  |Ubuntu| xfce | fcitx | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/sogou)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|sogouInput
core   |Ubuntu| flux | - | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/core)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|ConfigureLayer,Debug
---|---|---|---|---|---|---
cmate   |Mint| mate | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cmate)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|GoodExperience
cxfce   |Mint| xfce | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cxfce)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Xfce 4.16
cinna   |Mint| cinnamon | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cinna)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|VideoCard Notify
gnome   |Ubuntu| gnome | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/gnome)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Best Compatible
plas   |Kubuntu| plasma | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/plas)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|Black area with Settings

**ImageLayers**

![](./_doc/mannual/res/design/RDesktop_IMAGE.png)

## Producttion

x86/arm64 supported, Producttion prefer with `docker-compose`

- [docker-compose.yml](./docker-compose.yml) (latest,sogou,core)
- [docker-compose-livecd.yml](./docker-compose-livecd.yml) (gnome,plas,cinna,cmate,cxfce x5)

```bash
# supvervisor: core, latest, sogou (--privileged: xrdp-disk-mount)
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  infrastlabs/docker-headless:sogou
```

**(1)resetPass**: non-production usage with default password!!

```bash
SSH_PASS=xxx  VNC_PASS=xxx2  VNC_PASS_RO=xxx3
echo "headless:$SSH_PASS" |sudo chpasswd
echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |sudo vncpasswd /etc/xrdp/vnc_pass; sudo chmod 644 /etc/xrdp/vnc_pass
```

**(2)UserManual**: 

- [CloudDesktop Introduce](./_doc/mannual/01-CloudDesktop.md)
- [Next TODO](./_doc/mannual/b0-todo.md)
- [1.How to set Locale?](./_doc/mannual/b1-locale.md)
- [2.Usage of Double-Screen, ClipBoard, Audio?](./_doc/mannual/b2-rdp.md)
- [3.Web entry of desktop?](./_doc/mannual/b3-vnc.md)
- [4.Usage of IBUS/Flameshot](./_doc/mannual/b4-apps.md)
- [Details](./detail.md) （Hotkeys, Envs, SysApps）

**(3)Producttion-Deployment**: 

- [Windows-VM Deployment：](./_doc/deploy/win-vbox/README.md) With `barge-os` mini-container system, `--net=host` Use the VM's IP 
- [Linux-Server Deployment：](./_doc/deploy/fat-docker/README.md) Use `macvlan`'s network，with special IP，sugest with lxcfs installed.
- [Kubernetes Deployment：](./_doc/deploy/k8s-headless/README.md) Deployment+Service

## Detail

- Size: latest: `168.347 MB`, slim: `88.929 MB`, full: `289.581 MB`
- User: `headless`, SSHPass: `headless`, VNCPass: `headless`, VNCPassReadOnly: `View123`
- Ports
  - novnc 6080 > 10081 (http+https)
  - bcs   9222 > 10082 #pulseaudio broadcast to web-mp3 stream
  - xrdp  3389 > 10089
  - sshd  22   > 10022
  - 
  - vnc: 6000/tcp 
  - pulse: 4713/tcp
- Entry: xrdp, novnc, dropbear
- 命令工具：`tree htop gawk expect tmux rsync iproute2`
- 图形工具：`sakura tint2 plank flameshot`, `gnome-system-monitor engrampa ristretto`
- tzdata时区, ttf-wqy-microhei字体, ibus-rime输入法,
- oh-my-bash, docker-dind

**0.Xserver多开** (桌面网关)

用于其它镜像图像化桌面反向连接上来, 参考: [DE/docker-compose.yml](./DE/docker-compose.yml)

```bash
export DISPLAY=192.168.0.x:21 #远程图像显示
export PULSE_SERVER=tcp:192.168.0.x:4721 #远程声音
# ./xx 启动图形化应用
```

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/mannual/res/design-MultiBox.png)

**1.HotKeys**

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

**2.Env**

```bash
# ENV (default); SSH_PASS=headless, VNC_PASS=headless, VNC_PASS_RO=View123; 
ENV \
  SSH_PORT=10022 \
  RDP_PORT=10089 \
  VNC_PORT=10081 \
  BCS_PORT=10082 \
  # 
  SSH_PASS=headless \
  VNC_PASS=headless \
  VNC_PASS_RO=View123 \
  # 
  VNC_SSL_ONLY=false \
  VNC_CERT= \
  VNC_OFFSET=0 \
  VNC_LIMIT=1 \
  # L=zh_CN \
  TZ=Asia/Shanghai  
```

**3.Apps**

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

**4.Refs**

- https://github.com/accetto/xubuntu-vnc-novnc #276.52 MB
- https://github.com/hectorm/docker-xubuntu #633.29 MB
- https://github.com/ConSol/docker-headless-vnc-container
- https://github.com/jlesage/docker-firefox
- https://hub.fastgit.org/aerokube/selenoid
- https://github.com/fadams/docker-gui #book
- https://github.com/frxyt/docker-xrdp #DE
