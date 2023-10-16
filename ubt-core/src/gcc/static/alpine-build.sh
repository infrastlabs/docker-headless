

img=registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15-xx
docker build -t $img -f Dockerfile.xx . #xx

# ./Dockerfile: err docker-1806/1903--alpine--make--noPermition
docker run -it --rm --privileged \
  -v $(pwd):/mnt \
  -v $(pwd)/_build:/build \
  -v $(pwd)/_tmp:/tmp \
  $img sh -c "cd /mnt; sh dfile.sh"

