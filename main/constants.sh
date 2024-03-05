#!/usr/bin/env bash

# 核心命令
kt="kt"

# 系统命令
kt_create="create"
kt_delete="delete"
kt_watch="watch"
kt_help1="help"
kt_help2="-help"
kt_help3="--help"

# 云服务
service_evs="evs"
service_obs="obs"
service_sfs_turbo="sfs-turbo"

# 脚本目录
dir_evs="${kt_project_path}/test-case/csi/EVS"
dir_obs="${kt_project_path}/test-case/csi/OBS"
dir_sfs_turbo="${kt_project_path}/test-case/csi/SFS-Turbo"

# k8s监控
k8s_deployment="deployment"
k8s_pod="pod"
k8s_pvc="pvc"
k8s_pv="pv"
k8s_sc="sc"
k8s_service="service"
k8s_node="node"

k8s_pvc2="pvc2"
k8s_snapshotx="snapshotx"

# ccm ------------------------------------------------------------------------------------------------------------------
plugin_ccm="ccm"

dir_ccm="${kt_project_path}/test-case/ccm"


# 其他常量 --------------------------------------------------------------------------------------------------------------
common_none=""
common_init="init"

cmd_list1=(${kt_create} ${kt_delete} ${kt_watch} ${common_init} ${kt_help1} ${kt_help2} ${kt_help3})
cmd_list2=(${service_evs} ${service_obs} ${service_sfs_turbo} ${k8s_pod} ${k8s_pvc} ${k8s_pv})

# debug常量
info_msg="\033[1;32m[INFO]\033[0m"  # 绿色加粗
err_msg="\033[1;31m[ERROR]\033[0m"  # 红色加粗

# 颜色常量
cend='\033[0m'

font_red='\033[0;31m'
font_green='\033[0;32m'
font_yellow='\033[0;33m'

font_red1='\033[1;31m'
font_green1='\033[1;32m'
font_yellow1='\033[1;33m'
