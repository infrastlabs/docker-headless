source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"

ver=v3 # latest
case "$1" in
compile)
    vncver=1.12.0 ## udomain > jaist
    file=tigervnc-${vncver}.x86_64.tar.gz
    test -s "$file" || curl -fSL -k -O https://jaist.dl.sourceforge.net/project/tigervnc/stable/${ver}/$file
    # 
    img="docker-headless:mint-compile"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.compile . 
    docker push $repo/$ns/$img
    ;; 
tiger)
    img="docker-headless:mint-compile-tiger"
    docker build $cache $pull -t $repo/$ns/$img -f src/arm.Dockerfile.tiger . 
    docker push $repo/$ns/$img
    ;;    
tiger21)
    img="docker-headless:mint-compile-tiger-v21"
    docker build $cache $pull -t $repo/$ns/$img -f src/arm.Dockerfile.tiger-v21 . 
    docker push $repo/$ns/$img
    ;;     
slim)
    img="docker-headless:ubt-$ver-slim"
    # --cache-from $repo/$ns/$img 
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile . 
    docker push $repo/$ns/$img    
    ;;
*)
    img="docker-headless:ubt-$ver"
    # --cache-from $repo/$ns/$img 
    docker build $cache $pull -t $repo/$ns/$img --build-arg FULL=/.. -f src/Dockerfile . 
    docker push $repo/$ns/$img    
    ;;
esac
