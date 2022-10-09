# Docker云桌面（docker-headless）

[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/infrastlabs/docker-headless.svg)](https://hub.docker.com/r/infrastlabs/docker-headless)
[![Last commit](https://img.shields.io/github/last-commit/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless)
[![GitHub issues](https://img.shields.io/github/issues/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless/issues)

Multi-Desktop with `XRDP/NOVNC/PulseAudio` based on `Ubuntu20.04`, Formatting a HeadlessBox/Cloud Desktop.

- Screen shared with both RDP/noVnc. (ReadWrite/ReadOnly)
- MultiScreen support. (mstsc+xrdp+tigervnc)
- Audio support. (xrdp+pulseaudio/noVNC+broadcast)
- Locale/TZ support. 中文输入法(五笔/拼音)
- Desktop apps: ibus-rime/fcitx-sogou, flameshot, PAC.
- 精简小巧 `core: 170.53 MB(fluxbox)`, `latest: 277.48 MB(ibus,xfce4.14)`, `sogou: 354.15 MB(fcitx)`


## 一、快速开始

`docker run -it --rm --shm-size 1g --net=host infrastlabs/docker-headless`

 -- | 连接 | 密码 | 只读密码 
--- | ---  | ---  | ---
noVnc | http://192.168.0.x:10081 | `headless` | `View123` 
RDP   | 192.168.0.x:10089        | `headless` | - 
SSH   | ssh -p 10022 headless@192.168.0.x | `headless` | - 

**镜像清单**

 TAG | 发行版 | 桌面 | 输入法 | 启动器 | 镜像 |推荐|说明 
--- | --- | ---  | ---  | --- | --- | --- | ---
latest |Ubuntu| xfce | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|定制,体积小
sogou  |Ubuntu| xfce | fcitx | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/sogou)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|搜狗输入法
core   |Ubuntu| flux | ibus  | supervisor | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/core)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|配置层,调试用
---|---|---|---|---|---|---
gnome   |Ubuntu| gnome | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/gnome)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|兼容性好
plas   |Kubuntu| plasma | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/plas)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|设置左侧黑块
cinna   |Mint| cinnamon | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cinna)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★☆|显卡驱动提示
cmate   |Mint| mate | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cmate)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|体验良好
cxfce   |Mint| xfce | ibus  | systemd | [![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/cxfce)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)|★★★★★|新版xfce

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/mannual/res/01rdp-double-screen.png)

## 二、Producttion

x86/arm64 supported, 推荐 docker-compose: [docker-compose.yml](./docker-compose.yml) [docker-compose.lite.yml](./docker-compose.lite.yml)

- [定制版 docker-compose.yml](./ubt-custom/docker-compose.yml) latest,sogou,core 三组
- [多桌面 docker-compose.yml](./ubt-desktop/docker-compose.yml) gnome,plas,cinna,cmate,cxfce 五组

```bash
# supvervisor: core, latest, sogou (--privileged: xrdp-disk-mount)
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  infrastlabs/docker-headless:sogou

# systemd: gnome(must-systemd), plas, mint(cinna, cmate, cxfce)
# 注：sogou arm64版暂未支持, mint系列暂只有x86(cinnamon,mate,xfce4.16) ，它官方没找到arm源
docker  run -d -p 10081:10081 -p 10089:10089 --shm-size 1g \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  infrastlabs/docker-headless:gnome
```

**(0)源码目录**

- [deb9: 基于Debian9的版本 (xfce定制:体积小,稳定)](./deb9/)
- [ubt-core: Ubuntu基础版 (极简:含核心远程组件，内置fluxbox)](./ubt-core/)
- [ubt-custom: 新版Ubuntu20.04 (xfce定制:Xfce4.14, 对标deb9, 搜狗输入法)](./ubt-custom/)
- [ubt-desktop: 多桌面 (通用:Gnome,Plasma,Cinnamon,Mate,Xfce4)](./ubt-desktop/)

**(1)密码修改**: 生产禁用默认密码，初始后请修改!!

```bash
# 动态修改密码：
SSH_PASS=xxx  VNC_PASS=xxx2  VNC_PASS_RO=xxx3
echo "headless:$SSH_PASS" |sudo chpasswd
echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |sudo vncpasswd /etc/xrdp/vnc_pass; sudo chmod 644 /etc/xrdp/vnc_pass
```

**(2)使用帮助**: 

- [云桌面功能简介](./_doc/mannual/01-CloudDesktop.md) &nbsp; [TODO](./_doc/mannual/b0-todo.md)
- [1.如何设置为中文或其它语言？](./_doc/mannual/b1-locale.md)
- [2.双屏连接，远程剪切板、音频如何使用？](./_doc/mannual/b2-rdp.md)
- [3.如何WEB访问远程桌面？](./_doc/mannual/b3-vnc.md)
- [4.中文输入法、截图软件使用说明](./_doc/mannual/b4-apps.md)
- [5.音乐播放器及远程音频相关说明](./_doc/mannual/b5-audio.md)
- [6.如何使用Ubuntu, Mate，KDE等其它桌面](./_doc/mannual/b6-desktop.md) (多桌面,网关模式)
- [Detail明细说明](./detail.md) （快捷键、环境变量、系统应用）


**(3)生产部署指引**: 

- [Windows虚拟机部署：](./_doc/deploy/win-vbox/README.md) 采用barge-os迷你容器系统, --net=host 采用虚机IP 
- [Linux服务器部署：](./_doc/deploy/fat-docker/README.md) 容器使用macvlan网络，分配专用IP，建议安装lxcfs
- [K8S内部署：](./_doc/deploy/k8s-headless/README.md) Deployment+Service

## 三、使用示例

多语言快速体验: `docker run -it --rm --shm-size 1g -e VNC_OFFSET=20 -e L=zh_CN --net=host infrastlabs/docker-headless:latest`, 推荐[docker-compose.yml](./docker-compose.yml)

**(1)Dev开发环境搭建** (java, golang, nodejs)

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
# wget https://vscode.cdn.azure.cn/stable/91899dcef7b8110878ea59626991a18c8a6a1b3e/code_1.47.3-1595520028_amd64.deb
# wget https://vscode.cdn.azure.cn/stable/c3f126316369cd610563c75b1b1725e0679adfb3/code_1.58.2-1626302803_amd64.deb
wget https://vscode.cdn.azure.cn/stable/6cba118ac49a1b88332f312a8f67186f7f3c1643/code_1.61.2-1634656828_amd64.deb
#wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz
wget https://download.jetbrains.com.cn/idea/ideaIC-2016.3.8-no-jdk.tar.gz
```

![](_doc/mannual/res/02/ide2-vscode.png)

**(2)浏览器、Office办公**

wps, chrome/firefox

```bash
# 火狐/谷歌浏览器
sudo apt -y install firefox-esr chromium #chromium-driver
# 网易云音乐
wget https://d1.music.126.net/dmusic/netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb
# WPS三件套
# https://blog.csdn.net/u012939880/article/details/89439647 #wps_symbol_fonts.zip
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office_11.1.0.10161_amd64.deb
# 支持中文输入法
sudo sed -i "1a export XMODIFIERS=@im=ibus" /usr/bin/{wps,wpp,et}
sudo sed -i "2a export QT_IM_MODULE=ibus" /usr/bin/{wps,wpp,et}
```

![](_doc/mannual/res/02/apps-office-wps.jpg)


**(3)Docker Dind模式**

支持在容器内调用宿主机的dockerd，用于dockerfile构建、容器控制等场景。

![](_doc/mannual/res/02/dind2-headlessLinks.png)

```bash
# 宿主机运行：获取docker,docker-compose文件:
img=docker:18.09.8 #18.09.3
docker run -v /_ext:/mnt $img sh -c "cp /usr/local/bin/docker /mnt; ls -lh /mnt |grep docker"
img=registry.cn-shenzhen.aliyuncs.com/k-bin/sync-kube:kube-att
docker run --rm -v /_ext:/mnt $img sh -c 'cp -a /down/docker-compose /mnt/; ls -lh /mnt |grep docker'

# 软链接: docker, socket
ls /_ext/ |grep docker
sudo bash -c "ln -s /_ext/docker /bin/; ln -s /_ext/docker-compose /usr/bin/dcp"
sudo bash -c "ln -s /mnt/var/run/docker.sock /var/run/; chmod 777 /var/run/docker.sock"
```
