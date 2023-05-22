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
case "$1" in
sogou)
    # 403ERR: 手动下载放到该目录下缓存。# https://shurufa.sogou.com/linux
    # # https://ime.sogouimecdn.com/202210102001/e904b2fa390e7f15a685277b381b7c48/dl/gzindex/1656597217/sogoupinyin_4.0.1.2800_x86_64.deb
    # # https://ime.sogouimecdn.com/202210102001/fb5863bbce2217fbf4e4c78f9f5a5e16/dl/gzindex/1656597217/sogoupinyin_4.0.1.2800_arm64.deb
    
    # TODO: dockerImageDownLayer's outout here.
    # file=sogoupinyin_4.0.1.2800_arm64.deb
    # test -s "$file" || curl -k -O -fSL https://ime.sogouimecdn.com/202210102001/fb5863bbce2217fbf4e4c78f9f5a5e16/dl/gzindex/1656597217/$file
    # 
    img="docker-headless:sogou"
    plat="--platform linux/amd64,linux/arm64"
    cimg="docker-headless-cache:sogou"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile.sogou . 
    ;;  
*)
    img="docker-headless:latest"
    plat="--platform linux/amd64,linux/arm64" #,linux/arm
    cimg="docker-headless-cache:latest"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker  buildx build $cache $plat --push -t $repo/$ns/$img -f src/Dockerfile . 
    docker  buildx build $cache $plat --push -t $ali/$ns/$img -f src/Dockerfile . 
    ;;
esac