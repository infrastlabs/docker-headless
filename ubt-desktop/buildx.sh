#!/bin/bash
source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
        
ns=infrastlabs
# cache="--no-cache"
# pull="--pull"
ver=v5 # latest
repo=registry-1.docker.io
case "$1" in
# https://www.linuxmint.com/download_all.php #linuxmint官方暂无arm版？
# cmate)
#     img="docker-headless:cmate"
#     plat="--platform linux/amd64,linux/arm64"
#     docker  buildx build $plat --push -t $repo/$ns/$img -f src/Dockerfile.cmate . 
#     ;;
# cxfce)
#     img="docker-headless:cxfce"
#     plat="--platform linux/amd64,linux/arm64"
#     docker  buildx build $plat --push -t $repo/$ns/$img -f src/Dockerfile.cxfce . 
#     ;;
plas)
    img="docker-headless:plas"
    plat="--platform linux/amd64,linux/arm64"

    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:gnome"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.plasma . 
    ;;
*)
    img="docker-headless:gnome"
    plat="--platform linux/amd64,linux/arm64" #,linux/arm
    # TODO build cache.repo> aliyun;
    # https://github.com/moby/buildkit
    # buildctl build ...\
    #     --output type=image,name=docker.io/username/image,push=true \
    #     --export-cache type=inline \
    #     --import-cache type=registry,ref=docker.io/username/image

    # https://docs.docker.com/engine/reference/commandline/buildx_build/
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:gnome"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.gnome . 
    ;;
esac