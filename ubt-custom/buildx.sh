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
case "$1" in
*)
    repo=registry-1.docker.io
    img="docker-headless:latest-multi"
    plat="--platform linux/amd64,linux/arm64" #,linux/arm
    docker  buildx build $plat --push -t $repo/$ns/$img -f src/Dockerfile . 
    ;;
esac