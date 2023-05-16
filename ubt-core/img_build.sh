source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"

ver=v51 # latest
case "$1" in
hub)
    repoHub=docker.io
    echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
    # SLIM
    img="docker-headless:core" && echo -e "\n\nimg: $img"
    docker tag $repo/$ns/$img $ns/$img
    # docker push $ns/$img
    ;;
slim)
    img="docker-headless:base-$ver-slim"
    args="--build-arg FULL="
    docker build $cache $pull $args -t $repo/$ns/$img -f src/Dockerfile.base . 
    docker push $repo/$ns/$img   
    ;;
base)
    img="docker-headless:base-$ver"
    args="--build-arg FULL=/.."
    docker build $cache $pull $args -t $repo/$ns/$img -f src/Dockerfile.base . 
    docker push $repo/$ns/$img   
    ;;    
*) #core
    img="docker-headless:core"
    # --cache-from $repo/$ns/$img 
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile . 
    docker push $repo/$ns/$img   
    ;;
esac
