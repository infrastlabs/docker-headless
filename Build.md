

- https://www.cnblogs.com/dakewei/p/13332688.html #docker如何构建多架构(arm64, x86_64, armv7)容器镜像?
- https://cloud.tencent.com/developer/article/1543689 #Docker 19.03 引入的插件 buildx ##发布于2019-11-25 16:19:02阅读 17.7K|29.9K@23.9.28 `buildx v032`
- https://blog.csdn.net/u014110320/article/details/124406628 #Docker buildx 安装 ##2022-04-25 `buildx v082`
- 
- https://www.jianshu.com/p/5426e7ad36f2 #docker-static Docker 静态二进制安装
- https://download.docker.com/linux/static/stable/ #docker-19.03.15.tgz 2021-02-01 21:54:16 59.5 MiB
- https://github.com/docker/buildx/graphs/contributors
- https://hub.docker.com/r/tonistiigi/binfmt/tags #22.84 MB #latest qemu-v6.2.0
- 
- https://www.jb51.net/article/178098.htm #搭建docker registry多平台版本
- https://docs.docker.com/registry/compatibility/ #2.3, multiple architecture images
- 
- https://github.com/moby/buildkit #buildKit, buildx: --cache-to; --cache-from
- https://docs.docker.com/engine/reference/commandline/buildx_build/

```bash
# unknown/unknown Artifact #1990
# https://github.com/docker/buildx/issues/1509
Copying my workaround suggestions from another issue:

  1. Use `docker buildx imagetools inspect --raw` instead of `docker manifest inspect` - it should work similarly, and supports all the different media types in the registry. See the docs for [`docker buildx imagetools inspect.`](https://docs.docker.com/engine/reference/commandline/buildx_imagetools_inspect/).
      Hopefully, this will just work, and should be a drop-in replacement!

  2. Set `oci-mediatypes=false` in your `--output` flag (to use the docker distribution manifest list instead of an OCI index).
      This might cause some issues with the generated provenance, which means you\'d probably prefer 3 instead.

  3. Set `--provenance=false` to not generate the provenance (which is what causes the multi-platform index to be generated, even for a single platform).
      Just remove the generated provenance entirely, this means that only a single manifest is created, no index needed, which sidesteps the problem.
```

**1)MultiArch构建**

```bash
# https://cloud.tencent.com/developer/article/1543689
方法三：模拟目标硬件的用户空间
在 Linux 上，QEMU 除了可以模拟完整的操作系统之外，还有另外一种模式叫用户态模式（User mod）。该模式下 QEMU 将通过 binfmt_misc[2] 在 Linux 内核中注册一个二进制转换处理程序，并在程序运行时动态翻译二进制文件，根据需要将系统调用从目标 CPU 架构转换为当前系统的 CPU 架构。
# srcBuild
export DOCKER_BUILDKIT=1
docker build --platform=local -o . git://github.com/docker/buildx
mv buildx /xx/yy
# binfmt
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
ls -al /proc/sys/fs/binfmt_misc/
cat /proc/sys/fs/binfmt_misc/qemu-aarch64
# mybuilder
docker buildx create --use --name mybuilder
docker buildx inspect mybuilder --bootstrap
# build
docker buildx build -t repo/hello-arch --platform=linux/arm,linux/arm64,linux/amd64 . --push
# 如将构建好的镜像保存在本地，可以将 type 指定为 docker，但必须分别为不同的 CPU 架构构建不同的镜像，不能合并成一个镜像，即：
docker buildx build -t yangchuansheng/hello-arch --platform=linux/arm -o type=docker .
docker buildx build -t yangchuansheng/hello-arch --platform=linux/arm64 -o type=docker .


# https://blog.csdn.net/u014110320/article/details/124406628
# 一、docker版本及配置
docker19.03.15: 服务端开启实验室特性。在配置文件/etc/docker/daemon.json中加入`"experimental": true`配置项

# 二、docker-buildx插件
# 45.6 MB 04-Apr-2022 v0.8.2
# 44.6 MB 19-Aug-2022 v0.9.1
curl -O -k -fSL https://hub.fastgit.xyz/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-amd64

# 让其在系统级别可用，可将其拷贝至如下路径：
/usr/local/lib/docker/cli-plugins OR /usr/local/libexec/docker/cli-plugins
/usr/lib/docker/cli-plugins OR /usr/libexec/docker/cli-plugins

# 确认安装成功
docker buildx version
docker buildx ls

# 三、安装模拟器
# docker/binfmt https://github.com/linuxkit/linuxkit/tree/master/pkg/binfmt
# tonistiigi/binfmt https://github.com/tonistiigi/binfmt #latest qemu-v6.2.0
docker run --privileged --rm tonistiigi/binfmt --install all #22.84 MB
# 验证模拟器是否安装成功
docker buildx ls 
# 查看某个，检查aarch64是否安装成功
cat /proc/sys/fs/binfmt_misc/qemu-aarch64

# 离线模式(save -o; load -i)
# 外网节点导出镜像
$ docker save -o moby_buildkit_buildx-stable-x-arm64.tar 9b3c7392ac9e
# 内网节点导入镜像
$ docker load -i moby_buildkit_buildx-stable-x-arm64.tar 9b3c7392ac9e
$ docker tag 9b3c7392ac9e moby/buildkit:buildx-stable-1

# 四、Build多平台image
# 创建builder
docker buildx create --use --name mybuilder
# build镜像
docker buildx build --platform linux/amd64,linux/arm64 --push -t repo/hello .

# insecure: /etc/buildkit/buildkitd.toml
[registry."a.b.c:5000"]
  mirrors = ["a.b.c:5000"]
  http = true
  insecure = true
```

**2)操作记录**

- 23.195-cent7> 21.60-suse12

```bash
# docker buildx build --network=host
# https://blog.csdn.net/qq_42353939/article/details/120392393
docker buildx create --use --name mybuilder2 --buildkitd-flags '--allow-insecure-entitlement network.host'

# binfmt 宿主重启后得重初始
docker run --privileged --rm tonistiigi/binfmt --install all
cat /proc/sys/fs/binfmt_misc/qemu-aarch64

# back for cache's reuse
host-21-60:~ # docker buildx use mybuilder
host-21-60:~ # docker buildx ls

# version
[root@node195 ~]# ll /usr/bin/ |grep docker
lrwxrwxrwx. 1 root root         20 Oct 28  2021 docker -> /opt/kube/bin/docker
lrwxrwxrwx. 1 root root         21 Oct 28  2021 dockerd -> /opt/kube/bin/dockerd
[root@node195 ~]# cd /opt/kube/bin
[root@node195 bin]# ll
total 215636
-rwxr-xr-x  1 1000 1000 36789288 Jan 30  2021 containerd
-rwxr-xr-x  1 1000 1000  7172096 Jan 30  2021 containerd-shim
-rwxr-xr-x  1 1000 1000 19161064 Jan 30  2021 ctr
-rwxr-xr-x  1 1000 1000 61133792 Jan 30  2021 docker
-rwxr-xr-x. 1 root root 11748168 Dec 18  2020 docker-compose
-rwxr-xr-x  1 1000 1000 71555008 Jan 30  2021 dockerd
-rwxr-xr-x  1 1000 1000   708616 Jan 30  2021 docker-init
-rwxr-xr-x  1 1000 1000  2928566 Jan 30  2021 docker-proxy
-rwxr-xr-x  1 1000 1000  9600824 Jan 30  2021 runc
[root@node195 bin]# docker version
Client: Docker Engine - Community
 Version:           19.03.15
 Experimental:      true
Server: Docker Engine - Community
 Engine:
  Version:          19.03.15
  Experimental:     true
 containerd:
  Version:          v1.3.9
 runc:
  Version:          1.0.0-rc10
 docker-init:
  Version:          0.18.0

# experimental
[root@node195 bin]# cat /etc/docker/daemon.json
{
  "hosts": ["unix:///var/run/docker.sock"],
  "insecure-registries": ["127.0.0.1/8", "harbor.xx.com", "deploy.xx.com", "0.0.0.0/0"],
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
    },
  "data-root": "/data/docker-data",
  "bip": "174.26.0.1/16",
  "experimental": true
}

# plugins
[root@node195 bin]# ll /usr/local/lib/docker/cli-plugins
total 46680
-rwxr-xr-x 1 root root 47800320 Jul 27 14:30 buildx-v0.8.2.linux-amd64
lrwxrwxrwx 1 root root       25 Jul 27 14:31 docker-buildx -> buildx-v0.8.2.linux-amd64
host-21-60:~ # ll /usr/local/lib/docker/cli-plugins
total 46680
-rwxr-xr-x 1 root root 47800320 Jul 27 14:30 buildx-v0.8.2.linux-amd64
lrwxrwxrwx 1 root root       25 Jul 27 14:32 docker-buildx -> buildx-v0.8.2.linux-amd64
```

- 21.68 suse12

```bash
# binfmt (23.195: cent7_kernel_fail)
host-21-68:~ # docker run --privileged --rm tonistiigi/binfmt --install all
Unable to find image 'tonistiigi/binfmt:latest' locally
latest: Pulling from tonistiigi/binfmt
8d4d64c318a5: Pull complete 
e9c608ddc3cb: Pull complete 
Digest: sha256:66e11bea77a5ea9d6f0fe79b57cd2b189b5d15b93a2bdb925be22949232e4e55
Status: Downloaded newer image for tonistiigi/binfmt:latest
installing: arm OK
installing: mips64le OK
installing: s390x OK
installing: ppc64le OK
installing: riscv64 OK
installing: mips64 OK
installing: arm64 OK
{
  "supported": [
    "linux/amd64",
    "linux/arm64",
    "linux/riscv64",
    "linux/ppc64le",
    "linux/s390x",
    "linux/386",
    "linux/mips64le",
    "linux/mips64",
    "linux/arm/v7",
    "linux/arm/v6"
  ],
  "emulators": [
    "jexec",
    "qemu-aarch64",
    "qemu-arm",
    "qemu-mips64",
    "qemu-mips64el",
    "qemu-ppc64le",
    "qemu-riscv64",
    "qemu-s390x"
  ]
}
host-21-68:~ # docker version
Client: Docker Engine - Community
 Version:           18.09.6
 Experimental:      false
Server: Docker Engine - Community
 Engine:
  Version:          18.09.6
```

- 21.60 suse12

```bash
# hist:21.60
host-21-60:~ # history |grep arm
  414  2022-07-27 14:47:09 docker buildx build --platform linux/amd64,linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .
  416  2022-07-27 14:47:45 docker buildx build --platform linux/amd64,linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .
  427  2022-07-27 14:56:29 docker buildx build --platform linux/amd64,linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .
  429  2022-07-27 14:59:18 docker buildx build --platform linux/amd64,linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .
  431  2022-07-27 14:59:48 docker buildx build --platform linux/amd64,linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .
  433  2022-07-27 15:03:44 docker buildx build --platform linux/amd64,linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .
  434  2022-07-27 15:05:03 docker buildx build --platform linux/arm64  -t $repo/$ns/$img -f src/Dockerfile.compile .

host-21-60:~ # docker version
Client: Docker Engine - Community
 Version:           19.03.15
 Experimental:      false
Server: Docker Engine - Community
 Engine:
  Version:          19.03.15
  Experimental:     true  

host-21-60:~ # docker buildx ls 
NAME/NODE    DRIVER/ENDPOINT             STATUS  PLATFORMS
mybuilder *  docker-container                    
  mybuilder0 unix:///var/run/docker.sock running linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64, linux/arm/v7, linux/arm/v6
default      docker                              
  default    default                     running linux/amd64, linux/386

# builx构建后，不存在本地image
host-21-60:/opt/working3/_ee/docker-headless/ubt-core # sh buildx.sh 
host-21-60:~ # docker images |grep arm
host-21-60:~ # docker images |grep core
```

**3)x86运行**

```bash
host-21-60:~ # docker run --platform=arm64 -it --rm --shm-size 1g --net=host infrastlabs/docker-headless:core-v5-arm
oneVnc: id=10, name=headless
Would you like to enter a view-only password (y/n)? Password:Verify:Password:Verify:
L=zh_CN
TZ=Asia/Shanghai
====LANG: zh_CN.UTF-8, LANGUAGE: zh_CN:en==========================
Generating locales (this might take a while)...
  zh_CN.UTF-8... done
Generation complete.
==[locale -a]====================================
C
C.UTF-8
POSIX
zh_CN.utf8
zh_SG.utf8
#  File generated by update-locale
LANG=zh_CN.UTF-8
LANGUAGE=zh_CN:en
sleep 0.1
2022-10-02 11:30:24,058 INFO success: xrdp entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2022-10-02 11:30:24,059 INFO success: ssh entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2022-10-02 11:30:24,059 INFO success: novnc entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2022-10-02 11:30:24,059 INFO success: x10-xvnc entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2022-10-02 11:30:24,060 INFO success: x10-pulse entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2022-10-02 11:30:24,060 INFO success: x10-parec entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2022-10-02 11:30:24,061 INFO success: x10-de entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```
