source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"

# latest
case "$1" in
cinna)
    img="docker-headless:cinna"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.cinna . 
    docker push $repo/$ns/$img
    ;;   
cmate)
    img="docker-headless:cmate"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.cmate . 
    docker push $repo/$ns/$img
    ;;       
cxfce)
    img="docker-headless:cxfce"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.cxfce . 
    docker push $repo/$ns/$img
    ;;  
gnome)
    img="docker-headless:gnome"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.gnome . 
    docker push $repo/$ns/$img 
    ;;     
plas)
    img="docker-headless:plas"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.plasma . 
    docker push $repo/$ns/$img
    ;;      

# v1.5 ex
neon)
    img="docker-headless:neon"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.neon . 
    docker push $repo/$ns/$img
    ;;   
elm)
    img="docker-headless:elm"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.elm . 
    docker push $repo/$ns/$img
    ;;   
*)
    img="docker-headless:flux"
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.flux . 
    docker push $repo/$ns/$img
    ;;
esac
