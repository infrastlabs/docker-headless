


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
    repo=registry-1.docker.io
    img="docker-headless:deb12-compile"
    plat="--platform linux/amd64,linux/arm64,linux/arm" #,linux/arm
    # plat="--platform linux/amd64"
    args="--provenance=false"
    # --network=host: docker buildx create --use --name mybuilder2 --buildkitd-flags '--allow-insecure-entitlement network.host'
    docker buildx build $plat $args --push -t $ns/$img -f src/Dockerfile.compile . 
    ;;
compile2)
    # TigerVNC 1.12.0 |10 Nov 2021
    old=$(pwd); cd src/arm
        # xrdp
        ver=0.9.23 #0.9.16 (0.9.23.1 @23.10.14)
        file=xrdp-${ver}.tar.gz; test -s $file || curl -k -O -fSL https://ghproxy.com/https://github.com/neutrinolabs/xrdp/releases/download/v${ver}/$file
        # tiger
        #1.20.7.tar.bz2 >21.1.7.tar.gz;    1.12.0> 1.13.1
        ver=1.12.0 #1.13.1
        file=xorg-server-1.20.7.tar.bz2; test -s $file || curl -k -O -fSL https://www.x.org/pub/individual/xserver/$file #6.1M
        file=tigervnc-${ver}.tar.gz; test -s $file || curl -k -O -fSL https://ghproxy.com/https://github.com/TigerVNC/tigervnc/archive/v${ver}/$file #1.5M
        # curl -O -fsSL https://www.linuxfromscratch.org/patches/blfs/svn/tigervnc-1.12.0-configuration_fixes-1.patch
    cd $old;
    #  
    repo=registry-1.docker.io
    img="docker-headless:deb12-compile2"
    # cache ##support multi-stage? (无用)
    # ali="registry.cn-shenzhen.aliyuncs.com"
    # cimg="docker-headless-cache:deb12-compile2"
    # cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64,linux/arm" #,linux/arm
    plat="--platform linux/amd64"
    args="--provenance=false"
    args="""
    --provenance=false 
    --build-arg COMPILE_XRDP=yes
    --build-arg COMPILE_PULSE=yes
    --build-arg COMPILE_TIGER=yes
    """
    # --network=host: docker buildx create --use --name mybuilder2 --buildkitd-flags '--allow-insecure-entitlement network.host'
    docker buildx build $cache $plat $args --push -t $ns/$img -f src/Dockerfile.compile2 . 
    ;;

# +slim,base (docker-headless,weskit; use docker-headless's)
slim)
    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com #arm64/amd64可以用,只是cr.console.aliyun.com上无多镜像显示
    img="docker-headless:deb12-base-${ver}slim"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:deb12-base-${ver}slim"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    
    plat="--platform linux/amd64,linux/arm64,linux/arm" ##linux/arm> linux/arm/v7
    plat="--platform linux/amd64"
    args="--provenance=false --build-arg FULL="
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.base . 
    ;;
base)
    repo=registry-1.docker.io
    img="docker-headless:deb12-base-$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:deb12-base-$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64,linux/arm"
    plat="--platform linux/amd64"
    args="--provenance=false --build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.base . 
    ;;   
cust)
    repo=registry-1.docker.io
    img="docker-headless:deb12"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:deb12"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64,linux/arm"
    plat="--platform linux/amd64"
    args="--provenance=false --build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.custom . 
    ;;       
*)
    repo=registry-1.docker.io
    repo=registry.cn-shenzhen.aliyuncs.com #@ali's repo
    # repo=172.25.21.60:81 #registry-multiArch
    # img="docker-headless:core"
    img="docker-headless:deb12-core" #use parent's

    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:deb12-core"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64"
    plat="--platform linux/amd64"
    args="--provenance=false"
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f src/Dockerfile . 
    ;;          
esac