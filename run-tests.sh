#! /usr/bin/env bash
# Run testing.

# Set values
pkg=${BASH_SOURCE##*/}
status=0

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

VERSIONS=${VERSIONS:-"$@"}
if [ ! -z "$VERSIONS" ]; then
  versions=( "$VERSIONS" )
else
  versions=( ?.?.? )
fi
versions=( "${versions[@]%/}" )
versions=( $(printf '%s\n' "${versions[@]}"|sort -V) )

if [ -z "$DOCKER_IMAGE" ]; then
  echo "${red}[CI] Missing mandatory environment variable DOCKER_IMAGE${reset}"
  exit 1
fi

# Set Docker hostname/ip
if [ ! -z $DOCKER_HOST ]; then
  export DOCKER_HOST_IP=$(docker-machine ip ${DOCKER_MACHINE_NAME})
else
  export DOCKER_HOST_IP=${HOSTNAME}
fi
for VERSION in "${versions[@]}"; do
  echo "${green}[CI] -----------------------------------------------"
  echo "${green}[CI] Running tests for: ${DOCKER_IMAGE}:${VERSION}${reset}"
  export VERSION
  bats tests
  [ $? -ne 0 ] && status=1
done

if [ $status -ne 0 ]; then
  echo "${yellow}[CI] ${DOCKER_IMAGE} tests completed unsuccessfully, check results.${reset}"
else
  echo "${green}[CI] ${DOCKER_IMAGE} tests completed successfully.${reset}"
fi
