

- https://gitee.com/infrastlabs/fk-docker-baseimage-gui/blob/master/.github/workflows/build-baseimage.yml


```yml
    strategy:
      fail-fast: false
      matrix:
        info:
          - '{ "tag_prefix": "alpine-3.14",  "baseimage": "jlesage/baseimage:alpine-3.14-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.15",  "baseimage": "jlesage/baseimage:alpine-3.15-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.16",  "baseimage": "jlesage/baseimage:alpine-3.16-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.17",  "baseimage": "jlesage/baseimage:alpine-3.17-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "alpine-3.18",  "baseimage": "jlesage/baseimage:alpine-3.18-v3.4.7",  "platforms": "linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "debian-10",    "baseimage": "jlesage/baseimage:debian-10-v3.4.7",    "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "debian-11",    "baseimage": "jlesage/baseimage:debian-11-v3.4.7",    "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-16.04", "baseimage": "jlesage/baseimage:ubuntu-16.04-v3.4.7", "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-18.04", "baseimage": "jlesage/baseimage:ubuntu-18.04-v3.4.7", "platforms": "linux/amd64,linux/386,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-20.04", "baseimage": "jlesage/baseimage:ubuntu-20.04-v3.4.7", "platforms": "linux/amd64,linux/arm/v7,linux/arm64/v8" }'
          - '{ "tag_prefix": "ubuntu-22.04", "baseimage": "jlesage/baseimage:ubuntu-22.04-v3.4.7", "platforms": "linux/amd64,linux/arm/v7,linux/arm64/v8" }'


```