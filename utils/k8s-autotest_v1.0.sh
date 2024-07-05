#!/usr/bin/env bash

# 【已废弃】第一版脚本，可参考下面的 usage example使用[v1.0能用，但不推荐]
# usage example --------------------------------------------------------------------------------------------------------
:<<EOF
# 1.create
sh k8s-autotest.sh create /root/obs

# 2.delete
sh k8s-autotest.sh delete /root/obs

# 3.file name must be one of as follows:
# pv.yaml, sc.yaml, pvc.yaml, pvc2.yaml, pod.yaml

# 4.special file name
# snapshotx-xxx.yaml
EOF

# init -----------------------------------------------------------------------------------------------------------------
operate1=${1} # create/delete
operate2=${2} # directory
operate3=${3} # xxx xxx

# script judge ---------------------------------------------------------------------------------------------------------
info_msg="\033[1;32m[INFO]\033[0m"
err_msg="\033[1;31m[ERROR]\033[0m"

if [[ ${operate3} == "" ]]; then
  if [[ ${operate1} == "" ]]
  then
    printf "${err_msg}the operate can not be empty, options are [create][delete] \n"
    exit
  fi
  if [[ ${operate2} == "" ]]
  then
    printf "${err_msg}the operate or directory can not be empty, you should specify the operate and directory where the yaml to be executed. \n"
    exit
  elif [ ! -d ${operate2} ]
  then
    printf "${err_msg}the directory is not exists, please check.\n"
    exit
  fi
else
  printf "${err_msg}there can only be two parameters after the script.\n"
  exit
fi


# execute logic --------------------------------------------------------------------------------------------------------

f_create(){
  file_type='yaml'
  sc_index=0
  pv_index=0
  pvc_index=0
  pod_index=0
  sc_array=()
  pv_array=()
  pvc_array=()
  pod_array=()

  # resize
  pvc2_index=0
  pvc2_dirs=()

  # evs snapshot
  evs_snapshot_index=0
  evs_snapshot_array=()

  for file in $(find ${operate2} -name *.${file_type} -type f); do
  if [[ ${file} =~ "sc.${file_type}" ]]; then sc_array[$sc_index]=${file}; ((sc_index++));
  elif [[ ${file} =~ "pv.${file_type}" ]]; then pv_array[$pv_index]=${file}; ((pv_index++));
  elif [[ ${file} =~ "pvc.${file_type}" ]]; then pvc_array[$pvc_index]=${file}; ((pvc_index++));
  elif [[ ${file} =~ "pod.${file_type}" ]]; then pod_array[$pod_index]=${file}; ((pod_index++));

  elif [[ ${file} =~ "pvc2.${file_type}" ]] ;then pvc2_dirs[$pvc2_index]=${file}; ((pvc2_index++));
  elif [[ ${file} =~ "snapshotx" ]] ;then evs_snapshot_array[$evs_snapshot_index]=${file}; ((evs_snapshot_index++));
  fi
  done

  if [[ ! ${#sc_array[@]} -eq 0 ]]; then for x in ${sc_array[@]}; do kubectl apply -f ${x}; done; fi;
  if [[ ! ${#pv_array[@]} -eq 0 ]]; then for x in ${pv_array[@]}; do kubectl apply -f ${x}; done; fi;
  if [[ ! ${#pvc_array[@]} -eq 0 ]]; then for x in ${pvc_array[@]}; do kubectl apply -f ${x}; done; fi;
  if [[ ! ${#pod_array[@]} -eq 0 ]]; then for x in ${pod_array[@]}; do kubectl apply -f ${x}; done; fi;
  if [[ ! ${#evs_snapshot_array[@]} -eq 0 ]]; then for x in ${evs_snapshot_array[@]}; do kubectl apply -f ${x}; done; fi;

  printf "${info_msg}The cmd have been executed successfully, please wait for resources be created completely. \n"

  # resize
  if [[ ! ${#pvc2_dirs[@]} -eq 0 ]]
  then
    printf "${info_msg}\033[0;33mthese tests have resize, please execute manually. \033[0m\n"
    for x in ${pvc2_dirs[@]}; do echo ${x}; done ;
  fi
}


f_delete(){
  file_type='yaml'
  pvc2_index=0  # array at out
  sc_index=0
  pv_index=0
  pvc_index=0
  pod_index=0
  sc_array=()
  pv_array=()
  pvc_array=()
  pod_array=()

  # evs snapshot
  evs_snapshot_index=0
  evs_snapshot_array=()

  for file in $(find ${operate2} -name *.${file_type} -type f); do
  if [[ ${file} =~ "sc.${file_type}" ]]; then sc_array[$sc_index]=${file}; ((sc_index++));
  elif [[ ${file} =~ "pv.${file_type}" ]]; then pv_array[$pv_index]=${file}; ((pv_index++));
  elif [[ ${file} =~ "pvc.${file_type}" ]]; then pvc_array[$pvc_index]=${file}; ((pvc_index++));
  elif [[ ${file} =~ "pod.${file_type}" ]]; then pod_array[$pod_index]=${file}; ((pod_index++));

  elif [[ ${file} =~ "pvc2.${file_type}" ]] ;then pvc2_dirs[$pvc2_index]=${file}; ((pvc2_index++));
  elif [[ ${file} =~ "snapshotx" ]] ;then evs_snapshot_array[$evs_snapshot_index]=${file}; ((evs_snapshot_index++));
  fi
  done

  if [[ ! ${#pod_array[@]} -eq 0 ]]; then for x in ${pod_array[@]}; do kubectl delete -f ${x}; done; fi;
  if [[ ! ${#pvc_array[@]} -eq 0 ]]; then for x in ${pvc_array[@]}; do kubectl delete -f ${x}; done; fi;
  if [[ ! ${#sc_array[@]} -eq 0 ]]; then for x in ${sc_array[@]}; do kubectl delete -f ${x}; done; fi;
  if [[ ! ${#pv_array[@]} -eq 0 ]]; then for x in ${pv_array[@]}; do kubectl delete -f ${x}; done; fi;
  if [[ ! ${#evs_snapshot_array[@]} -eq 0 ]]; then for x in ${evs_snapshot_array[@]}; do kubectl delete -f ${x}; done; fi;

  printf "${info_msg}The cmd have been executed successfully, please wait for resources be deleted completely. \n"
}

# cmds -----------------------------------------------------------------------------------------------------------------
case ${operate1} in
  "create") f_create ${pvc2_dirs};;
  "delete") f_delete ;;
  "") ;;
esac

# test code ------------------------------------------------------------------------------------------------------------
:<<EOF
file_type='py'
for file in $(find ${operate2} -name *.${file_type} -type f)
do
  python ${file}
done
EOF
