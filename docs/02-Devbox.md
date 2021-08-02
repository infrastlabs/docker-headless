# Devbox

## SDK|IDE

```bash
# JAVA
sudo apt -y install openjdk-8-jdk && sudo apt -y install maven 

# GO/NODE
wget https://studygolang.com/dl/golang/go1.13.15.linux-amd64.tar.gz
tar -zxf go1.13.15.linux-amd64.tar.gz; mv go go1.13.15.linux-amd64
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

#IDE: vscode, idea-ic
# wget https://vscode.cdn.azure.cn/stable/91899dcef7b8110878ea59626991a18c8a6a1b3e/code_1.47.3-1595520028_amd64.deb
wget https://vscode.cdn.azure.cn/stable/c3f126316369cd610563c75b1b1725e0679adfb3/code_1.58.2-1626302803_amd64.deb #org's down, replace domain to azure.
wget https://download.jetbrains.8686c.com/idea/ideaIC-2016.3.8-no-jdk.tar.gz #run with:openjdk8
```

![](res/02/ide2-vscode.png)

![](res/02/ide1-idea.png)

## BROWSER|OFFICE

wps, chrome/firefox

```bash
#BROWSER|OFFICE
# https://blog.csdn.net/u012939880/article/details/89439647 #wps_symbol_fonts.zip
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office_11.1.0.10161_amd64.deb
sudo apt -y install firefox-esr chromium #chromium-driver
```

![](res/02/apps-browsers.jpg)

![](res/02/apps-office-wps.jpg)


## Dind


```bash
# docker,dcp: run@host
img=docker:18.09.8 #18.09.3
docker run -v /_ext:/mnt $img sh -c "cp /usr/local/bin/docker /mnt; ls -lh /mnt |grep docker"
img=registry.cn-shenzhen.aliyuncs.com/k-bin/sync-kube:kube-att
docker run --rm -v /_ext:/mnt $img sh -c 'cp -a /down/docker-compose /mnt/; ls -lh /mnt |grep docker'

# links: run@HeadlessBox
ls /_ext/ |grep docker
sudo ln -s /_ext/docker /bin/
sudo ln -s /_ext/docker-compose /usr/bin/dcp
# sock
sudo ln -s /mnt/var/run/docker.sock /var/run/
sudo chmod 777 /var/run/docker.sock

# check
docker version
dcp -v
# Dind 23.191 @23.22_pve
# DOCKER_HOST="unix:///data3-ssd/docker-ct3/docker.sock"

```

![](res/02/dind1-hostDown.png)

![](res/02/dind2-headlessLinks.png)
