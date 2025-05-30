#!/usr/bin/env bash

source ${kt_project_path}/main/constants.sh

function progress_bar() {
    local total=50      # 进度条长度
    local steps=5       # 进度更新的次数
    local task_func=$1  # 要执行的任务函数

    for ((i=1; i<=steps; i++)); do
        $task_func
        filled=$((i * total / steps))
        bar=$(printf "%-${total}s" "#" | sed "s/ /#/g" | cut -c1-$filled)
        printf "\r[%-${total}s] %d%%" "$bar" $((i * 100 / steps))
    done
    echo
}

# f_check_os_type 用来判断OS是哪种类型
# centos:1  ubuntu:2    debian:3    fedora:4    euler:5
function f_check_os_type() {
  if grep -i -q "EulerOS" /etc/os-release; then
    # EulerOS
    return 5
  elif [ -f "/etc/redhat-release" ]; then
    # CentOS or RHEL or EulerOS
    if grep -i -q "CentOS" /etc/redhat-release; then
      return 1
    elif grep -i -q "Fedora" /etc/redhat-release; then
      return 4
    elif grep -i -q "EulerOS" /etc/redhat-release; then
      return 5
    fi
  elif [ -f "/etc/issue" ]; then
    # Ubuntu or Debian or Euler
    if grep -i -q "ubuntu" /etc/issue; then
      return 2
    elif grep -i -q "debian" /etc/issue; then
      return 3
    elif grep -i -q "Euler" /etc/os-release; then
      return 5
    fi
  elif [ -f "/etc/fedora-release" ]; then
    # Fedora
    if grep -i -q "Fedora" /etc/fedora-release; then
      return 4
    fi
  else
    # unknown OS
    return 0
  fi
}

# f_check_os_supported 判断你的OS支不支持kt系统
function f_check_os_supported() {
  if [ ${1} = 0 ]; then
    printf "${err_msg}你的系统不支持k8s-autotest \n"
    return 0
  fi
  return 1
}

# f_check_env_vars 检查你配环境变量了不，不配不让用
function f_check_env_vars() {
  if [ -z ${kt_project_path} ]; then
    printf "${err_msg}环境变量'kt_project_path'为空, 请参考readme.md配置 \n"
    return 0
  elif [ -z ${kt_main} ]; then
    printf "${err_msg}环境变量'kt_main'为空, 请参考readme.md配置 \n"
    return 0
  elif [ -z "$(alias kt 2>/dev/null)" ]; then
    printf "${err_msg}环境变量'alias kt'为空, 请参考readme.md配置 \n"
    return 0
  fi
  return 1
}

# f_pre_check 脚本启动预检查
function f_pre_check() {
  # 1、检查os类型
  f_check_os_type

  # 2、检查os是否支持该脚本
  osCode=$?
  f_check_os_supported osCode
  isSupported=$?
  if [[ ${isSupported} == 0 ]]; then return 0; fi

  # 3、检查环境变量配置好了没
  f_check_env_vars
  haveRightEnvVars=$?
  if [[ ${haveRightEnvVars} == 0 ]]; then return 0; fi
  return 1
}

# 系统初始化必备步骤，不执行初始化就不能用自动补全，而且换行符还有可能有一些问题
function f_init() {
  # 修改换行符
  printf "${info_msg}"
  for file in `find ${kt_project_path} -name *.sh -type f`;
  do
      sed -i 's/\r$//' ${file}
  done
  
  # 判断系统是否支持bash_completion
  script_directory="/etc/bash_completion.d/"      # 存放脚本的目录
  env_directory="/usr/share/bash-completion/bash_completion"  # 使脚本生效的目录

  if [ ! -f ${env_directory} ]; then yum install bash-completion -y ; fi

  if [ ! -d ${script_directory} ]
  then
    printf "${warn_msg}该目录不存在, 您的Linux系统不支持使用该脚本的自动补全功能, 但不影响脚本使用。${script_directory} \n"
  fi

  # 如果支持, 就写入自动补全脚本
  if sudo -v &>/dev/null;
  then
    sudo cp ${kt_project_path}/utils/auto_tab.sh /etc/bash_completion.d/kt_auto_tab
    . ${env_directory}  # 刷新自动补全的环境配置, 使立即生效
    printf "${info_msg}${font_green1}k8s-autotest初始化成功, 请重新打开终端窗口使配置生效！${cend}\n"
  else
    printf "${err_msg}${font_red1}sudo密码不正确, 初始化失败！${cend}\n"
  fi
}

# 适用create、delete、install、uninstall、watch
function f_validate_cmd() {
  if [[ -z ${2} ]]; then
    printf "${err_msg}${1}后面必须跟有一个参数, 使用${font_green1}kt ${1} --help${cend}查看使用帮助 \n"
    return ${no_ok}
  fi
  if [[ ${3} == ${kt_ds} ]]; then
    return ${ok}
  fi

  if [[ ! -z ${3} ]]; then
    printf "${err_msg}没有这个命令: ${kt} $* \n"
    return ${no_ok}
  fi
  return ${ok}
}

# 适用build
function f_validate_build_cmd() {
  if [[ ${2} == ${kt_help3} && -z ${3} ]]; then return 1; fi
  if [ -z ${3} ]; then
    printf "${err_msg}${1}后面必须跟有2个参数, 使用${font_green1}kt ${1} --help${cend}查看使用帮助 \n"
    return 0
  fi
  if [ ! -z ${4} ]; then
    printf "${err_msg}没有这个命令: ${kt} $* \n"
    return 0
  fi
  return 1
}

# 适用config
function f_validate_config_cmd() {
  if [[ ${2} == ${kt_help3} && -z ${3} ]]; then return 1; fi

  if [ -z ${2} ]; then
    printf "${err_msg}${1}后面必须跟有1个参数, 使用${font_green1}kt ${1} --help${cend}查看使用帮助 \n"
    return 0
  fi

  if [ ! -z ${3} ]; then
    printf "${err_msg}没有这个命令: ${kt} $* \n"
    return 0
  fi
  return 1
}
