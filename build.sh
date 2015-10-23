#! /usr/bin/env bash
# Build images.

# Set values
pkg=${BASH_SOURCE##*/}

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

machine-init() {
  # Build test VM if needed
  DOCKER_MACHINE_NAME=${DOCKER_MACHINE_NAME:-"citest"} ; export DOCKER_MACHINE_NAME
  DOCKER_MACHINE_HDD=${DOCKER_MACHINE_HDD:-"10240"}

  if [ -z "$DOCKER_IMAGE" ]; then
    echo "${red}[CI] DOCKER_IMAGE must be set in the environment or via the command line flag -i=[NAME] or --image=[NAME]"
    echo "Exiting.${reset}"
    return 1
  else
    DOCKER_IMAGE=${DOCKER_IMAGE} ; export DOCKER_IMAGE
  fi
  docker-machine ls -q | grep "${DOCKER_MACHINE_NAME}" &>/dev/null
  if [ $? -ne 0 ]; then
    if [ ! -z $create_machine ]; then
      echo "${red}[CI] Docker host (${DOCKER_MACHINE_NAME}) does not exist and auto-creation disabled. Exiting.${reset}"
      return 2
    fi
    echo "${yellow}[CI] Creating Docker host (${DOCKER_MACHINE_NAME})...${reset}"
    docker-machine create --driver virtualbox ${DOCKER_MACHINE_NAME} --virtualbox-disk-size ${DOCKER_MACHINE_HDD}
  else
    docker-machine ls | grep ${DOCKER_MACHINE_NAME} | grep Running &>/dev/null
    if [ $? -ne 0 ]; then
      echo "${green}[CI] Starting Docker host (${DOCKER_MACHINE_NAME})...${reset}"
      docker-machine start ${DOCKER_MACHINE_NAME}
    fi
  fi
  eval "$(docker-machine env ${DOCKER_MACHINE_NAME})"
}

usage() {
cat <<EOM

$pkg

Create test builds. If any invalid options are specified the build process is run.

Usage: $pkg [OPTIONS]

Options:
  -h,--help               Output help (this message)
  -nc,--no-create         Do not create Docker VM host
  -m=,--machine=[NAME]    Use specified name for Docker VM host (defaults to 'citest')
  -i=,--image=[NAME]      (mandatory) Use specified name for Docker image (defaults to value of environment variable DOCKER_IMAGE)
  -s=,--size=[MB]         Use specified value in MB for Docker VM HDD (defaults to 10240)

EOM
}

# Process command line
for arg in "$@"; do
  if test -n "$prev_arg"; then
    eval "$prev_arg=\$arg"
    prev_arg=
  fi

  case "$arg" in
      -*=*) optarg=`echo "$arg" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
      *) optarg= ;;
  esac

  case $arg in
    -h | --help)
      usage && return 0
      ;;
    -nc | --no-create)
      create_machine=0
      ;;
    -m=* | --machine=*)
      DOCKER_MACHINE_NAME="$optarg"
      ;;
    -i=* | --image=*)
      DOCKER_IMAGE="$optarg"
      ;;
    -s=* | --size=*)
      DOCKER_MACHINE_HDD="$optarg"
      ;;
    -*)
      echo "${red}[CI] Unknown option $arg, exiting...${reset}" && return 1
      ;;
    *)
      echo "${red}[CI] Unknown option or missing argument for $arg, exiting.${reset}"
      usage
      return 1
      ;;
  esac
done

machine-init
