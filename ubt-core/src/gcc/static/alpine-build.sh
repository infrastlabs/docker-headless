
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub

ns=infrastlabs
tag=compile-alpine-3.15-xx
img=$ns/docker-headless:$tag
# BUILDPLATFORM=$1; test -z "$BUILDPLATFORM" && BUILDPLATFORM=linux/amd64
BUILDPLATFORM=linux/amd64
BUILDPLATFORM=linux/arm64
BUILDPLATFORM=linux/arm

repo=$1
if [ "" != "$repo" ]; then
  cat Dockerfile.xx > Dockerfile.xx.hub
  sed -i "s^registry.cn-shenzhen.aliyuncs.com/infrasync/alpine^alpine^g" Dockerfile.xx.hub
  sed -i "s^registry.cn-shenzhen.aliyuncs.com/infrasync/tonistiigi-xx^tonistiigi/xx^g" Dockerfile.xx.hub
  sed -i "s^ARG BUILDPLATFORM=linux/amd64^ARG BUILDPLATFORM^g" Dockerfile.xx.hub
  dockerfile=Dockerfile.xx.hub
else
  dockerfile=Dockerfile.xx
fi

# buildimg
# docker build -t $img -f $dockerfile . #xx
# buildx-with-cache
  # cache
  ali="registry.cn-shenzhen.aliyuncs.com"
  cimg="docker-headless-cache:$tag"
  cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
  # 
  plat="--platform linux/amd64,linux/arm64,linux/arm"
  # plat="--platform linux/arm"
  docker buildx build $cache $plat $args --push -t $img -f $dockerfile . 

# exit 0 
# it="-it"
function buildOne(){
docker run $it --rm --privileged --platform=$BUILDPLATFORM  \
  -v $(pwd):/mnt \
  -v $(pwd)/_build:/build \
  -v $(pwd)/_tmp:/tmp \
  $img sh -c "cd /mnt; sh dfile.sh"

# view,validate
du -sh rootfs
find rootfs |sort #|grep -v xkb
./rootfs/usr/bin/Xvnc -version
ls -lhaS
}

# TODO loop: PLAT> buildOne
#  rootfs_plat? TODO:multiPlat可并行
# ./Dockerfile: err docker-1806/1903--alpine--make--noPermition
buildOne

# +Dockerfile_out
dockerfile=Dockerfile.out
cat > $dockerfile <<EOF
FROM alpine:3.15
RUN export domain="mirrors.ustc.edu.cn"; \
  echo "http://\$domain/alpine/v3.15/main" > /etc/apk/repositories; \
  echo "http://\$domain/alpine/v3.15/community" >> /etc/apk/repositories
ADD ./rootfs /rootfs
EOF

mkdir -p rootfs #test
img=$ns/docker-headless:compile-alpine-3.15-xx-rootfs-tiger
plat="--platform linux/amd64,linux/arm64,linux/arm"
plat="--platform linux/arm"
docker buildx build $cache $plat $args --push -t $img -f $dockerfile . 
