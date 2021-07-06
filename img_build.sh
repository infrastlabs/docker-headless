
#echo "export DOCKER_REGISTRY_USER_sdsir=xxx" >> /etc/profile
#echo "export DOCKER_REGISTRY_PW_sdsir=xxx" >> /etc/profile

source /etc/profile
export |grep DOCKER_REG

repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"
ver=box02 #02: +full

img="docker-headless:$ver-slim"
docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile .
docker push $repo/$ns/$img

img="docker-headless:$ver"
docker build $cache $pull -t $repo/$ns/$img  --build-arg SLIM=false -f src/Dockerfile .
docker push $repo/$ns/$img

img="docker-headless:$ver-full"
docker build $cache $pull -t $repo/$ns/$img  --build-arg SLIM=false --build-arg FULL=true -f src/Dockerfile .
docker push $repo/$ns/$img