#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)
cd $cur
set +e
# dash>> 本操作从1970年01月01日00:00:00 开始 , 到2024年09月10日01:54:39 结束,  共历时1725933279秒
# rm -f /bin/sh; ln -s /bin/bash /bin/sh #deb,ubt; >>>>送错参
source ../../compile/src/common.sh #print_time_cost

# ref quickstart-imgdeploy//imgpackage/2syncer.sh
# https://github.com/AliyunContainerService/image-syncer/releases/download/v1.5.5/image-syncer-v1.5.5-linux-amd64.tar.gz
# https://github.com/AliyunContainerService/image-syncer/releases/download/v1.5.5/image-syncer-v1.5.5-linux-arm64.tar.gz
function loadBins(){
  file=image-syncer-v1.5.5-linux-amd64.tar.gz; URL=https://github.com/AliyunContainerService/image-syncer/releases/download/v1.5.5/$file
  curl -O -k -fSL $URL; 
  # view
  echo "cur: $cur"; pwd; 
  ls -lh

  tar -zxf $file #-C ./ #$cur/
  ls -lh
}
loadBins

mkdir -p conf
function authConf(){
  cat > conf/auth.yaml<<EOF
##auth-hub << toomanyrequests: You have reached your pull rate limit. 
# You may increase the limit by authenticating and upgrading
registry-1.docker.io:
  username: $DOCKER_REGISTRY_USER_dockerhub
  password: $DOCKER_REGISTRY_PW_dockerhub
registry.cn-shenzhen.aliyuncs.com:
  username: $DOCKER_REGISTRY_USER_infrastSubUser2
  password: $DOCKER_REGISTRY_PW_infrastSubUser2
  insecure: true #or:在docker下导入ca证书;
ccr.ccs.tencentyun.com:
  username: $DOCKER_REGISTRY_TENCLOUD_USER
  password: $DOCKER_REGISTRY_TENCLOUD_PASS
dockerhub.qingcloud.com:
  username: $DOCKER_REGISTRY_QCLOUD_USER
  password: $DOCKER_REGISTRY_QCLOUD_PASS
EOF
}
authConf

function doSync(){
  src=$1; dst=$2
  test "$dst" == "$src" && return #skip

  cat > conf/images.yaml<<EOF
# caution!!! overwrite.
# # deb9
# $src/infrastlabs/docker-headless:deb9: $dst/infrastlabs/docker-headless:deb9
# $src/infrastlabs/docker-headless:deb9-full: $dst/infrastlabs/docker-headless:deb9-full
# $src/infrastlabs/docker-headless:deb9-slim: $dst/infrastlabs/docker-headless:deb9-slim
# # ubt2004
# $src/infrastlabs/docker-headless:ubt2004: $dst/infrastlabs/docker-headless:ubt2004
# $src/infrastlabs/docker-headless:ubt2004-sogou: $dst/infrastlabs/docker-headless:ubt2004-sogou
# $src/infrastlabs/docker-headless:ubt2004-cinna: $dst/infrastlabs/docker-headless:ubt2004-cinna
# $src/infrastlabs/docker-headless:ubt2004-cmate: $dst/infrastlabs/docker-headless:ubt2004-cmate
# $src/infrastlabs/docker-headless:ubt2004-gnome: $dst/infrastlabs/docker-headless:ubt2004-gnome
# $src/infrastlabs/docker-headless:ubt2004-plasma: $dst/infrastlabs/docker-headless:ubt2004-plasma

# distros:app
$src/infrastlabs/docker-headless:alpine: $dst/infrastlabs/docker-headless:alpine
$src/infrastlabs/docker-headless:ubuntu: $dst/infrastlabs/docker-headless:ubuntu
$src/infrastlabs/docker-headless:debian: $dst/infrastlabs/docker-headless:debian
$src/infrastlabs/docker-headless:opensuse: $dst/infrastlabs/docker-headless:opensuse
$src/infrastlabs/docker-headless:alpine-3.19: $dst/infrastlabs/docker-headless:alpine-3.19
$src/infrastlabs/docker-headless:ubuntu-20.04: $dst/infrastlabs/docker-headless:ubuntu-20.04
$src/infrastlabs/docker-headless:ubuntu-22.04: $dst/infrastlabs/docker-headless:ubuntu-22.04
$src/infrastlabs/docker-headless:ubuntu-24.04: $dst/infrastlabs/docker-headless:ubuntu-24.04
$src/infrastlabs/docker-headless:debian-10: $dst/infrastlabs/docker-headless:debian-10
$src/infrastlabs/docker-headless:debian-11: $dst/infrastlabs/docker-headless:debian-11
$src/infrastlabs/docker-headless:debian-12: $dst/infrastlabs/docker-headless:debian-12
$src/infrastlabs/docker-headless:opensuse-15.0: $dst/infrastlabs/docker-headless:opensuse-15.0
$src/infrastlabs/docker-headless:opensuse-15.5: $dst/infrastlabs/docker-headless:opensuse-15.5
EOF

  # awk 'BEGIN{print systime()}';
  # gawk 'BEGIN{print systime()}'
  # begin_time="`gawk 'BEGIN{print systime()}'`"
  begin_time="`awk 'BEGIN{print systime()}'`"
  # --arch=amd64 --arch=arm64 #--arch amd64,arm64
  ./image-syncer --proc=3 --force --auth=./conf/auth.yaml --images=./conf/images.yaml --retries=3
  print_time_cost "sync-ali[$src>$dst]" $begin_time >> /tmp/.timecost #tee -a
}

# REPO1=registry-1.docker.io
# REPO1=registry.cn-shenzhen.aliyuncs.com
# REPO2=registry.cn-shenzhen.aliyuncs.com #127.0.0.1:5000
# REPO2=ccr.ccs.tencentyun.com
# REPO2=dockerhub.qingcloud.com
# 
# REPO_HUB REPO_ALI REPO_TEN REPO_QING: from gitac.yml
test ! -z "$REPO_HUB" && doSync $REPO $REPO_HUB &
test ! -z "$REPO_ALI" && doSync $REPO $REPO_ALI &
test ! -z "$REPO_TEN" && doSync $REPO $REPO_TEN &
test ! -z "$REPO_QING" && doSync $REPO $REPO_QING &
wait


exit 0
# vm-xx:/opt/apps/quickstart-imgdeploy/imgpackage/bin # ./image-syncer  -h
# A Fast and Flexible docker registry image synchronization tool implement by Go. 
# 	Complete documentation is available at https://github.com/AliyunContainerService/image-syncer
# Usage:
#   image-syncer [flags]
# Aliases:
#   image-syncer, image-syncer
# Flags:
#       --arch stringArray               architecture list to filter source tags, not works for OCI media
#       --auth string                    auth file path. This flag need to be pair used with --images.
#       --config string                  config file path. This flag is deprecated and will be removed in the future. Please use --auth and --images instead.
#       --force                          force update manifest whether the destination manifest exists
#   -h, --help                           help for image-syncer
#       --images string                  images file path. This flag need to be pair used with --auth
#       --log string                     log file path (default in os.Stderr)
#       --os stringArray                 os list to filter source tags, not works for docker v2 schema1 and OCI media
#       --output-images-format string    success images output format, json or yaml (default "yaml")
#       --output-success-images string   output success images in a new file
#   -p, --proc int                       numbers of working goroutines (default 5)
#   -r, --retries int                    times to retry failed task (default 2)
