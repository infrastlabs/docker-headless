


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
compile)
    # tigervnc 1.10.1 > 1.12.0 
    # https://udomain.dl.sourceforge.net/project/tigervnc/stable/1.10.1/tigervnc-1.10.1.x86_64.tar.gz
    # vncver=1.12.0 ## udomain > jaist
    # file=tigervnc-${vncver}.x86_64.tar.gz
    # test -s "$file" || curl -fSL -k -O https://jaist.dl.sourceforge.net/project/tigervnc/stable/${ver}/$file
    #
    # TigerVNC 1.12.0 |10 Nov 2021
    old=$(pwd); cd src/arm
    ver="0.9.16"
    file=xrdp-${ver}.tar.gz; test -s $file || curl -k -O -fSL https://github.com/neutrinolabs/xrdp/releases/download/v${ver}/$file
    # tiger
    file=xorg-server-1.20.7.tar.bz2; test -s $file || curl -k -O -fSL https://www.x.org/pub/individual/xserver/$file #6.1M
    file=tigervnc-1.12.0.tar.gz; test -s $file || curl -k -O -fSL https://github.com/TigerVNC/tigervnc/archive/v1.12.0/$file #1.5M
    # curl -O -fsSL https://www.linuxfromscratch.org/patches/blfs/svn/tigervnc-1.12.0-configuration_fixes-1.patch
    cd $old;
    #  
    repo=registry-1.docker.io
    img="docker-headless:core-compile-multi"
    plat="--platform linux/amd64,linux/arm64" #,linux/arm
    docker buildx build $plat --push -t $ns/$img -f src/Dockerfile.compile . 
    ;;
# tiger)
#     repo=registry-1.docker.io
#     img="docker-headless:core-compile-tiger"
#     plat="--platform linux/amd64,linux/arm64,linux/arm"
#     # plat="--platform linux/arm64"
#     docker buildx build $plat --push -t $repo/$ns/$img -f src/arm/arm.Dockerfile.tiger . 
#     ;;     

# +slim,base
slim)
    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com #arm64/amd64可以用,只是cr.console.aliyun.com上无多镜像显示
    img="docker-headless:base-$ver-slim-multi"
    
    # host-21-60:~ # docker buildx inspect mybuilder --bootstrap
    # Platforms: linux/amd64, linux/386, 
    #   linux/arm64, linux/arm/v7, linux/arm/v6
    #   linux/riscv64, linux/ppc64le, linux/s390x, linux/mips64le, linux/mips64, 
    
    # https://blog.csdn.net/tony_vip/article/details/105889734 #苹果{armv6、armv7、armv7s}/{arm64、armv8}
    # https://www.nuomiphp.com/t/612081f7bb90dc74c47ba2eb.html #64bit 指令集, V8 之后开始支持的
    # --platform linux/arm/v7,linux/arm64/v8,linux/amd64
    plat="--platform linux/amd64,linux/arm64,linux/arm" ##linux/arm> linux/arm/v7
    args="--build-arg FULL="
    docker buildx build $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.base . 
    ;;
base)
    repo=registry-1.docker.io
    img="docker-headless:base-$ver-multi"
    plat="--platform linux/amd64,linux/arm64,linux/arm"
    args="--build-arg FULL=/.."
    docker buildx build $plat $args --push -t $repo/$ns/$img -f src/Dockerfile.base . 
    ;;   
core)
    repo=registry-1.docker.io
    img="docker-headless:core-multi"
    plat="--platform linux/amd64,linux/arm64"
    docker buildx build $plat $args --push -t $repo/$ns/$img -f src/Dockerfile . 
    ;;          
*)
    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com #支持?
    # repo=172.25.21.60:81 #registry-multiArch

    img="docker-headless:core-$ver-arm"
    # plat="--platform linux/amd64,linux/arm64" #,linux/arm
    plat="--platform linux/arm64" #spe-debug
    # docker build $cache $pull -t $repo/$ns/$img --build-arg FULL=/.. -f src/arm/arm.Dockerfile . 
    # --cache-from $repo/$ns/$img 
    # --build-arg FULL=/..
    docker  buildx build $plat --push -t $repo/$ns/$img -f src/arm/arm.Dockerfile . 
    docker push $repo/$ns/$img    
    ;;
esac