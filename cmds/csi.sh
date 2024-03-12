#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh

function f_create() {
  yaml_dir=${1}
  # 一般
  sc=$(find ${yaml_dir} -name sc.yaml -type f)
  pv=$(find ${yaml_dir} -name pv.yaml -type f)
  pvc=$(find ${yaml_dir} -name pvc.yaml -type f)
  pod=$(find ${yaml_dir} -name pod.yaml -type f)

  # 特殊
  pvc2=$(find ${yaml_dir} -name pvc2.yaml -type f)
  snapshotx=$(find ${yaml_dir} -name snapshotx -type f)

  if [[ ! ${#sc[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_sc}]↓↓↓${cend}--------------------------------------------------------------------- \n"
    for x in ${sc[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#pv[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pv}]↓↓↓${cend}--------------------------------------------------------------------- \n"
    for x in ${pv[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#pvc[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pvc}]↓↓↓${cend}-------------------------------------------------------------------- \n"
    for x in ${pvc[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#pod[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pod}]↓↓↓${cend}-------------------------------------------------------------------- \n"
    for x in ${pod[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#evs_snapshot_array[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_snapshotx}]↓↓↓${cend}-------------------------------------------------------------- \n"
    for x in ${evs_snapshot_array[@]}; do kubectl apply -f ${x}; done;
  fi;

  echo
  printf "${info_msg}The cmd have been executed successfully, please wait for resources be created completely. \n"

  # resize
  if [[ ! ${#pvc2[@]} -eq 0 ]]
  then
    printf "${info_msg}\033[0;33mthese tests have resize, please execute manually: \033[0m\n"
    for x in ${pvc2[@]}; do echo ${x}; done ;
  fi
}

function f_delete() {
  yaml_dir=${1}
  # 一般
  sc=$(find ${yaml_dir} -name sc.yaml -type f)
  pv=$(find ${yaml_dir} -name pv.yaml -type f)
  pvc=$(find ${yaml_dir} -name pvc.yaml -type f)
  pod=$(find ${yaml_dir} -name pod.yaml -type f)

  # 特殊
  pvc2=$(find ${yaml_dir} -name pvc2.yaml -type f)
  snapshotx=$(find ${yaml_dir} -name snapshotx -type f)

  if [[ ! ${#pod[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pod}]↓↓↓${cend}-------------------------------------------------------------------- \n"
    for x in ${pod[@]};
    do {
        kubectl delete -f ${x}
    }&
    done
    wait
  fi;

  if [[ ! ${#pvc[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pvc}]↓↓↓${cend}-------------------------------------------------------------------- \n"
    for x in ${pvc[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#pvc2[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pvc2}]↓↓↓${cend}------------------------------------------------------------------- \n"
    for x in ${pvc2[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#sc[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_sc}]↓↓↓${cend}--------------------------------------------------------------------- \n"
    for x in ${sc[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#pv[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_pv}]↓↓↓${cend}--------------------------------------------------------------------- \n"
    for x in ${pv[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#snapshotx[@]} -eq 0 ]]; then
    printf "${font_green1}[${k8s_snapshotx}]↓↓↓${cend}-------------------------------------------------------------- \n"
    for x in ${snapshotx[@]}; do kubectl delete -f ${x}; done;
  fi;

  echo
  printf "${info_msg}The cmd have been executed successfully, please wait for resources be deleted completely. \n"
}

function f_watch() {
  case ${1} in
    ${k8s_pod} ) watch -n 1 -d kubectl get pod -o wide;;
    ${k8s_pvc} ) watch -n 1 -d kubectl get pvc ;;
    ${k8s_pv} )  watch -n 1 -d kubectl get pv ;;
    ${k8s_deployment} )  watch -n 1 -d kubectl get deployment ;;
    ${k8s_service} )  watch -n 1 -d kubectl get service ;;
    ${k8s_node} )  watch -n 1 -d kubectl get node ;;
  esac
}

function f_install_evs() {
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-node.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-node.yaml
}

function f_install_obs() {
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-node.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-node.yaml
}

function f_install_sfs_turbo() {
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-node.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-node.yaml
}

function f_uninstall_evs() {
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-node.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-secret.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-driver.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-node.yaml
}

function f_uninstall_obs() {
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-node.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-secret.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-driver.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-node.yaml
}

function f_uninstall_sfs_turbo() {
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-node.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-secret.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-driver.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-node.yaml
}

function f_build_evs() {
    printf "${font_green1}make images...${cend} \n"
    VERSION=${1} make image-evs-csi-plugin
    printf "${font_green1}push images...${cend} \n"
    VERSION=${1} make push-image-evs-csi-plugin
}

function f_build_obs() {
    printf "${font_green1}make images...${cend} \n"
    VERSION=${1} make image-obs-csi-plugin
    printf "${font_green1}push images...${cend} \n"
    VERSION=${1} make push-image-obs-csi-plugin
}

function f_build_sfs_turbo() {
    printf "${font_green1}make images...${cend} \n"
    VERSION=${1} make image-sfsturbo-csi-plugin
    printf "${font_green1}push images...${cend} \n"
    VERSION=${1} make push-image-sfsturbo-csi-plugin
}
