#!/bin/bash
source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub

ali="registry.cn-shenzhen.aliyuncs.com"
repo="registry-1.docker.io"
ns=infrastlabs
repo=registry-1.docker.io
case "$1" in
# https://www.linuxmint.com/download_all.php #linuxmint官方暂无arm版？
cinna)
    img="docker-headless:cinna"
    plat="--platform linux/amd64" #,linux/arm64
    cimg="docker-headless-cache:cinna"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.cinna . 
    ;;
cmate)
    img="docker-headless:cmate"
    plat="--platform linux/amd64" #,linux/arm64
    cimg="docker-headless-cache:cmate"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.cmate . 
    ;;
cxfce)
    img="docker-headless:cxfce"
    plat="--platform linux/amd64" #,linux/arm64
    cimg="docker-headless-cache:cxfce"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.cxfce . 
    ;;
plasma)
    img="docker-headless:plasma"
    plat="--platform linux/amd64,linux/arm64"
    cimg="docker-headless-cache:plas"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.plasma . 
    ;;
*)
    img="docker-headless:gnome"
    plat="--platform linux/amd64,linux/arm64" #,linux/arm

    # https://docs.docker.com/engine/reference/commandline/buildx_build/
    cimg="docker-headless-cache:gnome"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.gnome . 
    ;;
esac