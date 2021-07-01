
#echo "export DOCKER_REGISTRY_USER_sdsir=xxx" >> /etc/profile
#echo "export DOCKER_REGISTRY_PW_sdsir=xxx" >> /etc/profile

source /etc/profile
export |grep DOCKER_REG

repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"
ver=v1

cmd="$1"
case "$cmd" in
    deb)    #174.945 MB
        img="docker-headless:xfce-deb9-$ver"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.deb . 
        docker push $repo/$ns/$img
        # 
        img="docker-headless:xfce-deb10-$ver"
        docker build $cache $pull -t $repo/$ns/$img --build-arg VER_DISTRO=buster -f Dockerfile.deb . 
        docker push $repo/$ns/$img

        ;;
    ubt) #178.678 MB
        img="docker-headless:xfce-ubt1804-$ver"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.ubt . 
        docker push $repo/$ns/$img
        # 
        img="docker-headless:xfce-ubt2004-$ver"
        docker build $cache $pull -t $repo/$ns/$img --build-arg VER_DISTRO=focal -f Dockerfile.ubt . 
        docker push $repo/$ns/$img

        # img="docker-headless:ubt1804"
        # docker build $cache $pull -t $repo/$ns/$img --build-arg APP_LARGER=true -f Dockerfile.ubt . 
        # docker push $repo/$ns/$img
        ;;
    *)
        echo "please call with one param[deb/ubt]"
        exit 1
        ;;
esac

# docker push $repo/$ns/$img
