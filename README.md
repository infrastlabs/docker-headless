# docker-headless

[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/infrastlabs/docker-headless.svg)](https://hub.docker.com/r/infrastlabs/docker-headless)
[![Last commit](https://img.shields.io/github/last-commit/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless)
[![GitHub issues](https://img.shields.io/github/issues/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless/issues)

Multi-Desktop with `XRDP/NOVNC/PulseAudio` based on `Ubuntu20.04`, Formatting a HeadlessBox/Cloud Desktop.

- Screen shared with both RDP/noVnc. (ReadWrite/ReadOnly)
- MultiScreen support. (mstsc+xrdp+tigervnc)
- Audio support. (xrdp+pulseaudio/noVNC+broadcast)
- Locale/TZ support.
- Desktop apps: ibus-rime/fcitx-sogou, flameshot, PAC.
- Slim image: `core: 170.53 MB(fluxbox)`, `latest: 277.48 MB(ibus,xfce4.14)`, `sogou: 354.15 MB(fcitx)`

## step1: QuickStart

`docker run -it --rm --shm-size 1g --net=host infrastlabs/docker-headless`

 -- | Conn | PASS | ReadOnly 
--- | ---  | ---  | ---
noVnc | https://192.168.0.x:10081 | `headless` | `View123` 
RDP   | 192.168.0.x:10089         | `headless` | - 
SSH   | ssh -p 10022 headless@192.168.0.x | `headless` | - 

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/mannual/res/01rdp-double-screen.png)

**Tags**

 TAG | Distro | DESK | INPUT | STARTER | IMAGE |Star|Descrition 
--- | --- | ---  | ---  | --- | --- | --- | ---
latest |Ubuntu| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Customize,Lightweight
sogou  |Ubuntu| xfce | fcitx | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/sogou)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|sogouInput
core   |Ubuntu| flux | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/core)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|ConfigureLayer,Debug
---|---|---|---|---|---|---
gnome   |Ubuntu| gnome | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/gnome)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Best Compatible
plas   |Kubuntu| plasma | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/plas)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|Black area with Settings
cinna   |Mint| cinnamon | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cinna)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|VideoCard Notify
cmate   |Mint| mate | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cmate)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|GoodExperience
cxfce   |Mint| xfce | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cxfce)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|Xfce 4.16

**ImageLayers**

![](./_doc/mannual/res/design/RDesktop_IMAGE.png)

## step2: Producttion

x86/arm64 supported, Producttion prefer with `docker-compose`

- [docker-compose.yml](./docker-compose.yml)
- [docker-compose.cust.yml](./docker-compose.cust.yml) (latest,sogou,core x3)
- [docker-compose.desk.yml](./docker-compose.desk.yml) (gnome,plas,cinna,cmate,cxfce x5)

```bash
# supvervisor: core, latest, sogou (--privileged: xrdp-disk-mount)
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  infrastlabs/docker-headless:sogou

# systemd: gnome(must-systemd), plas, mint(cinna, cmate, cxfce)
# NOTICE：sogou-arm64 still be supporting, mint series only with x86(cinnamon,mate,xfce4.16) ,seems none arm-repo with linuxmint
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
  infrastlabs/docker-headless:gnome
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

**Design**

![](./_doc/mannual/res/design/RDesktop.png)

## step3: UseCase

Quick start with Locale: `docker run -it --rm --shm-size 1g -e VNC_OFFSET=20 -e L=zh_CN --net=host infrastlabs/docker-headless:latest`, Prefer [docker-compose.yml](./docker-compose.yml)

**(1)Development** (java, golang, nodejs)

```bash
# JAVA
sudo apt -y install openjdk-8-jdk openjdk-8-source && sudo apt -y install maven 
# GO
goVer=go1.17.8 #go1.16.15 #go1.13.15
wget https://studygolang.com/dl/golang/$goVer.linux-amd64.tar.gz
tar -zxf $goVer.linux-amd64.tar.gz; mv go $goVer.linux-amd64
rm -f godev; ln -s $goVer.linux-amd64 godev #link godev
# NODE
wget https://npm.taobao.org/mirrors/node/v14.20.0/node-v14.20.0-linux-x64.tar.xz
xz -d node-v14.20.0-linux-x64.tar.xz #tar.xz消失
tar -xvf node-v14.20.0-linux-x64.tar

# cat >> /etc/profile <<EOF
cat <<EOF |sudo tee -a /etc/profile
# NODE
NODE_HOME=/_ext/down/node-v14.20.0-linux-x64
PATH=\$NODE_HOME/bin:\$PATH
export NODE_HOME PATH
# GO
GO_HOME=/_ext/down/godev
GOPATH=/_ext/gopath
PATH=\$GO_HOME/bin:\$GOPATH/bin:\$PATH
export GO_HOME GOPATH PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
EOF

#IDE: vscode, ideaIC
wget https://vscode.cdn.azure.cn/stable/6cba118ac49a1b88332f312a8f67186f7f3c1643/code_1.61.2-1634656828_amd64.deb
wget https://download.jetbrains.com.cn/idea/ideaIC-2016.3.8-no-jdk.tar.gz
```

![](_doc/mannual/res/02/ide2-vscode.png)

**(2)Office**

wps, chrome/firefox

```bash
# firefox, chromium
sudo apt -y install firefox-esr chromium #chromium-driver
# WPS Office
# https://blog.csdn.net/u012939880/article/details/89439647 #wps_symbol_fonts.zip
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office_11.1.0.10161_amd64.deb
# ibus support with wps
sudo sed -i "1a export XMODIFIERS=@im=ibus" /usr/bin/{wps,wpp,et}
sudo sed -i "2a export QT_IM_MODULE=ibus" /usr/bin/{wps,wpp,et}
```

![](_doc/mannual/res/02/apps-office-wps.jpg)


**(3)Docker Dind**

![](_doc/mannual/res/02/dind2-headlessLinks.png)

```bash
# exec@host: docker,dcp
img=docker:18.09.8 #18.09.3
docker run -v /_ext:/mnt $img sh -c "cp /usr/local/bin/docker /mnt; ls -lh /mnt |grep docker"
img=registry.cn-shenzhen.aliyuncs.com/k-bin/sync-kube:kube-att
docker run --rm -v /_ext:/mnt $img sh -c 'cp -a /down/docker-compose /mnt/; ls -lh /mnt |grep docker'

# links@HeadlessBox: docker, socket
sudo bash -c "ln -s /_ext/docker /bin/; ln -s /_ext/docker-compose /usr/bin/dcp"
sudo bash -c "ln -s /mnt/var/run/docker.sock /var/run/; chmod 777 /var/run/docker.sock"
```
