# Docker云桌面（docker-healess）

[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/slim)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/latest)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/infrastlabs/docker-headless/full)](https://hub.docker.com/r/infrastlabs/docker-headless/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/infrastlabs/docker-headless.svg)](https://hub.docker.com/r/infrastlabs/docker-headless)
[![Last commit](https://img.shields.io/github/last-commit/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless)
[![GitHub issues](https://img.shields.io/github/issues/infrastlabs/docker-headless.svg)](https://www.github.com/infrastlabs/docker-headless/issues)

基于Docker的远程开发/办公运维的桌面环境，(Debian+XRDP/NOVNC+XFCE4)

**(1)QuickStart**

`docker run -it --rm --shm-size 1g --net=host infrastlabs/docker-headless`

- noVnc: https://localhost:10081 #VNC_PASS: `headless`, VNC_PASS_RO: `View123`
- RDP: `localhost:10089` #VNC_PASS: `headless`
- SSH: `ssh -p 10022 headless@localhost` #SSH_PASS: `headless`

**Caution**: 生成禁用默认密码，初始后请修改!!

```bash
# SSH_PASS VNC_PASS VNC_PASS_RO
SSH_PASS=xxx
VNC_PASS=xxx
VNC_PASS_RO=xxx
echo "headless:$SSH_PASS" |chpasswd
echo -e "$VNC_PASS\n$VNC_PASS\ny\n$VNC_PASS_RO\n$VNC_PASS_RO"  |vncpasswd /etc/xrdp/vnc_pass; chmod 644 /etc/xrdp/vnc_pass
```

![](https://gitee.com/infrastlabs/docker-headless/raw/dev/docs/res/01rdp-double-screen.png)

**(2)Dev 远程开发**

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
wget https://vscode.cdn.azure.cn/stable/c3f126316369cd610563c75b1b1725e0679adfb3/code_1.58.2-1626302803_amd64.deb
wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz
```

![](docs/res/02/ide2-vscode.png)

![](docs/res/02/ide1-idea.png2)

**(3)Office远程办公**

wps, chrome/firefox

```bash
# WPS
# https://blog.csdn.net/u012939880/article/details/89439647 #wps_symbol_fonts.zip
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office_11.1.0.10161_amd64.deb
# Browser
sudo apt -y install firefox-esr chromium #chromium-driver
```

![](docs/res/02/apps-browsers.jpg2)

![](docs/res/02/apps-office-wps.jpg)


**(4)Docker Dind模式**

```bash
# docker,dcp: run@host
img=docker:18.09.8 #18.09.3
docker run -v /_ext:/mnt $img sh -c "cp /usr/local/bin/docker /mnt; ls -lh /mnt |grep docker"
img=registry.cn-shenzhen.aliyuncs.com/k-bin/sync-kube:kube-att
docker run --rm -v /_ext:/mnt $img sh -c 'cp -a /down/docker-compose /mnt/; ls -lh /mnt |grep docker'

# links: @HeadlessBox
ls /_ext/ |grep docker
sudo ln -s /_ext/docker /bin/
sudo ln -s /_ext/docker-compose /usr/bin/dcp
# sock
sudo ln -s /mnt/var/run/docker.sock /var/run/
sudo chmod 777 /var/run/docker.sock

# check
docker version
dcp -v
```

![](docs/res/02/dind1-hostDown.png2)

![](docs/res/02/dind2-headlessLinks.png)
