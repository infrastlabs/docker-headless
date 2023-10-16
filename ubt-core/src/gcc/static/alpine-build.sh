

img=registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.15
docker run -it --rm --privileged -v $(pwd):/mnt $img sh -c "cd /mnt; sh dfile.sh"

