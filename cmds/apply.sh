#!/usr/bin/env bash

source ${kt_project_path}/script/constants.sh


function f_kubectl_apply() {
  yaml_dir=${1}
  if [[ ${yaml_dir} == ${service_evs} ]]; then kubectl apply -f ${dir_evs} ;
  elif [[ ${yaml_dir} == ${service_obs} ]]; then kubectl apply -f ${dir_obs} ;
  elif [[ ${yaml_dir} == ${service_sfs_turbo} ]]; then kubectl apply -f ${dir_sfs_turbo} ;
  else kubectl apply -f ${yaml_dir}
  fi;
}

function f_kubectl_delete() {
  yaml_dir=${1}
  if [[ ${yaml_dir} == ${service_evs} ]]; then kubectl delete ${dir_evs} ;
  elif [[ ${yaml_dir} == ${service_obs} ]]; then kubectl delete ${dir_obs} ;
  elif [[ ${yaml_dir} == ${service_sfs_turbo} ]]; then kubectl delete ${dir_sfs_turbo} ;
  else kubectl delete ${yaml_dir}
  fi;
}

