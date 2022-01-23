#!/bin/sh

function auto_select_remote_docker()
{
  DOCKERTIMEOUT=$1
  export SELECTED=nothing
  docker context ls | while read -r ctx;do
    name=$(echo $ctx | awk '{print $1}');
    if [ "${name}" = "NAME" ] ||  [ "${name}" = "default" ]; then
      continue;
    fi
    echo "Checking health of cloudnative build env ${name} ..."
    DOCKER_CONTEXT=${name} timeout -s 9 $DOCKERTIMEOUT docker system info -f '{{ .Name }}';
    if [ $? == "0" ];then
      echo "Selecting ${name} ...."
      export SELECTED=${name};
      docker context use ${name};
      break;
    fi
  done
}

auto_select_remote_docker 8