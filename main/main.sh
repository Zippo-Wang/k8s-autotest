#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh
source ${kt_project_path}/cmds/k8s/csi.sh
source ${kt_project_path}/cmds/k8s/ccm.sh
source ${kt_project_path}/cmds/cluster/cluster.sh
source ${kt_project_path}/cmds/cluster/centos.sh
source ${kt_project_path}/cmds/other.sh
source ${kt_project_path}/cmds/help.sh

# 用户输入 ---------------------------------------------------------------------------------------------------------------
operate1=${1} # create/delete/watch/help
operate2=${2} # evs/obs/sfs-turbo，pod/pvc/pv
operate3=${3} # 倚天屠龙，有始有终

# 检查一波
f_pre_check

# 判断第1个参数是否是kt ---------------------------------------------------------------------------------------------------
if [[ ${kt_main} != ${kt} ]]; then
  printf "[ERROR]请参考Readme.md配置环境变量：\n"
  return
fi

# 支持的命令 -------------------------------------------------------------------------------------------------------------
current_cmd="${kt_main} $*" # 获取用户所有输入
#if [[ ${cmd_list1[*]} =~ ${operate1} && ${cmd_list2[*]} =~ ${operate2} && ! ${operate3} ]]; then
#if [[ ${cmd_list1[*]} =~ ${operate1} && ! ${operate3} ]]; then
if [[ ${cmd_list1[*]} =~ ${operate1} ]]; then
case ${operate1} in
  # create
  ${kt_create})
    case ${operate2} in
      # CSI
      ${service_evs} )      f_create ${dir_evs};;
      ${evs_default} )      f_create ${dir_evs_default};;
      ${evs_parameter} )    f_create ${dir_evs_parameter};;
      ${evs_deny_resize} )  f_create ${dir_evs_deny_resize};;
      ${evs_allow_resize} ) f_create ${dir_evs_allow_resize};;
      ${evs_snapshot} )     f_create ${dir_evs_snapshot};;
      ${evs_rwo} )          f_create ${dir_evs_rwo};;
      ${evs_rwx} )          f_create ${dir_evs_rwx};;

      ${service_obs} )   f_create ${dir_obs};;
      ${obs_default} )   f_create ${dir_obs_default};;
      ${obs_parameter} ) f_create ${dir_obs_parameter};;
      ${obs_exist} )     f_create ${dir_obs_exist};;

      ${service_sfs_turbo} )      f_create ${dir_sfs_turbo};;
      ${sfs_turbo_default} )      f_create ${dir_sfs_turbo_default};;
      ${sfs_turbo_performance} )  f_create ${dir_sfs_turbo_performance};;
      ${sfs_turbo_deny_resize} )  f_create ${dir_sfs_turbo_deny_resize};;
      ${sfs_turbo_allow_resize} ) f_create ${dir_sfs_turbo_allow_resize};;
      ${sfs_turbo_static} )       f_create ${dir_sfs_turbo_static};;

      # CCM
      ${plugin_ccm})   f_create_ccm ${dir_ccm};;
      ${ccm_default})  f_create_ccm ${dir_normal};;
      ${ccm_eip})      f_create_ccm ${dir_eip};;
      ${ccm_affinity}) f_create_ccm ${dir_affinity};;
      ${ccm_existing}) f_create_ccm ${dir_existing};;

      # create cmd help
      ${kt_help3}) f_create_delete_help;;

      # 自定义
      *) f_create ${operate2};;  # 注意不是$*
    esac ;;

  # delete
  ${kt_delete})
    case ${operate2} in
      # CSI
      ${service_evs} )        f_delete ${dir_evs} ;;
      ${service_obs} )        f_delete ${dir_obs} ;;
      ${service_sfs_turbo} )  f_delete ${dir_sfs_turbo} ;;

      # CCM
      ${plugin_ccm})   f_delete_ccm ${dir_ccm};;
      ${ccm_default})  f_delete_ccm ${dir_normal};;
      ${ccm_eip})      f_delete_ccm ${dir_eip};;
      ${ccm_affinity}) f_delete_ccm ${dir_affinity};;
      ${ccm_existing}) f_delete_ccm ${dir_existing};;

      # delete cmd help
      ${kt_help3}) f_create_delete_help;;

      # 自定义
      *) f_delete ${operate2};;
    esac ;;

  # install
  ${kt_install})
    case ${operate2} in
      ${service_evs})       f_install_evs ;;
      ${service_obs})       f_install_obs ;;
      ${service_sfs_turbo}) f_install_sfs_turbo ;;
      ${plugin_ccm})        f_install_ccm ;;

      # install cmd help
      ${kt_help3}) f_install_uninstall_help ;;
      *)           printf "${err_msg}没有这个命令：${current_cmd} \n" ;;
    esac ;;

  # uninstall
  ${kt_uninstall})
    case ${operate2} in
      ${service_evs} )       f_uninstall_evs ;;
      ${service_obs} )       f_uninstall_obs ;;
      ${service_sfs_turbo} ) f_uninstall_sfs_turbo ;;
      ${plugin_ccm})         f_uninstall_ccm ;;

      # uninstall cmd help
      ${kt_help3}) f_install_uninstall_help ;;
      *)           printf "${err_msg}没有这个命令：${current_cmd} \n" ;;
    esac ;;

  # build
  ${kt_build})
    case ${operate2} in
      ${service_evs})       f_build_evs ${operate3} ;;
      ${service_obs})       f_build_obs ${operate3} ;;
      ${service_sfs_turbo}) f_build_sfs_turbo ${operate3} ;;
      ${plugin_ccm})        f_build_ccm ${operate3} ;;
      ${cluster})           f_build_cluster ${operate3} ;;

      # build cmd help
      ${kt_help3}) f_build_help ;;
      *)           printf "${err_msg}没有这个命令：${current_cmd} \n" ;;
    esac ;;

  # watch
  ${kt_watch}) f_watch ${operate2} ;;

  # help
  ${kt_help1}) f_help ;;
  ${kt_help2}) f_help ;;
  ${kt_help3}) f_help ;;

  # version
  ${kt_version1}) f_version ;;
  ${kt_version2}) f_version ;;
  ${kt_version3}) f_version ;;
  ${kt_version4}) f_version ;;
  ${kt_version5}) f_version ;;

  # other
  ${common_init}) f_init ;;
  ${common_none}) ;;
esac
else
  printf "${err_msg}没有这个命令：${current_cmd} \n"
fi

