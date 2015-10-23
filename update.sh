#! /usr/bin/env bash
# Add files for each version.

set -e

# Set values
pkg=${0##*/}

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

# Script directory
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

VERSIONS=${VERSIONS:-"$@"}
if [ ! -z "$VERSIONS" ]; then
  versions=( "$VERSIONS" )
else
  versions=( ?.?.? )
fi
versions=( "${versions[@]%/}" )
versions=( $(printf '%s\n' "${versions[@]}"|sort -V) )

for version in "${versions[@]}"; do
  dlVersion=$(echo $version | tr '.' '-')
  if $(curl -fsSL https://www.elastic.co/downloads/past-releases/elasticsearch-$dlVersion &>/dev/null); then
    echo "${yellow}Updating version: ${version}${reset}"
    cp -R src $version/
    sed -e 's/%%VERSION%%/'"$version"'/' < Dockerfile.tpl > "$version/Dockerfile"
  else
    echo "${red}WARNING: Unable to find ${dlVersion} for ${version}${reset}"
  fi
done
echo "${green}Complete${reset}"
