#!/usr/bin/env bash

# 核心命令
kt="kt"
auth="zippowang"

# 系统命令
kt_create="create"       # 创建用例
kt_delete="delete"       # 删除用例
kt_install="install"     # 创建RBAC鉴权、安装插件【不包括cloud-config】
kt_uninstall="uninstall" # 删除RBAC鉴权、安装插件【不包括cloud-config】
kt_update="update"       # 更新deployment和DaemonSet的镜像
kt_watch="watch"         # 监控资源
kt_build="build"         # 构建csi包, 然后发布到docker hub
kt_config="config"       # 新增一个命令, 但不知道该归于哪一类里面去，就放这

kt_help1="help"
kt_help2="-help"
kt_help3="--help"
kt_version1="version"
kt_version2="-version"
kt_version3="--version"
kt_version4="-v"
kt_version5="--v"
sys_current_version="v2.1.2"    # 没啥用, 图一乐, 就是玩~

kt_clear="clear"                # 用于安装clear命令
kt_ds="--ds"                    # 用于以DaemonSet的方式执行用例
kt_cloud_config="cloud-config" # 用于指定cloud-config的路径


# 云服务
service_evs="evs"
evs_default="evs-default"
evs_parameter="evs-parameter"
evs_deny_resize="evs-deny-resize"
evs_allow_resize="evs-allow-resize"
evs_snapshot="evs-snapshot"
evs_rwo="evs-rwo"
evs_rwx="evs-rwx"

service_obs="obs"
obs_default="obs-default"
obs_parameter="obs-parameter"
obs_exist="obs-exist"
obs_encryption="obs-encryption"

service_sfs_turbo="sfsturbo"
sfs_turbo_default="sfsturbo-default"
sfs_turbo_performance="sfsturbo-performance"
sfs_turbo_deny_resize="sfsturbo-deny-resize"
sfs_turbo_allow_resize="sfsturbo-allow-resize"
sfs_turbo_static="sfsturbo-static"

# 脚本目录
dir_evs="${kt_project_path}/test-case/csi/evs"
dir_evs_default="${kt_project_path}/test-case/csi/evs/01_evs-dynamic/01_default"
dir_evs_parameter="${kt_project_path}/test-case/csi/evs/01_evs-dynamic/02_parameters"
dir_evs_deny_resize="${kt_project_path}/test-case/csi/evs/02_evs-resize/01_allowVolumeExpansion_is_false"
dir_evs_allow_resize="${kt_project_path}/test-case/csi/evs/02_evs-resize/02_true"
dir_evs_snapshot="${kt_project_path}/test-case/csi/evs/03_evs-snapshot"
dir_evs_rwo="${kt_project_path}/test-case/csi/evs/04_evs-share/01_RWO"
dir_evs_rwx="${kt_project_path}/test-case/csi/evs/04_evs-share/02_RWX"

dir_obs="${kt_project_path}/test-case/csi/obs"
dir_obs_default="${kt_project_path}/test-case/csi/obs/01_obs-dynamic/01_default"
dir_obs_parameter="${kt_project_path}/test-case/csi/obs/01_obs-dynamic/02_parameters"
dir_obs_exist="${kt_project_path}/test-case/csi/obs/02_obs-exist-dynamic"
dir_obs_encryption="${kt_project_path}/test-case/csi/obs/03_obs-encryption"

dir_sfs_turbo="${kt_project_path}/test-case/csi/sfs-turbo"
dir_sfs_turbo_default="${kt_project_path}/test-case/csi/sfs-turbo/01_sfs-turbo-dynamic/01_default"
dir_sfs_turbo_performance="${kt_project_path}/test-case/csi/sfs-turbo/01_sfs-turbo-dynamic/02_performance"
dir_sfs_turbo_deny_resize="${kt_project_path}/test-case/csi/sfs-turbo/02_sfs-turbo-resize/01_allowVolumeExpansion_is_false"
dir_sfs_turbo_allow_resize="${kt_project_path}/test-case/csi/sfs-turbo/02_sfs-turbo-resize/02_expand_and_scale-in"
dir_sfs_turbo_static="${kt_project_path}/test-case/csi/sfs-turbo/03_sfs-turbo-static"

# k8s监控
k8s_deployment="deployment"
k8s_deployment2="dep"
k8s_daemonset1="daemonset"
k8s_daemonset2="ds"
k8s_pod="pod"
k8s_pvc="pvc"
k8s_pvc_all="PersistentVolumeClaim"
k8s_pv="pv"
k8s_pv_all="PersistentVolume"
k8s_sc="sc"
k8s_service1="service"
k8s_service2="svc"
k8s_node="node"

k8s_pvc2="pvc2"
k8s_snapshotx="snapshotx"

# repo -----------------------------------------------------------------------------------------------------------------
repo_csi_all="huaweicloud-csi-driver"
repo_ccm_all="cloud-provider-huaweicloud"

# ccm ------------------------------------------------------------------------------------------------------------------
plugin_ccm="ccm"
ccm_default="ccm-normal"
ccm_eip="ccm-eip"
ccm_affinity="ccm-affinity"
ccm_existing="ccm-existing"

dir_ccm="${kt_project_path}/test-case/ccm"
dir_normal="${kt_project_path}/test-case/ccm/01_dynamic_elb_normal"
dir_eip="${kt_project_path}/test-case/ccm/02_dynamic_elb_eip"
dir_affinity="${kt_project_path}/test-case/ccm/03_session_affinity_elb"
dir_existing="${kt_project_path}/test-case/ccm/04_existing_elb"

# 其他常量 --------------------------------------------------------------------------------------------------------------
common_none=""
common_init="init"

cmd_list1=(
    ${kt_create} ${kt_delete} ${kt_watch} ${kt_install} ${kt_uninstall} ${kt_build} ${kt_config} ${kt_update}
    ${common_init} ${kt_help1} ${kt_help2} ${kt_help3}
    ${kt_version1} ${kt_version2} ${kt_version3} ${kt_version4} ${kt_version5}
)

cmd_list2=(
    ${service_evs} ${service_obs} ${service_sfs_turbo} ${k8s_pod} ${k8s_pvc} ${k8s_pv} ${kt_help3}
    ${evs_default} ${evs_parameter} ${evs_deny_resize} ${evs_allow_resize} ${evs_snapshot} ${evs_rwo} ${evs_rwx}
    ${obs_default} ${obs_parameter} ${obs_exist} ${obs_encryption}
    ${sfs_turbo_default} ${sfs_turbo_performance} ${sfs_turbo_deny_resize} ${sfs_turbo_allow_resize} ${sfs_turbo_static}
    ${k8s_deployment} ${k8s_deployment2} ${k8s_sc} ${k8s_service1} ${k8s_service2} ${k8s_node}
    ${k8s_daemonset1} ${k8s_daemonset2}
    ${cluster} ${kt_cloud_config} ${kt_clear}
)

# debug常量
info_msg="\033[0;30;42m[INFO]${cend}"   # 绿色加粗, INFO
warn_msg="\033[0;30;43m[WARN]${cend}"   # 黄色加粗, WARN
err_msg="\033[0;30;41m[ERROR]${cend}"   # 红色加粗, ERROR
debug_msg="\033[0;30;44m[DEBUG]${cend}" # 蓝色加粗, DEBUG

ok=1
no_ok=0


# 颜色常量
cend='\033[0m'  # color end

font_red='\033[0;31m'
font_green='\033[0;32m'
font_yellow='\033[0;33m'
font_blue='\033[0;34m'

font_red1='\033[1;31m'
font_green1='\033[1;32m'
font_yellow1='\033[1;33m'
font_blue1='\033[1;34m'
flash_light='\33[5m\033[32m🔔🔔🔔\33[0m'
