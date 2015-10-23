#! /usr/bin/env bats

@test "Confirm installed ES version" {
  run docker run --rm --name ${DOCKER_IMAGE} ${DOCKER_IMAGE}:${VERSION} /opt/elasticsearch/bin/elasticsearch -v
  [[ $output =~ "Version: ${VERSION}" ]]
}

@test "Confirm ES is available" {
  run docker run -d --name ${DOCKER_IMAGE} -P ${DOCKER_IMAGE}:${VERSION}
  port=$(docker inspect -f '{{(index (index .NetworkSettings.Ports "9200/tcp") 0).HostPort}}' ${DOCKER_IMAGE})
  url="http://${DOCKER_HOST_IP}:${port}"
  sleep 10
  curl --retry 10 --retry-delay 5 --location --silent $url
  [ $status -eq 0 ]
  docker stop ${DOCKER_IMAGE} >/dev/null
  docker rm -f ${DOCKER_IMAGE} >/dev/null
}
