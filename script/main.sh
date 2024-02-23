#!/usr/bin/env bash

source ${kt_project_path}/script/constants.sh
source ${kt_project_path}/cmds/apply.sh
source ${kt_project_path}/cmds/watch.sh
source ${kt_project_path}/cmds/other.sh

# 用户输入 ---------------------------------------------------------------------------------------------------------------
operate1=${1} # create/delete/watch/help
operate2=${2} # evs/obs/sfs-turbo，pod/pvc/pv
operate3=${3} # 有始有终


# 判断第1个参数是否是kt ----------------------------------------------------------------------------------------------------
if [[ ${kt_main} != ${kt} ]]; then
  printf "[ERROR]请参考Readme.md配置环境变量：\n"
  exit
fi

# 支持的命令 -------------------------------------------------------------------------------------------------------------
current_cmd="${kt_main} $*" # 获取用户所有输入
#if [[ ${cmd_list1[*]} =~ ${operate1} && ${cmd_list2[*]} =~ ${operate2} && ! ${operate3} ]]; then
if [[ ${cmd_list1[*]} =~ ${operate1} && ! ${operate3} ]]; then
case ${operate1} in
  # 执行
  ${kt_create}) f_kubectl_apply ${operate2} ;;
  ${kt_delete}) f_kubectl_delete ${operate2} ;;
  ${kt_watch})  f_kubectl_get ${operate2} ;;

  # help
  ${kt_help1}) f_help ;;
  ${kt_help2}) f_help ;;
  ${kt_help3}) f_help ;;

  # 其他
  ${common_init}) f_init ;;
  ${common_none}) ;;
esac
else
  printf "${err_msg}没有这个命令：${current_cmd} \n"
fi
