source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"

ver=v5 # only: base-v5, base-v5-slim
case "$1" in
compile)
    img="docker-headless:core-compile"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.compile . 
    docker push $repo/$ns/$img
    ;; 
# tiger)
#     img="docker-headless:mint-compile-tiger"
#     docker build $cache $pull -t $repo/$ns/$img -f src/arm.Dockerfile.tiger . 
#     docker push $repo/$ns/$img
#     ;;    
# tiger21)
#     img="docker-headless:mint-compile-tiger-v21"
#     docker build $cache $pull -t $repo/$ns/$img -f src/arm.Dockerfile.tiger-v21 . 
#     docker push $repo/$ns/$img
#     ;;     
hub)
    repoHub=docker.io
    echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
    # SLIM
    img="docker-headless:core" && echo -e "\n\nimg: $img"
    docker tag $repo/$ns/$img $ns/$img; docker push $ns/$img
    # 
    img="docker-headless:base-$ver" && echo -e "\n\nimg: $img"
    docker tag $repo/$ns/$img $ns/$img; docker push $ns/$img
    img="docker-headless:base-$ver-slim" && echo -e "\n\nimg: $img"
    docker tag $repo/$ns/$img $ns/$img; docker push $ns/$img
    ;;    
slim)
    img="docker-headless:base-$ver-slim"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.base . 
    docker push $repo/$ns/$img    
    ;;
base)
    img="docker-headless:base-$ver"
    # --cache-from $repo/$ns/$img 
    docker build $cache $pull -t $repo/$ns/$img --build-arg FULL=/.. -f src/Dockerfile.base . 
    docker push $repo/$ns/$img 
    ;;
*)
    vncVer=1.10.1 #1.12.0 ## udomain > jaist
    file=tigervnc-${vncVer}.x86_64.tar.gz
    test -s "$file" || curl -fSL -k -O https://jaist.dl.sourceforge.net/project/tigervnc/stable/${vncVer}/$file
    # 
    img="docker-headless:core" && echo -e "\n\nimg: $img"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile . 
    # docker push $repo/$ns/$img    

    # 关联子项: ubt20, gnome
    export IMG_PUSH=false
    cd ../deb10; sh img_build.sh
    cd ../ubt-custom; sh img_build.sh
    cd ../ubt-desktop; sh img_build.sh
    ;;
esac
