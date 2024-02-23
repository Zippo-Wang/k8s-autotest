#!/usr/bin/env bash

source ${kt_project_path}/script/constants.sh

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

  printf "${font_green1}[${k8s_sc}]↓↓↓${cend}----------------------------------------------------------------------- \n"
  if [[ ! ${#sc[@]} -eq 0 ]]; then for x in ${sc[@]}; do kubectl apply -f ${x}; done; fi;

  printf "${font_green1}[${k8s_pv}]↓↓↓${cend}----------------------------------------------------------------------- \n"
  if [[ ! ${#pv[@]} -eq 0 ]]; then for x in ${pv[@]}; do kubectl apply -f ${x}; done; fi;

  printf "${font_green1}[${k8s_pvc}]↓↓↓${cend}---------------------------------------------------------------------- \n"
  if [[ ! ${#pvc[@]} -eq 0 ]]; then for x in ${pvc[@]}; do kubectl apply -f ${x}; done; fi;

  printf "${font_green1}[${k8s_pod}]↓↓↓${cend}---------------------------------------------------------------------- \n"
  if [[ ! ${#pod[@]} -eq 0 ]]; then for x in ${pod[@]}; do kubectl apply -f ${x}; done; fi;

  printf "${font_green1}[${k8s_snapshotx}]↓↓↓${cend}---------------------------------------------------------------- \n"
  if [[ ! ${#evs_snapshot_array[@]} -eq 0 ]]; then for x in ${evs_snapshot_array[@]}; do kubectl apply -f ${x}; done; fi;

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

  printf "${font_green1}[${k8s_pod}]↓↓↓${cend}------------------------------------------------------------------------ \n"
  if [[ ! ${#pod[@]} -eq 0 ]]; then for x in ${pod[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${font_green1}[${k8s_pvc}]↓↓↓${cend}------------------------------------------------------------------------ \n"
  if [[ ! ${#pvc[@]} -eq 0 ]]; then for x in ${pvc[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${font_green1}[${k8s_pvc2}]↓↓↓${cend}----------------------------------------------------------------------- \n"
  if [[ ! ${#pvc2[@]} -eq 0 ]]; then for x in ${pvc2[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${font_green1}[${k8s_sc}]↓↓↓${cend}------------------------------------------------------------------------- \n"
  if [[ ! ${#sc[@]} -eq 0 ]]; then for x in ${sc[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${font_green1}[${k8s_pv}]↓↓↓${cend}------------------------------------------------------------------------- \n"
  if [[ ! ${#pv[@]} -eq 0 ]]; then for x in ${pv[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${font_green1}[${k8s_snapshotx}]↓↓↓${cend}------------------------------------------------------------------ \n"
  if [[ ! ${#snapshotx[@]} -eq 0 ]]; then for x in ${snapshotx[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${info_msg}The cmd have been executed successfully, please wait for resources be deleted completely. \n"
}

function f_watch() {
  case ${1} in
    ${k8s_pod} ) watch -n 1 -d kubectl get pod -o wide;;
    ${k8s_pvc} ) watch -n 1 -d kubectl get pvc ;;
    ${k8s_pv} )  watch -n 1 -d kubectl get pv ;;
  esac
}
