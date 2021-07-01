
#echo "export DOCKER_REGISTRY_USER_sdsir=xxx" >> /etc/profile
#echo "export DOCKER_REGISTRY_PW_sdsir=xxx" >> /etc/profile

source /etc/profile
export |grep DOCKER_REG

repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"
ver=v2

cmd="$1"
case "$cmd" in
    src)   
        img="docker-headless:compile"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.compile . 
        docker push $repo/$ns/$img
        ;;
    src2)   
        img="docker-headless:compile2"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.compile2 . 
        docker push $repo/$ns/$img
        ;;
    src3) #deb9_xrdp  0.9.16
        img="docker-headless:compile3"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.compile3 . 
        docker push $repo/$ns/$img
        ;;
    deb)    #174.945 MB
        img="docker-headless:deb9-$ver-slim"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.deb . 
        docker push $repo/$ns/$img
        # 
        img="docker-headless:deb10-$ver-slim"
        docker build $cache $pull -t $repo/$ns/$img --build-arg VER_DISTRO=buster -f Dockerfile.deb . 
        docker push $repo/$ns/$img

        # img="docker-headless:deb9"
        # docker build $cache $pull -t $repo/$ns/$img --build-arg APP_LARGER=true -f Dockerfile.deb . 
        # docker push $repo/$ns/$img
        # # 
        # img="docker-headless:deb10"
        # docker build $cache $pull -t $repo/$ns/$img --build-arg APP_LARGER=true --build-arg VER_DISTRO=buster -f Dockerfile.deb . 
        # docker push $repo/$ns/$img
        ;;
    ubt) #178.678 MB
        img="docker-headless:ubt1804-$ver-slim"
        docker build $cache $pull -t $repo/$ns/$img -f Dockerfile.ubt . 
        docker push $repo/$ns/$img
        # 
        img="docker-headless:ubt2004-$ver-slim"
        docker build $cache $pull -t $repo/$ns/$img --build-arg VER_DISTRO=focal -f Dockerfile.ubt . 
        docker push $repo/$ns/$img

        # img="docker-headless:ubt1804"
        # docker build $cache $pull -t $repo/$ns/$img --build-arg APP_LARGER=true -f Dockerfile.ubt . 
        # docker push $repo/$ns/$img
        # # 
        # img="docker-headless:ubt2004"
        # docker build $cache $pull -t $repo/$ns/$img --build-arg APP_LARGER=true --build-arg VER_DISTRO=focal -f Dockerfile.ubt . 
        # docker push $repo/$ns/$img
        ;;
    *)
        echo "please call with one param[compile/deb/ubt]"
        exit 1
        ;;
esac

# docker push $repo/$ns/$img
