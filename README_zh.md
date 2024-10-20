**Docker云桌面**（docker-headless）

基于`Ubuntu20.04`胖容器+远程接入, 实现`Linux`下私人桌面、云端办公。在生产跑浏览器做调试/维护。在服务器搭建专用开发环境，公司/Home互通办公。[[Detail]](./Detail.md)

[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/infrastlabs/docker-headless.svg)](https://hub.docker.com/r/infrastlabs/docker-headless)
[![Last commit](https://img.shields.io/github/last-commit/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless)
[![GitHub issues](https://img.shields.io/github/issues/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless/issues)

**一、快速开始**

`docker run -it --rm --shm-size 1g --net=host infrastlabs/docker-headless:latest`

 -- | 连接 | 密码 | 只读密码 
--- | ---  | ---  | ---
noVnc | http://192.168.0.x:10081 | `headless` | `View123` 
RDP   | 192.168.0.x:10089        | `headless` | - 
SSH   | ssh -p 10022 headless@192.168.0.x | `headless` | - 

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/_doc/res/01rdp-double-screen.png)

**二、设计说明**

- 容器：环境固化、宿主隔离、胖容器/虚拟机
- 桌面：远程共享、双屏支持(RDP)、只读屏幕(noVNC)
- 特色：远程音频、本土化、输入法(五笔/拼音)
- 多桌面：Xfce,Mate,Cinnamon,Gnome,Plasma
- 小体积：镜像层复用、小巧精简 `core: 170.53 MB`, `latest: 277.48 MB`, `sogou: 354.15 MB`

![](./_doc/res/design/RDesktop.png)

**三、使用示例**

多语言快速体验: `docker run -it --rm --shm-size 1g -e VNC_OFFSET=20 -e L=zh_CN --net=host infrastlabs/docker-headless:latest`, 推荐[docker-compose.yml](./docker-compose.yml)

```bash
# LiveCD Experience: gnome/plasma, mint-series only with x86(cinna, cmate, cxfce)
# Plasma/Mint with START_SYSTEMD=false
docker run -it --rm --net=host --shm-size 1g \
  -e L=en_US -e VNC_OFFSET=99 -e START_SYSTEMD=false infrastlabs/docker-headless:cmate

# Gnome with systemd, cgroup_v2: --cgroupns=host (docker 20.10+)
docker run -it --rm --net=host --shm-size 1g -e VNC_OFFSET=99 \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN infrastlabs/docker-headless:gnome
```

**(1)Dev开发环境搭建** (java, golang, nodejs)

```bash
# JAVA
sudo apt -y install openjdk-8-jdk openjdk-8-source && sudo apt -y install maven 
# GO
goVer=go1.19.9 #1.19.9:142.16M 1.17.8:129M #go1.16.15 #go1.13.15
wget https://studygolang.com/dl/golang/$goVer.linux-amd64.tar.gz
tar -zxf $goVer.linux-amd64.tar.gz; mv go $goVer.linux-amd64
rm -f godev; ln -s $goVer.linux-amd64 godev #link godev
# NODE https://nodejs.org/zh-cn/download/releases
ver=v18.16.0 #v16.20.0 #v14.20.0
wget https://nodejs.org/download/release/$ver/node-$ver-linux-x64.tar.xz
xz -d node-$ver-linux-x64.tar.xz #tar.xz消失
tar -xvf node-$ver-linux-x64.tar

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
# wget https://vscode.cdn.azure.cn/stable/6cba118ac49a1b88332f312a8f67186f7f3c1643/code_1.61.2-1634656828_amd64.deb
wget https://vscode.cdn.azure.cn/stable/e8a3071ea4344d9d48ef8a4df2c097372b0c5161/code_1.74.2-1671532382_arm64.deb
wget https://vscode.cdn.azure.cn/stable/6445d93c81ebe42c4cbd7a60712e0b17d9463e97/code_1.81.0-1690980880_amd64.deb
###
https://code.visualstudio.com/updates/v1_74  #az764295.vo.msecnd.net > vscode.cdn.azure.cn
https://update.code.visualstudio.com/1.74.3/linux-x64/stable
https://update.code.visualstudio.com/1.74.3/linux-arm64/stable #x64> arm64
https://vscode.cdn.azure.cn/stable/97dec172d3256f8ca4bfb2143f3f76b503ca0534/code-stable-arm64-1673284434.tar.gz
https://vscode.cdn.azure.cn/stable/97dec172d3256f8ca4bfb2143f3f76b503ca0534/code-stable-x64-1673285154.tar.gz
#
#wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz
#wget https://download.jetbrains.com.cn/idea/ideaIC-2016.3.8-no-jdk.tar.gz #322M
wget https://download.jetbrains.com/idea/ideaIC-2017.3.7-no-jdk.tar.gz #366M JUnit5 Support
```

![](_doc/res/02/ide2-vscode.png)

**(2)浏览器、Office办公**

wps, chrome/firefox

```bash
# 火狐/谷歌浏览器
sudo apt -y install firefox #firefox-esr chromium
# 网易云音乐
wget https://d1.music.126.net/dmusic/netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb
# WPS三件套
# https://blog.csdn.net/u012939880/article/details/89439647 #wps_symbol_fonts.zip
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office_11.1.0.10161_amd64.deb
# 支持中文输入法
sudo sed -i "1a export XMODIFIERS=@im=ibus" /usr/bin/{wps,wpp,et}
sudo sed -i "2a export QT_IM_MODULE=ibus" /usr/bin/{wps,wpp,et}
```

![](_doc/res/02/apps-office-wps.jpg)


**(3)Docker Dind模式**

支持在容器内调用宿主机的dockerd，用于dockerfile构建、容器控制等场景。

![](_doc/res/02/dind2-headlessLinks.png)

```bash
# 宿主机运行：获取docker,docker-compose文件:
img=docker:18.09.8 #18.09.3
docker run -v /_ext:/mnt $img sh -c "\cp /usr/local/bin/docker /mnt; ls -lh /mnt |grep docker"
img=registry.cn-shenzhen.aliyuncs.com/k-bin/sync-kube:kube-att
docker run --rm -v /_ext:/mnt $img sh -c '\cp -a /down/docker-compose /mnt/; ls -lh /mnt |grep docker'

# 软链接: docker, socket
ls /_ext/ |grep docker
sudo bash -c "ln -s /_ext/docker /bin/; ln -s /_ext/docker-compose /usr/bin/dcp"
sudo bash -c "ln -s /mnt/var/run/docker.sock /var/run/; chmod 777 /var/run/docker.sock"
```
