
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


img="docker-headless:chromium"
docker build $cache $pull -t $ns/$img -f Dockerfile.chromium . 
docker push $ns/$img

# img="docker-headless:firefox"
# docker build $cache $pull -t $ns/$img -f Dockerfile.firefox . 
# docker push $ns/$img
