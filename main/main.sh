#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh
source ${kt_project_path}/cmds/csi.sh
source ${kt_project_path}/cmds/ccm.sh
source ${kt_project_path}/cmds/other.sh

# 用户输入 ---------------------------------------------------------------------------------------------------------------
operate1=${1} # create/delete/watch/help
operate2=${2} # evs/obs/sfs-turbo，pod/pvc/pv
operate3=${3} # 倚天屠龙，有始有终


# 判断第1个参数是否是kt ----------------------------------------------------------------------------------------------------
if [[ ${kt_main} != ${kt} ]]; then
  printf "[ERROR]请参考Readme.md配置环境变量：\n"
  exit
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
      ${service_evs} )        f_create ${dir_evs};;
      ${service_obs} )        f_create ${dir_obs};;
      ${service_sfs_turbo} )  f_create ${dir_sfs_turbo};;

      # CCM
      ${plugin_ccm})   f_create_ccm ${dir_ccm};;
      ${ccm_normal})   f_create_ccm ${dir_normal};;
      ${ccm_eip})      f_create_ccm ${dir_eip};;
      ${ccm_affinity}) f_create_ccm ${dir_affinity};;
      ${ccm_existing}) f_create_ccm ${dir_existing};;

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
      ${ccm_normal})   f_delete_ccm ${dir_normal};;
      ${ccm_eip})      f_delete_ccm ${dir_eip};;
      ${ccm_affinity}) f_delete_ccm ${dir_affinity};;
      ${ccm_existing}) f_delete_ccm ${dir_existing};;

      # 自定义
      *) f_delete ${operate2};;
    esac ;;

  # install
  ${kt_install})
    case ${operate2} in
      ${service_evs} )       f_install_evs ;;
      ${service_obs} )       f_install_obs ;;
      ${service_sfs_turbo} ) f_install_sfs_turbo ;;
      ${plugin_ccm})         f_install_ccm ;;
      *)                     printf "${err_msg}没有这个命令：${current_cmd} \n" ;;
    esac ;;

  # uninstall
  ${kt_uninstall})
    case ${operate2} in
      ${service_evs} )       f_uninstall_evs ;;
      ${service_obs} )       f_uninstall_obs ;;
      ${service_sfs_turbo} ) f_uninstall_sfs_turbo ;;
      ${plugin_ccm})         f_uninstall_ccm ;;
      *)                     printf "${err_msg}没有这个命令：${current_cmd} \n" ;;
    esac ;;

  # build
  ${kt_build})
    case ${operate2} in
      ${service_evs} )       f_build_evs ${operate3} ;;
      ${service_obs} )       f_build_obs ${operate3} ;;
      ${service_sfs_turbo} ) f_build_sfs_turbo ${operate3} ;;
      ${plugin_ccm} )        f_build_ccm ${operate3} ;;
      ${cluster} )           f_build_cluster ${operate3} ;;
      *)                     printf "${err_msg}没有这个命令：${current_cmd} \n" ;;
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

