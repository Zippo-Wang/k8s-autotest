#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh

function f_create_ccm() {
  yaml_dir=${1}
  # 一般
  deployment=$(find ${yaml_dir} -name deployment.yaml -type f)
  service=$(find ${yaml_dir} -name elb-service.yaml -type f)

  if [[ ! ${#deployment[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_deployment}]↓↓↓${cend}----------------------------------------------------------------- \n"
    for x in ${deployment[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#service[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_service}]↓↓↓${cend}-------------------------------------------------------------------- \n"
    for x in ${service[@]}; do kubectl apply -f ${x}; done;
  fi;

  echo
  printf "${info_msg}The cmd have been executed successfully, please wait for resources be created completely. \n"
}


function f_delete_ccm() {
  yaml_dir=${1}
  # 一般
  service=$(find ${yaml_dir} -name elb-service.yaml -type f)
  deployment=$(find ${yaml_dir} -name deployment.yaml -type f)

  if [[ ! ${#service[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_service}]↓↓↓${cend}-------------------------------------------------------------------- \n"
    for x in ${service[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#deployment[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_deployment}]↓↓↓${cend}----------------------------------------------------------------- \n"
    for x in ${deployment[@]}; do kubectl delete -f ${x}; done;
  fi;

  echo
  printf "${info_msg}The cmd have been executed successfully, please wait for resources be deleted completely. \n"
}

function f_install_ccm() {
kubectl apply -f  https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-huaweicloud/master/manifests/rbac-huawei-cloud-controller-manager.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-huaweicloud/master/manifests/huawei-cloud-controller-manager.yaml
}

function f_uninstall_ccm() {
kubectl delete -f  https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-huaweicloud/master/manifests/rbac-huawei-cloud-controller-manager.yaml
kubectl delete -f  https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-huaweicloud/master/manifests/huawei-cloud-controller-manager.yaml
}

function f_build_ccm() {
    printf "${font_green1}make images↓↓↓${cend} \n"
    VERSION=${1} make image-huawei-cloud-controller-manager
    printf "${font_green1}push images↓↓↓${cend} \n"
    VERSION=${1} make upload-images huawei-cloud-controller-manager
}
