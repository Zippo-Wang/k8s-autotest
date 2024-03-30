#!/usr/bin/env bash

# 核心命令
kt="kt"
auth="zippowang"

# 系统命令
kt_create="create"      # 创建用例
kt_delete="delete"      # 删除用例
kt_install="install"    # 创建RBAC鉴权、安装插件【不包括cloud-config】
kt_uninstall="uninstall"    # 删除RBAC鉴权、安装插件【不包括cloud-config】
kt_watch="watch"        # 监控资源
kt_build="build"        # 构建csi包，然后发布到docker hub
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
k8s_daemonset1="daemonset"
k8s_daemonset2="ds"
k8s_pod="pod"
k8s_pvc="pvc"
k8s_pv="pv"
k8s_sc="sc"
k8s_service1="service"
k8s_service2="service"
k8s_node="node"

k8s_pvc2="pvc2"
k8s_snapshotx="snapshotx"

# ccm ------------------------------------------------------------------------------------------------------------------
plugin_ccm="ccm"

dir_ccm="${kt_project_path}/test-case/ccm"


# 其他常量 --------------------------------------------------------------------------------------------------------------
common_none=""
common_init="init"

cmd_list1=(
    ${kt_create} ${kt_delete} ${kt_watch} ${kt_install} ${kt_uninstall} ${kt_build}
    ${common_init} ${kt_help1} ${kt_help2} ${kt_help3}
)
cmd_list2=(
    ${service_evs} ${service_obs} ${service_sfs_turbo} ${k8s_pod} ${k8s_pvc} ${k8s_pv}
    ${k8s_deployment} ${k8s_sc} ${k8s_service1} ${k8s_service2} ${k8s_node}
    ${k8s_daemonset1} ${k8s_daemonset2}
)

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
