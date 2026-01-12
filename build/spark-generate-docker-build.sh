#!/bin/bash -e

IS_M2RELEASEBUILD=false
POM_VERSION="1.0.0"

MODULE="sequence-to-id"

IMAGE=docker.gbif.org/${MODULE}:${POM_VERSION}
IMAGE_LATEST=docker.gbif.org/${MODULE}:latest

echo "Building Docker image: ${IMAGE}"
docker build -f ./docker/Dockerfile . --build-arg JAR_FILE=${MODULE}-${POM_VERSION}.jar -t ${IMAGE}

echo "Pushing Docker image to the repository"
docker push ${IMAGE}

if [[ $IS_M2RELEASEBUILD = true ]]; then
  echo "Updated latest tag pointing to the newly released ${IMAGE}"
  docker tag ${IMAGE} ${IMAGE_LATEST}
  docker push ${IMAGE_LATEST}
fi

echo "Removing local Docker image: ${IMAGE}"
docker rmi -f ${IMAGE}

if [[ $IS_M2RELEASEBUILD = true ]]; then
  echo "Removing local Docker image with latest tag: ${IMAGE_LATEST}"
  docker rmi -f ${IMAGE_LATEST}
fi
