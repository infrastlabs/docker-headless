
#echo "export DOCKER_REGISTRY_USER_sdsir=xxx" >> /etc/profile
#echo "export DOCKER_REGISTRY_PW_sdsir=xxx" >> /etc/profile

source /etc/profile
export |grep DOCKER_REG

repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"
ver=box06 #02: +full; 04: bins;

cmd="$1"
case "$cmd" in
    src)   
        img="docker-headless:compile-v1"
        docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile.compile . 
        docker push $repo/$ns/$img
        ;;
    *)
        # SLIM
        img="docker-headless:$ver-slim"
        docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile .
        docker push $repo/$ns/$img

        # AUDIO=true
        img="docker-headless:$ver"
        docker build $cache $pull -t $repo/$ns/$img  --build-arg AUDIO=true -f src/Dockerfile .
        docker push $repo/$ns/$img
        docker tag $repo/$ns/$img $repo/$ns/docker-headless:latest #latest
        docker push $repo/$ns/docker-headless:latest

        # FULL=/.. #for COPY
        img="docker-headless:$ver-full"
        docker build $cache $pull -t $repo/$ns/$img  --build-arg AUDIO=true --build-arg FULL=/.. -f src/Dockerfile .
        docker push $repo/$ns/$img
        ;;
esac

