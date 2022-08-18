source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

ns=infrastlabs
# cache="--no-cache"
# pull="--pull"

ver=v6 # latest
case "$1" in
hub)
    repoHub=docker.io
    echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
    # SLIM
    img="docker-headless:ubt20-$ver" && echo -e "\n\nimg: $img"
    docker tag $repo/$ns/$img $ns/$img; docker push $ns/$img
    img2=docker-headless:ubt20
    docker tag $repo/$ns/$img $ns/$img2; docker push $ns/$img2
    ;;
*)
    file=sogoupinyin_4.0.1.2800_x86_64.deb
    test -s "$file" || curl -O https://ime.sogouimecdn.com/202208081957/72cdf6131e248391c874cb05d0e8401b/dl/gzindex/1656597217/$file
    img="docker-headless:ubt20-$ver"
    # --cache-from $repo/$ns/$img 
    docker build $cache $pull -t $repo/$ns/$img -f src/Dockerfile . 
    test "false" == "$IMG_PUSH" || docker push $repo/$ns/$img    
    img2=docker-headless:ubt20
    docker tag $repo/$ns/$img $repo/$ns/$img2; 
    test "false" == "$IMG_PUSH" || docker push $repo/$ns/$img2
    ;;
esac
