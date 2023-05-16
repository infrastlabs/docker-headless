


source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
        
ns=infrastlabs
ver=v51 #base-v5 base-v5-slim
case "$1" in
compile)
    # TigerVNC 1.12.0 |10 Nov 2021
    old=$(pwd); cd src/arm
    # xrdp
    ver="0.9.16"
    file=xrdp-${ver}.tar.gz; test -s $file || curl -k -O -fSL https://github.com/neutrinolabs/xrdp/releases/download/v${ver}/$file
    # tiger
    file=xorg-server-1.20.7.tar.bz2; test -s $file || curl -k -O -fSL https://www.x.org/pub/individual/xserver/$file #6.1M
    file=tigervnc-1.12.0.tar.gz; test -s $file || curl -k -O -fSL https://github.com/TigerVNC/tigervnc/archive/v1.12.0/$file #1.5M
    # curl -O -fsSL https://www.linuxfromscratch.org/patches/blfs/svn/tigervnc-1.12.0-configuration_fixes-1.patch
    cd $old;
    #  
    repo=registry-1.docker.io
    img="docker-headless:core-compile"
    plat="--platform linux/amd64,linux/arm64" #,linux/arm
    # --network=host: docker buildx create --use --name mybuilder2 --buildkitd-flags '--allow-insecure-entitlement network.host'
    docker buildx build $plat --push -t $ns/$img -f src/Dockerfile.compile . 
    ;;

# +slim,base (docker-headless,weskit; use docker-headless's)
slim)
    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com #arm64/amd64可以用,只是cr.console.aliyun.com上无多镜像显示
    img="docker-headless:base-$ver-slim"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:base-$ver-slim"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    
    plat="--platform linux/amd64,linux/arm64,linux/arm" ##linux/arm> linux/arm/v7
    args="--build-arg FULL="
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.base . 
    ;;
base)
    repo=registry-1.docker.io
    img="docker-headless:base-$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:base-$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64,linux/arm"
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.base . 
    ;;   
*)
    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com #支持?
    # repo=172.25.21.60:81 #registry-multiArch
    # img="docker-headless:core"
    img="docker-headless:core" #use parent's

    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:core"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64"
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile . 
    ;;          
esac