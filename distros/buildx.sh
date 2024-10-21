
source /etc/profile
export |grep DOCKER_REG |grep -Ev "PASS|PW"
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo
repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub

function print_time_cost(){
    local item_name=$1
    local begin_time=$2
	gawk 'BEGIN{
		print "['$item_name']本操作从" strftime("%Y年%m月%d日%H:%M:%S",'$begin_time'),"开始 ,",
		strftime("到%Y年%m月%d日%H:%M:%S",systime()) ,"结束,",
		" 共历时" systime()-'$begin_time' "秒";
	}'
}
function doBuildx(){
    local tag=$1
    local dockerfile=$2
    local latest=$3

    repo=registry-1.docker.io
    test ! -z "$REPO" && repo=$REPO #switch @gitac
    img="docker-headless:$tag"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-headless-cache:$tag"
    
    compile="alpine-compile"; flux=rootfs #fluxbox
    plat="$PLAT0" #,linux/arm
    # plat="--platform linux/amd64" #dbg
    test "$plat" != "$PLAT0" && compile="${compile}-dbg"
    test "$plat" != "$PLAT0" && img="${img}-dbg"
    test "$plat" != "$PLAT0" && cimg="${cimg}-dbg"
    test "fedora" == "$dist" && plat="--platform linux/amd64,linux/arm64" # alma/fedora:无armv7
    test "opensuse|15.0" == "$dist|$dver" && plat="--platform linux/amd64,linux/arm64" #opensuse_15.0 none_armv7
    # 3.0> 3.1: none_3.0_img@dockerhub
    test "alpine|3.1" == "$dist|$dver" && plat="--platform linux/amd64" #none: arm64,armv7
    test "alpine|3.2" == "$dist|$dver" && plat="--platform linux/amd64" #none: arm64,armv7
    test "alpine|3.5" == "$dist|$dver" && plat="--platform linux/amd64" #alpine_3.5: x64,arm64 ##,linux/arm64 (apk.REPO有arm64,hub.img无arm64的)
    echo "[$dist|$dver] >>> plat=$plat"

    args="""
    --provenance=false 
    --build-arg COMPILE_IMG=$compile
    --build-arg REPO=$repo/
    --build-arg TYPE=$type
    --build-arg VER=$dver
    """
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f $dockerfile . 

    ##[latest]###############
    if [ "latest" == "$latest" ]; then
      tag=${tag%%-$dver}; echo "latest-tag: $tag"
      img="docker-headless:$tag"
      docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f $dockerfile . 
    fi
}

ns=infrastlabs
ver=v51 #base-v5 base-v5-slim
type=$1; dist=$2
dver=$3; latest=$4; test -z "$dver" && dver=errVer
tag=$dist-$dver # tag=$type-$dist-$dver

# PLAT0
PLAT0="--platform linux/amd64,linux/arm64,linux/arm"
test "$type" == "app" && PLAT0="--platform linux/amd64,linux/arm64" #app:none-armv7

# :> /tmp/.timecost #only clear @gitac
begin_time="`gawk 'BEGIN{print systime()}'`"; echo "[$tag]" $begin_time >> /tmp/.timecost
case "$dist" in
alpine|ubuntu|debian|opensuse)
    doBuildx "$tag" src/Dockerfile.*-$dist $latest #core,app
    ;;  
*)
    doBuildx "$tag" src/oth/Dockerfile.*-$dist $latest #core only
    ;;          
esac
print_time_cost "$tag" $begin_time >> /tmp/.timecost #tee -a

exit 0
##[call:@gitac]#########################
# core
bash buildx.sh core alpine 3.19 latest
bash buildx.sh core ubuntu 20.04 
bash buildx.sh core ubuntu 22.04 latest
# oth
bash buildx.sh core debian 12 latest
bash buildx.sh core fedora 39 latest
# app
bash buildx.sh app alpine 3.19 latest
bash buildx.sh app ubuntu 20.04 
bash buildx.sh app ubuntu 22.04 latest
