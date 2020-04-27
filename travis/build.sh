#!/usr/bin/env bash

# Login into docker
docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD

architectures="arm arm64 amd64"
images=""
platforms=""

for arch in $architectures
do
# Build for all architectures and push manifest
  platforms="linux/$arch,$platforms"
done

platforms=${platforms::-1}

# Push multi-arch image
buildctl build \
      --frontend dockerfile.v0 \
      --local dockerfile=. \
      --local context=. \
      --exporter image \
      --output type=image,opt=name=hub.docker.com/$DOCKER_REPO:test-build,push=true \
      --frontend-opt platform=$platforms \
      --frontend-opt filename=./Dockerfile.cross

# Push image for every arch with arch prefix in tag
for arch in $architectures
do
# Build for all architectures and push manifest
  buildctl build \
      --frontend dockerfile.v0 \
      --local dockerfile=. \
      --local context=. \
      --output type=image,opt=name=docker.io/$DOCKER_REPO:test-build-$arch,push=true \
      --frontend-opt platform=linux/$arch \
      --frontend-opt filename=./Dockerfile.cross &
done

wait

docker pull $DOCKER_REPO:test-build-arm
docker tag $DOCKER_REPO:test-build-arm zeerorg/cron-connector:test-build-armhf
docker push $DOCKER_REPO:test-build-armhf
