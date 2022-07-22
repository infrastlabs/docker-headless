source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"

# latest
case "$1" in
compile)
    ver=1.12.0 ## udomain > jaist
    file=tigervnc-${ver}.x86_64.tar.gz
    test -s "$file" || curl -fSL -k -O https://jaist.dl.sourceforge.net/project/tigervnc/stable/${ver}/$file
    # 
    img="docker-headless:mint-compile"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.compile . 
    docker push $repo/$ns/$img
    ;; 

*)
    img="docker-headless:mint"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile . 
    docker push $repo/$ns/$img    
    ;;
esac
