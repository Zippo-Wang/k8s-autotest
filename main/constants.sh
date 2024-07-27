#!/usr/bin/env bash

# 核心命令
kt="kt"
auth="zippowang"

# 系统命令
kt_create="create"       # 创建用例
kt_delete="delete"       # 删除用例
kt_install="install"     # 创建RBAC鉴权、安装插件【不包括cloud-config】
kt_uninstall="uninstall" # 删除RBAC鉴权、安装插件【不包括cloud-config】
kt_watch="watch"         # 监控资源
kt_build="build"         # 构建csi包，然后发布到docker hub

kt_help1="help"
kt_help2="-help"
kt_help3="--help"
kt_version1="version"
kt_version2="-version"
kt_version3="--version"
kt_version4="-v"
kt_version5="--v"
sys_current_version="v2.0"

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

# build k8s cluster  ---------------------------------------------------------------------------------------------------
# 当前版本：支持 1*master + n*node 规模
# 未来版本：支持 n*master + n*node 规模
cluster="cluster"
cluster_config="cluster-config"     # 文件名，集群所有的参数都放在这个文件里面。类似cloud-config

# cluster
cluster2="[cluster]"
cloud_name="cloud"                  # 用的哪个云
k8s_version="k8s_version"           # 想要搭建的k8s集群版本【v1.24-v1.29】[只试过1.27.2]
master_ip="master_ip"               # master节点的eip
node_info="node_info"               # node节点的eip和密码{"ip1":"pwd1", "ip2":"pwd2"}
docker_mirror="docker_mirror"       # docker的加速地址

# git 目前的情况是：已经通过脚本搭建集群了，那肯定设置过username这些，所以只需要code_dir和github_repos
git_config="[git]"
git_username="git_username"         # 本地git需要设置的username
git_email="git_email"               # 本地git需要设置的邮箱
code_dir="code_dir"                 # git下来的仓库放到哪个目录，默认/root/code，如果目录不存在，会自动创建
github_repos="github_repos"         # 集群搭建完成后，需要git下来的仓库

# dashboard，不支持指定版本，只支持v2.7，未来会支持吗？看心情
dashboard_config="[dashboard]"
dash_port="dash_port"               # 开放的端口号【默认30011】
dash_user="dash_user"               # 登录dashboard的用户名

# cloud-config依赖的变量名
repo_csi="csi"
repo_ccm="ccm"
repo_packer="packer"
repo_k8s_autotest="k8s-autotest"
repo_hh_system="hh-system"

repo_csi_all="huaweicloud-csi-driver"
repo_ccm_all="cloud-provider-huaweicloud"

repo_csi_url="git@github.com:huaweicloud/huaweicloud-csi-driver.git"
repo_ccm="git@github.com:kubernetes-sigs/cloud-provider-huaweicloud.git"
repo_packer="git@github.com:huaweicloud/packer-plugin-huaweicloud.git"
repo_k8s_autotest="git@github.com:Zippo-Wang/k8s-autotest.git"
repo_hh_system="git@github.com:Zippo-Wang/hh-system.git"

kt_log_path='kt_log_path'


# 其他常量 --------------------------------------------------------------------------------------------------------------
common_none=""
common_init="init"

cmd_list1=(
    ${kt_create} ${kt_delete} ${kt_watch} ${kt_install} ${kt_uninstall} ${kt_build}
    ${common_init} ${kt_help1} ${kt_help2} ${kt_help3}
    ${kt_version1} ${kt_version2} ${kt_version3} ${kt_version4} ${kt_version5}
)
cmd_list2=(
    ${service_evs} ${service_obs} ${service_sfs_turbo} ${k8s_pod} ${k8s_pvc} ${k8s_pv} ${kt_help3}
    ${evs_default} ${evs_parameter} ${evs_deny_resize} ${evs_allow_resize} ${evs_snapshot} ${evs_rwo} ${evs_rwx}
    ${obs_default} ${obs_parameter} ${obs_exist}
    ${sfs_turbo_default} ${sfs_turbo_performance} ${sfs_turbo_deny_resize} ${sfs_turbo_allow_resize} ${sfs_turbo_static}
    ${k8s_deployment} ${k8s_deployment2} ${k8s_sc} ${k8s_service1} ${k8s_service2} ${k8s_node}
    ${k8s_daemonset1} ${k8s_daemonset2}
    ${cluster}
)

# debug常量
info_msg="\033[0;30;42m[INFO]${cend}" # 绿色加粗, INFO
warn_msg="\033[0;30;43m[WARN]${cend}" # 黄色加粗, WARN
err_msg="\033[0;30;41m[ERROR]${cend}" # 红色加粗, ERROR
debug_msg="\033[0;30;44m[DEBUG]${cend}" # 红色加粗, ERROR


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
