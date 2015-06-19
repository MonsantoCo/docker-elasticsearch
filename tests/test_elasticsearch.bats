#!/usr/bin/env bats

setup() {
  # Setup environment
  host=$(echo $DOCKER_HOST|cut -d":" -f2|sed -e 's/\/\///')
}

teardown () {
  # Cleanup
  docker stop ${IMAGE} >/dev/null
  docker rm ${IMAGE} >/dev/null
}

@test "Confirm installed ES version" {
  run docker run --name ${IMAGE} ${IMAGE}:${TAG} /opt/elasticsearch/bin/elasticsearch -v
  [[ $output =~ "Version: ${TAG}" ]]
}

@test "Confirm JDK version 1.8.0_45-b14" {
  run docker run --name ${IMAGE} ${IMAGE}:${TAG} /usr/local/java/jdk/bin/java -version
  [[ ${lines[1]} =~ "1.8.0_45-b14" ]]
}

@test "Confirm ES is available" {
  run docker run -d --name ${IMAGE} -P ${IMAGE}:${TAG}
  port=$(docker port ${IMAGE} | grep 9200 | cut -d":" -f2)
  sleep 10
  curl --retry 10 --retry-delay 5 --location --silent http://${host}:${port}
  [ $status -eq 0 ]
}
