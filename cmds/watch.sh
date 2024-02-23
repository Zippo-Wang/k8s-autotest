#!/usr/bin/env bash

source ${kt_project_path}/script/constants.sh

function f_kubectl_get() {
  case ${1} in
    ${k8s_pod} ) watch -n 1 -d kubectl get pod -o wide;;
    ${k8s_pvc} ) watch -n 1 -d kubectl get pvc ;;
    ${k8s_pv} )  watch -n 1 -d kubectl get pv ;;
  esac
}
