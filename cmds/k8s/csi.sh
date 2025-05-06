#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh

#####################################################################################
# create
#####################################################################################
function f_create() {
  yaml_dir=${1}
  daemonset=${2}

  # 一般
  sc=($(find ${yaml_dir} -name sc.yaml -type f))  # -type f。find的一个选项, 表示只查找普通文件, 不包括目录、设备文件等
  pv=($(find ${yaml_dir} -name pv.yaml -type f))
  pvc=($(find ${yaml_dir} -name pvc.yaml -type f))
  pod=($(find ${yaml_dir} -name pod.yaml -type f))

  # 特殊
  pvc2=($(find ${yaml_dir} -name pvc2.yaml -type f))
  snapshotx=($(find ${yaml_dir} -name snapshotx -type f))

  if [[ ${daemonset} == ${kt_ds} ]]; then
    ds=($(find ${yaml_dir} -name ds.yaml -type f))
   # ds2=($(find ${yaml_dir} -name ds2.yaml -type f)) # 目前先不管ds2的情况
  fi

  if [[ ! ${#sc[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_sc}]↓↓↓----------------------------------------------------------${cend} \n"
    for x in ${sc[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#pv[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_pv}]↓↓↓----------------------------------------------------------${cend} \n"
    for x in ${pv[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#pvc[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_pvc}]↓↓↓---------------------------------------------------------${cend} \n"
    for x in ${pvc[@]}; do kubectl apply -f ${x}; done;
  fi;

  if [[ ! ${#pod[@]} -eq 0 && ${daemonset} == "" ]]; then
    printf "${info_msg}${font_green1}[${k8s_pod}]↓↓↓---------------------------------------------------------${cend} \n"
    for x in ${pod[@]}; do kubectl apply -f ${x}; done;
  elif [[ ! ${#ds[@]} -eq 0 && ${daemonset} == ${kt_ds} ]]; then
    printf "${info_msg}${font_green1}[${k8s_daemonset2}]↓↓↓---------------------------------------------------------${cend} \n"
    for x in ${ds[@]}; do kubectl apply -f ${x}; done;
  fi

  if [[ ! ${#evs_snapshot_array[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_snapshotx}]↓↓↓---------------------------------------------------${cend} \n"
    for x in ${evs_snapshot_array[@]}; do kubectl apply -f ${x}; done;
  fi;

  echo
  printf "${info_msg}The cmd have been executed successfully, please wait for resources be created completely. \n"

  # resize
  if [[ ! ${#pvc2[@]} -eq 0 ]]; then
    printf "${warn_msg}these tests have resize, please execute manually: \n"
    for x in ${pvc2[@]}; do echo "kubectl apply -f ${x}"; done ;
  fi

  # ds2先不管
#   if [[ ! ${#pvc2[@]} -eq 0 ]]; then
#     printf "${warn_msg}these tests have resize, please execute manually: \n"
#     for x in ${pvc2[@]}; do echo "kubectl apply -f ${x}"; done ;
#   fi

}

#####################################################################################
# delete
#####################################################################################
function f_delete() {
  yaml_dir=${1}
  daemonset=${2}

  # 一般
  sc=($(find ${yaml_dir} -name sc.yaml -type f))
  pv=($(find ${yaml_dir} -name pv.yaml -type f))
  pvc=($(find ${yaml_dir} -name pvc.yaml -type f))
  pod=($(find ${yaml_dir} -name pod.yaml -type f))

  # 特殊
  pvc2=($(find ${yaml_dir} -name pvc2.yaml -type f))
  snapshotx=($(find ${yaml_dir} -name snapshotx -type f))

  if [[ ${daemonset} == ${kt_ds} ]]; then
    ds=($(find ${yaml_dir} -name ds.yaml -type f))
   # ds2=($(find ${yaml_dir} -name ds2.yaml -type f)) # 目前先不管ds2的情况
  fi

  if [[ ${#pod[@]} != 0 && ${daemonset} == "" ]]; then
    printf "${info_msg}${font_green1}[${k8s_pod}]↓↓↓---------------------------------------------------------${cend} \n"
    for x in ${pod[@]};
    do {
        kubectl delete -f ${x}
    }&
    done
    wait > /dev/null 2>&1
  elif [[ ${#ds[@]} != 0 && ${daemonset} == ${kt_ds} ]]; then
    printf "${info_msg}${font_green1}[${k8s_daemonset2}]↓↓↓--------------------------------------------------${cend} \n"
    for x in ${ds[@]};
    do {
        kubectl delete -f ${x}
    }&
    done
    wait > /dev/null 2>&1
  fi

  if [[ ! ${#pvc[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_pvc}]↓↓↓---------------------------------------------------------${cend} \n"
    for x in ${pvc[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#pvc2[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_pvc2}]↓↓↓--------------------------------------------------------${cend} \n"
    for x in ${pvc2[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#sc[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_sc}]↓↓↓----------------------------------------------------------${cend} \n"
    for x in ${sc[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#pv[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_pv}]↓↓↓----------------------------------------------------------${cend} \n"
    for x in ${pv[@]}; do kubectl delete -f ${x}; done;
  fi;

  if [[ ! ${#snapshotx[@]} -eq 0 ]]; then
    printf "${info_msg}${font_green1}[${k8s_snapshotx}]↓↓↓---------------------------------------------------${cend} \n"
    for x in ${snapshotx[@]}; do kubectl delete -f ${x}; done;
  fi;

  echo
  printf "${info_msg}The cmd have been executed successfully, please wait for resources be deleted completely. \n"
}

#####################################################################################
# watch
#####################################################################################
function f_watch() {
  f_validate_cmd ${kt_build} ${operate2} ${operate3}
  valid=$?
  if [[ ${valid} = 0 ]]; then return; fi
  case ${1} in
    ${k8s_pod} ) watch -n 1 -d kubectl get pod -o wide;;
    ${k8s_pvc} ) watch -n 1 -d kubectl get pvc ;;
    ${k8s_pv} )  watch -n 1 -d kubectl get pv ;;

    ${k8s_deployment} )   watch -n 1 -d kubectl get deployment ;;
    ${k8s_deployment2} )  watch -n 1 -d kubectl get deployment ;;
    ${k8s_daemonset1} )   watch -n 1 -d kubectl get daemonset ;;
    ${k8s_daemonset2} )   watch -n 1 -d kubectl get daemonset ;;
    ${k8s_service1} )  watch -n 1 -d kubectl get service ;;
    ${k8s_service2} )  watch -n 1 -d kubectl get service ;;
    ${k8s_sc} )  watch -n 1 -d kubectl get sc ;;

    ${k8s_node} )  watch -n 1 -d kubectl get node ;;

    # watch cmd help
    ${kt_help3}) f_watch_help ;;
  esac
}

#####################################################################################
# update
#####################################################################################

# f_update_help 检查是否有对应服务的Deployment和DaemonSet
# 参数1: 服务名[Required]
function f_update_precheck() {
    serviceName=${1}
    depName="csi-${serviceName}-controller"
    dsName="csi-${serviceName}-plugin"

    # 检查有没有配置 docker user 这个环境变量
    if [[  ${kt_docker_user} == "" ]]; then
        printf "${err_msg} the variable 'kt_docker_user' is empty, please reference Readme.md to config \n"
        return ${no_ok}
    fi

    # 检查有没有 kubectl 这个命令
    if ! command -v kubectl >/dev/null 2>&1 ; then
        printf "${err_msg}failed to execute 'kubectl', please install manually and retry \n"
        return ${no_ok}
    fi

    # 检查有没有对应的 deployment【if中的=0，就是这条命令没有报错，正常退出。即exit with 0】
    kubectl get deployment ${depName} >/dev/null 2>&1
    if [ $? ! -eq 0 ]; then
        printf "${err_msg} deployment: ${depName} not exist! \n"
        return ${no_ok}
    fi

    # 检查有没有对应的 daemonset
    kubectl get daemonset ${dsName} >/dev/null 2>&1
    if [ $? ! -eq 0 ]; then
        printf "${err_msg} daemonset: ${dsName} not exist! \n"
        return ${no_ok}
    fi

    return ${ok}
}

# f_update_get_latest 用于获取 ${kt_docker_user} 这个人的某个仓库下，latest的image
# 参数1: 服务名[Required]
latestTag=""
function f_update_get_latest() {
    serviceName=${1}
    latestTag=$(curl -s "https://hub.docker.com/v2/repositories/${kt_docker_user}/${serviceName}-csi-plugin/tags?page_size=100" \
      | jq -r ".results[].name" \
      | sort -V \
      | tail -n 1)

    printf "${info_msg} latest image version: ${serviceName}:${latestTag} \n"
}

# f_update_deployment 修改deployment
# 参数1: 服务名[Required]
# 参数2: 新的版本号[Required]
function f_update_deployment() {
  # 1、获取函数参数
  serviceName=${1}
  newVersion=${2}

  # 2、变量定义
  oldImageNamePrefix1="swr.cn-north-4.myhuaweicloud.com/k8s-csi/${serviceName}-csi-plugin"
  oldImageNamePrefix2="${kt_docker_user}/${serviceName}-csi-plugin"
  newImageName="${kt_docker_user}/${serviceName}-csi-plugin:${new_version}"
  directoryPath="/tmp/csi-${serviceName}"
  tmpFileName="/tmp/csi-${serviceName}/${serviceName}-tmp-deployment.yaml"

  # 3、检查目录是否存在，不存在就创建
  if [[ ! -d ${directoryPath} ]]; then
    mkdir -p ${directoryPath}
  fi

  # 4、导出deployment的yaml
  kubectl get deployment "csi-${serviceName}-controller" -n "kube-system" -o yaml > ${tmpFileName}

  # 5、替换以指定前缀开头的 image 字段
  sed -i "s|image: ${oldImageNamePrefix1}.*|image: ${newImageName}|" ${tmpFileName}
  sed -i "s|image: ${oldImageNamePrefix2}.*|image: ${newImageName}|" ${tmpFileName}
  sleep 1

  # 6、清理, 文件和目录同时删除
  kubectl apply -f ${tmpFileName}
  rm -rf ${directoryPath}
}

# f_update_daemonset 修改daemonset
# 参数1: 服务名[Required]
# 参数2: 新的版本号[Required]
function f_update_daemonset() {
  # 1、获取函数参数
  serviceName=${1}
  newVersion=${2}

  # 2、变量定义
  oldImageNamePrefix1="swr.cn-north-4.myhuaweicloud.com/k8s-csi/${serviceName}-csi-plugin"
  oldImageNamePrefix2="${kt_docker_user}/${serviceName}-csi-plugin"
  newImageName="${kt_docker_user}/${serviceName}-csi-plugin:${new_version}"
  directoryPath="/tmp/csi-${serviceName}"
  tmpFileName="/tmp/csi-${serviceName}/${serviceName}-tmp-daemonset.yaml"

  # 3、检查目录是否存在，不存在就创建
  if [[ ! -d ${directoryPath} ]]; then
    mkdir -p ${directoryPath}
  fi

  # 4、导出 daemonset 的yaml
  kubectl get daemonset "csi-${serviceName}-plugin" -n "kube-system" -o yaml > ${tmpFileName}

  # 5、替换以指定前缀开头的 image 字段
  sed -i "s|image: ${oldImageNamePrefix1}.*|image: ${newImageName}|" ${tmpFileName}
  sed -i "s|image: ${oldImageNamePrefix2}.*|image: ${newImageName}|" ${tmpFileName}
  sleep 1

  # 6、清理, 文件和目录同时删除
  kubectl apply -f ${tmpFileName}
  rm -rf ${directoryPath}
}

# f_update_obs 更新obs的deployment和daemonSet
# 参数1: 新的版本号[Optional]
function f_update_obs() {
  # 1、修改前预检查
  f_update_precheck ${service_obs}
  valid=$?
  if [[ ${valid} = ${no_ok} ]]; then return; fi

  # 2、获取最新version。
  # 如果用户手动输入了，那就用用户输入的
  # 如果用户没有输入，那就去docker获取最新的
  new_version=${1}
  if [[ -z ${new_version} ]]; then
    f_update_get_latest ${service_obs}
    new_version=${latestTag}
  fi

  # 3、更新 deployment 和 daemonset
  f_update_deployment ${service_obs} ${new_version}
  f_update_daemonset  ${service_obs} ${new_version}

  printf "${info_msg} command executed successfully! please wait 5s to check workload status \n"
}

# f_update_evs 更新evs的deployment和daemonSet
# 参数1: 新的版本号[Optional]
function f_update_evs() {
  # 1、修改前预检查
  f_update_precheck ${service_evs}
  valid=$?
  if [[ ${valid} = ${no_ok} ]]; then return; fi

  # 2、获取最新version。
  # 如果用户手动输入了，那就用用户输入的
  # 如果用户没有输入，那就去docker获取最新的
  new_version=${1}
  if [[ -z ${new_version} ]]; then
    f_update_get_latest ${service_evs}
    new_version=${latestTag}
  fi

  # 3、更新 deployment 和 daemonset
  f_update_deployment ${service_evs} ${new_version}
  f_update_daemonset  ${service_evs} ${new_version}

  printf "${info_msg} command executed successfully! please wait 5s to check workload status \n"
}

# f_update_sfsturbo 更新sfs-turbo的deployment和daemonSet
# 参数1: 新的版本号[Optional]
function f_update_sfsturbo() {
  # 1、修改前预检查
  f_update_precheck ${service_sfsturbo}
  valid=$?
  if [[ ${valid} = ${no_ok} ]]; then return; fi

  # 2、获取最新version。
  # 如果用户手动输入了，那就用用户输入的
  # 如果用户没有输入，那就去docker获取最新的
  new_version=${1}
  if [[ -z ${new_version} ]]; then
    f_update_get_latest ${service_sfsturbo}
    new_version=${latestTag}
  fi

  # 3、更新 deployment 和 daemonset
  f_update_deployment ${service_sfsturbo} ${new_version}
  f_update_daemonset  ${service_sfsturbo} ${new_version}

  printf "${info_msg} command executed successfully! please wait 5s to check workload status \n"
}

#####################################################################################
# build
#####################################################################################
function f_build_evs() {
  dir="${kt_code_path}/${repo_csi_all}"
  printf "${info_msg}${font_green1}make images↓↓↓${cend} \n"
  (cd ${dir} && VERSION=${1} make image-evs-csi-plugin)
  printf "${info_msg}${font_green1}push images↓↓↓${cend} \n"
  (cd ${dir} && VERSION=${1} make push-image-evs-csi-plugin)
}

function f_build_obs() {
  dir="${kt_code_path}/${repo_csi_all}"
  printf "${info_msg}${font_green1}make images↓↓↓${cend} \n"
  (cd ${dir} && VERSION=${1} make image-obs-csi-plugin)
  printf "${info_msg}${font_green1}push images↓↓↓${cend} \n"
  (cd ${dir} && VERSION=${1} make push-image-obs-csi-plugin)
}

function f_build_sfs_turbo() {
  dir="${kt_code_path}/${repo_csi_all}"
  printf "${info_msg}${font_green1}make images↓↓↓${cend} \n"
  (cd ${dir} && VERSION=${1} make image-sfsturbo-csi-plugin)
  printf "${info_msg}${font_green1}push images↓↓↓${cend} \n"
  (cd ${dir} && VERSION=${1} make push-image-sfsturbo-csi-plugin)
}


#####################################################################################
# install
#####################################################################################
function f_install_evs() {
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-node.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-node.yaml
}

function f_install_obs() {
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-node.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-node.yaml
}

function f_install_sfs_turbo() {
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-node.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-node.yaml
}

#####################################################################################
# uninstall
#####################################################################################
function f_uninstall_evs() {
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-node.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/rbac-csi-evs-secret.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-driver.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/evs-csi-plugin/kubernetes/csi-evs-node.yaml
}

function f_uninstall_obs() {
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-node.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/rbac-csi-obs-secret.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-driver.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/obs-csi-plugin/kubernetes/csi-obs-node.yaml
}

function f_uninstall_sfs_turbo() {
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-node.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/rbac-csi-sfsturbo-secret.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-driver.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/huaweicloud/huaweicloud-csi-driver/master/deploy/sfsturbo-csi-plugin/kubernetes/csi-sfsturbo-node.yaml
}

