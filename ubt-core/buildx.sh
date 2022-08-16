


source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
        
ns=infrastlabs
# cache="--no-cache"
# pull="--pull"
ver=v3 # latest
case "$1" in
compile)
    # vncver=1.12.0 ## udomain > jaist
    # file=tigervnc-${vncver}.x86_64.tar.gz
    # test -s "$file" || curl -fSL -k -O https://jaist.dl.sourceforge.net/project/tigervnc/stable/${ver}/$file
    # 
    img="docker-headless:mint-compile-arm"
    # --platform linux/amd64,linux/arm64
    # repo=registry-1.docker.io
    # plat="--platform linux/arm64"
    plat="--platform linux/amd64,linux/arm64"
    # multi:  docker buildx create --use mybuilder; moby/buildkit:buildx-stable-1
    # docker buildx build --platform linux/amd64,linux/arm64 --push -t $ns/$img -f src/arm.Dockerfile.compile.t1 . 
    docker buildx build $plat --push -t $ns/$img -f src/arm.Dockerfile.compile . 
    # docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.compile . 
    # docker push $repo/$ns/$img
    ;;
tiger)
    repo=registry-1.docker.io
    img="docker-headless:mint-compile-tiger"
    plat="--platform linux/amd64,linux/arm64"
    docker buildx build $plat --push -t $repo/$ns/$img -f src/arm.Dockerfile.tiger . 
    # docker push $repo/$ns/$img
    ;;       
*)
    repo=registry-1.docker.io
    img="docker-headless:ubt-$ver-arm"
    # --cache-from $repo/$ns/$img 
    plat="--platform linux/amd64,linux/arm64"
    # docker build $cache $pull -t $repo/$ns/$img --build-arg FULL=/.. -f src/arm.Dockerfile . 
    # --build-arg FULL=/..
    docker  buildx build $plat --push -t $repo/$ns/$img -f src/arm.Dockerfile . 
    docker push $repo/$ns/$img    
    ;;
esac