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

## QuickStart

`docker run -it --rm --shm-size 1g --net=host infrastlabs/docker-headless`

 -- | Conn | PASS | ReadOnly 
--- | ---  | ---  | ---
noVnc | https://192.168.0.x:10081 | `headless` | `View123` 
RDP | 192.168.0.x:10089 | `headless` | - 
SSH | ssh -p 10022 headless@192.168.0.x | `headless` | - 

**(1)resetPass**: non-production usage with default password!!

```bash
SSH_PASS=xxx  VNC_PASS=xxx2  VNC_PASS_RO=xxx3
echo "headless:$SSH_PASS" |sudo chpasswd
echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |sudo vncpasswd /etc/xrdp/vnc_pass; sudo chmod 644 /etc/xrdp/vnc_pass
```

**(2)UserManual**: 

- [CloudDesktop Introduce](./docs/01-CloudDesktop.md)
- [1.How to set Locale?](./docs/b0-locale.md)
- [2.Usage of Double-Screen, ClipBoard, Audio?](./docs/b1-rdp.md)
- [3.WEB entry of desktop?](./docs/b2-vnc.md)
- [4.Usage of IBUS/Flameshot](./docs/b3-apps.md)
- [Details](./detail.md) （Hotkeys, Envs, SysApps）


![](https://gitee.com/infrastlabs/docker-headless/raw/dev/docs/res/01rdp-double-screen.png)

**(3)Producttion-Deployment**: 

- [Windows-VM Deployment：](./deploy/virtualbox/README.md) With `barge-os` mini-container system, `--net=host` Use the VM's IP 
- [Linux-Server Deployment：](./deploy/fat-docker/README.md) Use `macvlan`'s network，with special IP，sugest with lxcfs installed.
- [Kubernetes Deployment：](./deploy/kubernetes/README.md) StatefulSet(TODO)

## UseCase

Quick start with Locale: `docker run -it --rm --shm-size 1g -e VNC_OFFSET=20 -e L=zh_CN --net=host infrastlabs/docker-headless:full`, Prefer [docker-compose.yml](./docker-compose.yml)

**(1)Development** (java, golang, nodejs)

```bash
# JAVA
sudo apt -y install openjdk-8-jdk openjdk-8-source && sudo apt -y install maven 
# GO
wget https://studygolang.com/dl/golang/go1.13.15.linux-amd64.tar.gz
tar -zxf go1.13.15.linux-amd64.tar.gz; mv go go1.13.15.linux-amd64
# NODE
wget https://npm.taobao.org/mirrors/node/v14.13.1/node-v14.13.1-linux-x64.tar.xz
xz -d node-v14.13.1-linux-x64.tar.xz #tar.xz消失
tar -xvf node-v14.13.1-linux-x64.tar

cat >> /etc/profile <<EOF
# NODE
NODE_HOME=/_ext/down/node-v14.13.1-linux-x64
PATH=\$PATH:\$NODE_HOME/bin
export NODE_HOME PATH
# GO
GO_HOME=/_ext/down/go1.13.15.linux-amd64
GOPATH=/_ext/gopath
PATH=\$PATH:\$GO_HOME/bin:\$GOPATH/bin
export GO_HOME GOPATH PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
EOF

#IDE: vscode, ideaIC
# wget https://vscode.cdn.azure.cn/stable/91899dcef7b8110878ea59626991a18c8a6a1b3e/code_1.47.3-1595520028_amd64.deb
# wget https://vscode.cdn.azure.cn/stable/c3f126316369cd610563c75b1b1725e0679adfb3/code_1.58.2-1626302803_amd64.deb
wget https://vscode.cdn.azure.cn/stable/6cba118ac49a1b88332f312a8f67186f7f3c1643/code_1.61.2-1634656828_amd64.deb
wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz
```

![](docs/res/02/ide2-vscode.png)

**(2)Office**

wps, chrome/firefox

```bash
# firefox, chromium
sudo apt -y install firefox-esr chromium #chromium-driver
# WPS Office
# https://blog.csdn.net/u012939880/article/details/89439647 #wps_symbol_fonts.zip
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office_11.1.0.10161_amd64.deb
# ibus support with wps
sed -i "1a export XMODIFIERS=@im=ibus" /usr/bin/wps /usr/bin/wpp /usr/bin/et
sed -i "2a export QT_IM_MODULE=ibus" /usr/bin/wps /usr/bin/wpp /usr/bin/et
```

![](docs/res/02/apps-office-wps.jpg)


**(3)Docker Dind**

![](docs/res/02/dind2-headlessLinks.png)

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
