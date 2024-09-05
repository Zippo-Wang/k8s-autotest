#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh
source ${kt_project_path}/cmds/k8s/csi.sh
source ${kt_project_path}/cmds/k8s/ccm.sh
source ${kt_project_path}/cmds/other.sh
source ${kt_project_path}/cmds/help.sh

# 用户输入 ---------------------------------------------------------------------------------------------------------------
operate1=${1} # create/delete/watch/help
operate2=${2} # evs/obs/sfs-turbo，pod/pvc/pv
operate3=${3} # 倚天屠龙，有始有终(包含kt在内，一共3个参数, 比如kt create obs)
operate4=${4} # 倚天屠龙，有始有终(包含kt在内，一共4个参数, 比如kt build obs v1.0)

# 检查一波
f_pre_check
checkPassed=$?
if [[ ${checkPassed} == 0 ]]; then return 0; fi

# 判断第1个参数是否是kt ---------------------------------------------------------------------------------------------------
if [[ ${kt_main} != ${kt} ]]; then
  printf "${err_msg}请参考Readme.md配置环境变量：\n"
  return
fi

# 只敲了一个kt，没跟别的参数 -----------------------------------------------------------------------------------------------
if [[ -z ${operate1} ]]; then
  printf "${info_msg}欢迎使用k8s-autotest, 请使用${font_green1}${kt} ${kt_help1}${cend}查看使用帮助\n"
  return
fi

# 支持的命令 -------------------------------------------------------------------------------------------------------------
current_cmd="${kt_main} $*" # 获取用户所有输入
if [[ ${cmd_list1[*]} =~ ${operate1} && ${cmd_list2[*]} =~ ${operate2} ]]; then
case ${operate1} in
  # create
  ${kt_create})
    f_validate_cmd ${kt_create} ${operate2} ${operate3}
    valid=$?
    if [[ ${valid} = 0 ]]; then return; fi
    case ${operate2} in
      # CSI
      ${service_evs} )      f_create ${dir_evs} ${operate3} ;;
      ${evs_default} )      f_create ${dir_evs_default} ${operate3} ;;
      ${evs_parameter} )    f_create ${dir_evs_parameter} ${operate3} ;;
      ${evs_deny_resize} )  f_create ${dir_evs_deny_resize} ${operate3} ;;
      ${evs_allow_resize} ) f_create ${dir_evs_allow_resize} ${operate3} ;;
      ${evs_snapshot} )     f_create ${dir_evs_snapshot} ${operate3} ;;
      ${evs_rwo} )          f_create ${dir_evs_rwo} ${operate3} ;;
      ${evs_rwx} )          f_create ${dir_evs_rwx} ${operate3} ;;

      ${service_obs} )    f_create ${dir_obs} ${operate3};;
      ${obs_default} )    f_create ${dir_obs_default} ${operate3};;
      ${obs_parameter} )  f_create ${dir_obs_parameter} ${operate3};;
      ${obs_exist} )      f_create ${dir_obs_exist} ${operate3};;
      ${obs_encryption} ) f_create ${dir_obs_encryption} ${operate3};;

      ${service_sfs_turbo} )      f_create ${dir_sfs_turbo} ;;
      ${sfs_turbo_default} )      f_create ${dir_sfs_turbo_default} ;;
      ${sfs_turbo_performance} )  f_create ${dir_sfs_turbo_performance} ;;
      ${sfs_turbo_deny_resize} )  f_create ${dir_sfs_turbo_deny_resize} ;;
      ${sfs_turbo_allow_resize} ) f_create ${dir_sfs_turbo_allow_resize} ;;
      ${sfs_turbo_static} )       f_create ${dir_sfs_turbo_static} ;;

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
    f_validate_cmd ${kt_delete} ${operate2} ${operate3}
    valid=$?
    if [[ ${valid} = 0 ]]; then return; fi
    case ${operate2} in
      # CSI
      ${service_evs} )      f_delete ${dir_evs} ${operate3} ;;
      ${evs_default} )      f_delete ${dir_evs_default} ${operate3} ;;
      ${evs_parameter} )    f_delete ${dir_evs_parameter} ${operate3} ;;
      ${evs_deny_resize} )  f_delete ${dir_evs_deny_resize} ${operate3} ;;
      ${evs_allow_resize} ) f_delete ${dir_evs_allow_resize} ${operate3} ;;
      ${evs_snapshot} )     f_delete ${dir_evs_snapshot} ${operate3} ;;
      ${evs_rwo} )          f_delete ${dir_evs_rwo} ${operate3} ;;
      ${evs_rwx} )          f_delete ${dir_evs_rwx} ${operate3} ;;

      ${service_obs} )    f_delete ${dir_obs} ${operate3};;
      ${obs_default} )    f_delete ${dir_obs_default} ${operate3};;
      ${obs_parameter} )  f_delete ${dir_obs_parameter} ${operate3};;
      ${obs_exist} )      f_delete ${dir_obs_exist} ${operate3};;
      ${obs_encryption} ) f_delete ${dir_obs_encryption} ${operate3};;

      ${service_sfs_turbo} )      f_delete ${dir_sfs_turbo} ;;
      ${sfs_turbo_default} )      f_delete ${dir_sfs_turbo_default} ;;
      ${sfs_turbo_performance} )  f_delete ${dir_sfs_turbo_performance} ;;
      ${sfs_turbo_deny_resize} )  f_delete ${dir_sfs_turbo_deny_resize} ;;
      ${sfs_turbo_allow_resize} ) f_delete ${dir_sfs_turbo_allow_resize} ;;
      ${sfs_turbo_static} )       f_delete ${dir_sfs_turbo_static} ;;

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
    f_validate_cmd ${kt_install} ${operate2} ${operate3}
    valid=$?
    if [[ ${valid} = 0 ]]; then return; fi
    case ${operate2} in
      ${service_evs})       f_install_evs ;;
      ${service_obs})       f_install_obs ;;
      ${service_sfs_turbo}) f_install_sfs_turbo ;;
      ${plugin_ccm})        f_install_ccm ;;

      # install cmd help
      ${kt_help3}) f_install_uninstall_help ;;
    esac ;;

  # uninstall
  ${kt_uninstall})
    f_validate_cmd ${kt_uninstall} ${operate2} ${operate3}
    valid=$?
    if [[ ${valid} = 0 ]]; then return; fi
    case ${operate2} in
      ${service_evs} )       f_uninstall_evs ;;
      ${service_obs} )       f_uninstall_obs ;;
      ${service_sfs_turbo} ) f_uninstall_sfs_turbo ;;
      ${plugin_ccm})         f_uninstall_ccm ;;

      # uninstall cmd help
      ${kt_help3}) f_install_uninstall_help ;;
    esac ;;

  # build
  ${kt_build})
    f_validate_build_cmd ${kt_build} ${operate2} ${operate3} ${operate4}
    valid=$?
    if [[ ${valid} = 0 ]]; then return; fi
    case ${operate2} in
      ${service_evs})       f_build_evs ${operate3} ;;
      ${service_obs})       f_build_obs ${operate3} ;;
      ${service_sfs_turbo}) f_build_sfs_turbo ${operate3} ;;
      ${plugin_ccm})        f_build_ccm ${operate3} ;;
      ${cluster})           f_build_cluster ${operate3} ;;

      # build cmd help
      ${kt_help3}) f_build_help ;;
    esac ;;

  # watch
  ${kt_watch}) f_watch ${operate2} ;;

  # help
  ${kt_help1}) f_help ;;
  ${kt_help2}) f_help ;;
  ${kt_help3}) f_help ;;

  # version
  # 没啥用，图一乐
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

