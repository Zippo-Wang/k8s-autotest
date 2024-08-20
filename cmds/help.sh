#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh


function f_help() {
  printf "${font_yellow1}Usage: kt <cmd1> <cmd2> ${cend}\n"
  printf " ${font_green1}${common_init}${cend}         ${font_blue1}系统初始化${cend}\n"
  printf " ${font_green1}tab${cend}          ${font_blue1}自动补全。${cend}按tab键即可自动补全本系统支持的所有命令 \n"
  printf " ${font_green1}${kt_help1}${cend}         查看k8s-autotest使用帮助 \n"
  printf " ${font_green1}${kt_help3}${cend}       查看某个命令具体使用帮助。 ${flash_light}${font_blue1}示例: kt create --help${cend} \n"
  echo

  printf " ${font_green1}install${cend}      ${font_blue1}安装插件${cend} \n"
  printf " ${font_green1}uninstall${cend}    ${font_blue1}卸载插件${cend} \n"
  printf " ${font_green1}create${cend}       ${font_blue1}执行用例，创建资源${cend} \n"
  printf " ${font_green1}delete${cend}       ${font_blue1}删除用例创建的资源${cend} \n"
  printf " ${font_green1}build${cend}        ${font_blue1}打包推送，或创建集群${cend} \n"
  printf " ${font_green1}watch${cend}        ${font_blue1}监控资源${cend} \n"
  echo
}

function f_install_uninstall_help() {
  printf "${font_yellow1}[install][uninstall]。安装鉴权和插件，或卸载鉴权和插件【不含cloud-config】 ${cend}\n"
  printf "${font_yellow1}可选参数: ${cend}\n"
  printf " ${font_green1}${service_evs}${cend} \t      安装evs鉴权和插件 或 卸载evs鉴权和插件【不含cloud-config】\n"
  printf " ${font_green1}${service_obs}${cend} \t      安装obs鉴权和插件 或 卸载obs鉴权和插件【不含cloud-config】 \n"
  printf " ${font_green1}${service_sfs_turbo}${cend}     安装sfsturbo鉴权和插件 或 卸载sfsturbo鉴权和插件【不含cloud-config】\n"
  printf " ${font_green1}${plugin_ccm}${cend}  \t      安装ccm鉴权和插件 或 卸载ccm鉴权和插件【不含cloud-config和lb-config】\n"
  echo
}

function f_create_delete_help() {
  printf " ${font_yellow1}[create][delete] 执行所有用例，或删除所有用例创建的对象${cend}\n"
  printf " ${font_yellow1}可选参数: ${cend}\n"
  printf " ${font_green1}${service_evs}${cend} \t\t       执行evs${font_blue1}所有${cend}用例 或 删除evs所有用例创建的对象\n"
  printf " ${font_green1}${evs_default}${cend} \t       执行evs default用例 或 删除evs default用例用例创建的对象\n"
  printf " ${font_green1}${evs_parameter}${cend}         执行evs parameter用例 或 删除evs parameter用例创建的对象\n"
  printf " ${font_green1}${evs_deny_resize}${cend}       执行evs deny_resize用例 或 删除evs deny_resize用例创建的对象\n"
  printf " ${font_green1}${evs_allow_resize}${cend}      执行evs allow_resize用例 或 删除evs allow_resize用例创建的对象\n"
  printf " ${font_green1}${evs_snapshot}${cend} \t       执行evs snapshot用例 或 删除evs snapshot用例创建的对象\n"
  printf " ${font_green1}${evs_rwo}${cend} \t       执行evs rwo用例 或 删除evs rwo用例创建的对象。${font_blue1}rwo: ReadWriteOnce${cend}\n"
  printf " ${font_green1}${evs_rwx}${cend} \t       执行evs rwx用例 或 删除evs rwx用例创建的对象。${font_blue1}rwx: ReadWriteMany${cend}\n"
  echo

  printf " ${font_yellow1}[obs]支持部署DaemonSet，如: kt create obs-default --ds ${cend}\n"
  printf " ${font_green1}${service_obs}${cend} \t\t       执行obs${font_blue1}所有${cend}用例 或 删除obs所有用例创建的对象\n"
  printf " ${font_green1}${obs_default}${cend} \t       执行obs default用例 或 删除obs default用例创建的对象\n"
  printf " ${font_green1}${obs_parameter}${cend} \t       执行obs parameter用例 或 删除obs parameter用例创建的对象\n"
  printf " ${font_green1}${obs_exist}${cend} \t       执行obs exist用例 或 删除obs exist用例创建的对象\n"
  printf " ${font_green1}${obs_encryption}${cend}        执行obs encryption用例 或 删除obs encryption用例创建的对象\n"
  echo

  printf " ${font_green1}${service_sfs_turbo}${cend} \t       执行sfsturbo${font_blue1}所有${cend}用例 或 删除sfsturbo所有用例创建的对象\n"
  printf " ${font_green1}${sfs_turbo_default}${cend}      执行sfsturbo default用例 或 删除sfsturbo default用例创建的对象\n"
  printf " ${font_green1}${sfs_turbo_performance}${cend}  执行sfsturbo performance用例 或 删除sfsturbo performance用例创建的对象\n"
  printf " ${font_green1}${sfs_turbo_deny_resize}${cend}  执行sfsturbo deny_resize用例 或 删除sfsturbo deny_resize用例创建的对象\n"
  printf " ${font_green1}${sfs_turbo_allow_resize}${cend} 执行sfsturbo allow_resize用例 或 删除sfsturbo allow_resize用例创建的对象\n"
  printf " ${font_green1}${sfs_turbo_static}${cend}       执行sfsturbo static用例 或 删除sfsturbo static用例创建的对象\n"
  echo

  printf " ${font_green1}${plugin_ccm}${cend} \t\t       执行ccm${font_blue1}所有${cend}用例 或 删除ccm所有用例创建的对象\n"
  printf " ${font_green1}${ccm_default}${cend} \t       执行ccm默认用例 或 删除ccm默认用例创建的对象\n"
  printf " ${font_green1}${ccm_eip}${cend} \t       执行ccm eip用例 或 删除ccm eip用例创建的对象\n"
  printf " ${font_green1}${ccm_affinity}${cend} \t       执行ccm affinity用例 或 删除ccm affinity用例创建的对象\n"
  printf " ${font_green1}${ccm_existing}${cend} \t       执行ccm existing用例 或 删除ccm existing用例创建的对象\n"
  echo
}

function f_build_help() {
  printf "${font_yellow1}[build] ${cend} \n"
  printf "${font_yellow1}用法1: 打包插件推送成docker镜像，并推送到docker hub。${cend}${font_blue1}示例：kt build obs v0.0.2${cend} \n"
  printf "${font_yellow1}用法2: 创建集群。${cend}${font_blue1}示例：kt build cluster /root/cluster-config${cend} \n"
  printf "${font_yellow1}可选参数: ${cend}\n"
  printf " ${font_green1}${service_evs}${cend} \t    打包evs插件成docker镜像，并推送到docker hub \n"
  printf " ${font_green1}${service_obs}${cend} \t    打包obs插件成docker镜像，并推送到docker hub \n"
  printf " ${font_green1}${service_sfs_turbo}${cend}   打包sfsturbo插件成docker镜像，并推送到docker hub \n"
  printf " ${font_green1}${plugin_ccm}${cend}  \t    打包ccm插件成docker镜像，并推送到docker hub \n"
  echo

  #printf " ${font_green1}${cluster}${cend}    构建k8s集群。(需要填写cluster-config的绝对路径) \n"
  #echo
}

function f_watch_help() {
  printf "${font_yellow1}[watch] 监控k8s集群中的资源${cend}\n"
  printf "${font_yellow1}可选参数: ${cend}\n"
  printf " ${font_green1}${k8s_node}${cend}         执行watch -n 1 -d kubectl get node\n"
  printf " ${font_green1}${k8s_deployment}${cend}   执行watch -n 1 -d kubectl get deployment ${font_green} 【支持简写：${k8s_deployment2}】${cend}\n"
  printf " ${font_green1}${k8s_daemonset1}${cend}    执行watch -n 1 -d kubectl get daemonset ${font_green}  【支持简写：ds】${cend} \n"
  printf " ${font_green1}${k8s_pod}${cend} \t      执行watch -n 1 -d kubectl get pod -o wide\n"
  printf " ${font_green1}${k8s_service1}${cend}      执行watch -n 1 -d kubectl get service ${font_green}    【支持简写：svc】${cend} \n"
  printf " ${font_green1}${k8s_pvc}${cend} \t      执行watch -n 1 -d kubectl get pvc ${font_green}\t【不支持：${k8s_pvc_all}】${cend}\n"
  printf " ${font_green1}${k8s_pv}${cend}  \t      执行watch -n 1 -d kubectl get pv ${font_green} \t【不支持：${k8s_pv_all}】${cend}\n"
}

function f_version() {
  printf "k8s-autotest_${sys_current_version} \n"
  echo
  printf "see the link for latest version: https://github.com/Zippo-Wang/k8s-autotest \n"
}
