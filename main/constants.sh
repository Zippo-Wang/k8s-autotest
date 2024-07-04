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
kt_version1="version"
kt_version2="-version"
kt_version3="--version"
kt_version4="-v"
kt_version5="--v"
sys_current_version="v2.0"

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
ccm_normal="ccm-normal"
ccm_eip="ccm-eip"
ccm_affinity="ccm-affinity"
ccm_existing="ccm-existing"

dir_ccm="${kt_project_path}/test-case/ccm"
dir_normal="${kt_project_path}/test-case/ccm/01_dynamic_elb_normal"
dir_eip="${kt_project_path}/test-case/ccm/02_dynamic_elb_eip"
dir_affinity="${kt_project_path}/test-case/ccm/03_session_affinity_elb"
dir_existing="${kt_project_path}/test-case/ccm/04_existing_elb"

# build k8s cluster  ---------------------------------------------------------------------------------------------------
# 版本1：只支持 1master + 2node 规模
cluster="cluster"
cluster_config="cluster-config"     # 文件名，集群所有的参数都放在这个文件里面。类似cloud-config

# cluster
cluster2="[cluster]"
k8s_version="k8s_version"           # 想要搭建的k8s集群版本【v1.24-v1.29】[只试过1.27.2]
master_ip="master_ip"               # master节点的eip
node1_ip="node1_ip"                 # node1节点的eip
node2_ip="node2_ip"                 # node2节点的eip
node1_pwd="node1_pwd"               # node1节点的ssh密码
node2_pwd="node2_pwd"               # node2节点的ssh密码
docker_mirror="docker_mirror"       # docker的加速地址

# git 目前的情况是：已经通过脚本搭建集群了，那肯定设置过username这些，所以只需要code_dir和github_repos
git_config="[git]"
git_username="git_username"         # 本地git需要设置的username
git_email="git_email"               # 本地git需要设置的邮箱
code_dir="code_dir"                 # git下来的仓库放到哪个目录，默认/root/code，如果目录不存在，会自动创建
github_repos="github_repos"         # 集群搭建完成后，需要git下来的仓库

# dashboard，不支持指定版本，只支持v2.7
dashboard_config="[dashboard]"
dash_port="dash_port"               # 开放的端口号【默认30011】
dash_user="dash_user"               # 登录dashboard的用户名

# cloud-config依赖的变量名
repo_csi="csi"
repo_ccm="ccm"
repo_k8s_autotest="k8s-autotest"
repo_hh_system="hh-system"

# 其他常量 --------------------------------------------------------------------------------------------------------------
common_none=""
common_init="init"

cmd_list1=(
    ${kt_create} ${kt_delete} ${kt_watch} ${kt_install} ${kt_uninstall} ${kt_build}
    ${common_init} ${kt_help1} ${kt_help2} ${kt_help3}
    ${kt_version1} ${kt_version2} ${kt_version3} ${kt_version4} ${kt_version5}
)
cmd_list2=(
    ${service_evs} ${service_obs} ${service_sfs_turbo} ${k8s_pod} ${k8s_pvc} ${k8s_pv}
    ${k8s_deployment} ${k8s_deployment2} ${k8s_sc} ${k8s_service1} ${k8s_service2} ${k8s_node}
    ${k8s_daemonset1} ${k8s_daemonset2}
    ${cluster}
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
