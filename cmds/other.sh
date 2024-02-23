#!/usr/bin/env bash

source ${kt_project_path}/script/constants.sh

function f_init() {
  for file in `find ${kt_project_path} -name *.sh -type f`; do vi $file -c 'set ff=unix | wq!'; done

  # 判断系统是否支持bash_completion
  script_directory="/etc/bash_completion.d/"      # 存放脚本的目录
  env_directory="/usr/share/bash-completion/bash_completion"  # 使脚本生效的目录

  if [ ! -f ${env_directory} ]; then yum install bash-completion -y ; fi

  if [ ! -d ${script_directory} ]
  then
    echo "该目录不存在，您的Linux系统不支持使用该脚本的自动补全功能，但不影响脚本使用。${script_directory}"
  fi

  # 如果支持，就写入自动补全脚本
  if sudo -v &>/dev/null;
  then
    sudo cp ${kt_project_path}/utils/auto_tab.sh /etc/bash_completion.d/hh_auto_tab
    . ${env_directory}  # 刷新自动补全的环境配置，使立即生效
    printf "${font_green1}k8s-autotest初始化成功，请重新打开终端窗口使配置生效！${cend}\n"
  else
    printf "${font_red1}sudo密码不正确，初始化失败！${cend}\n"
  fi
}


function f_help() {
  printf "${font_yellow1}【一】Usage: kt <cmd1> <cmd2> ${cend}\n"
  printf "初次运行系统，请阅读${font_green1}Readme.md${cend}配置环境变量，然后进行初始化 \n"
  printf " ${font_green1}${common_init}${cend}         ${font_blue1}系统初始化${cend}。初次运行系统，请先进行初始化 \n"
  printf " ${font_green1}${kt_help1}${cend}         查看k8s-autotest使用帮助 \n"
  printf " ${font_green1}tab${cend}          ${font_blue1}自动补全${cend}。按tab键即可自动补全本系统支持的所有命令 \n"
  echo

  printf "${font_yellow1}【二】[create][delete] ${cend}\n"
  printf " ${font_green1}${service_evs}${cend} \t      执行evs用例 或 删除evs用例创建的对象\n"
  printf " ${font_green1}${service_obs}${cend} \t      执行obs用例 或 删除obs用例创建的对象\n"
  printf " ${font_green1}${service_sfs_turbo}${cend}    执行sfs-turbo用例 或 删除sfs-turbo用例创建的对象\n"
  echo

  printf "${font_yellow1}【三】[watch] ${cend}\n"
  printf " ${font_green1}${k8s_pod}${cend} \t      执行watch -n 1 -d kubectl get pod\n"
  printf " ${font_green1}${k8s_pvc}${cend} \t      执行watch -n 1 -d kubectl get pvc\n"
  printf " ${font_green1}${k8s_pv}${cend}  \t      执行watch -n 1 -d kubectl get pv\n"
}
