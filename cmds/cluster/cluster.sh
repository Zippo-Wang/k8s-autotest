#!/usr/bin/env bash

# 全局变量
t_cloud=""
t_k8s_version=""
t_master_ip=""
t_docker_mirror=""
t_node_info=()

t_git_username=""
t_git_email=""
t_code_dir=""
t_github_repos=()

t_dash_port=""
t_dash_user=""

# 程序的总入口
function f_build_cluster(){
  clusterConfigFilePath=${1}
  ok=0 # k8s集群是否搭建成功

  # 1、根据不同的os，去调用不同的主函数
  f_check_os_type
  osCode=$?
  if [[ ${osCode} == 1 ]]; then
    printf "${info_msg}你的OS是CentOS，即将开始搭建集群 \n"
  elif [[ ${osCode} == 2 ]]; then
    printf "${info_msg}你的OS是Ubuntu，即将开始搭建集群 \n"
    printf "${debug_msg}在Ubuntu上测试一把 \n"
    f_centos_main
  elif [[ ${osCode} == 5 ]]; then
    printf "${info_msg}你的OS是EulerOS，即将开始搭建集群 \n"
  elif [[ ${osCode} == 0 || ${osCode} == 3 || ${osCode} == 4 ]]; then
    printf "${err_msg}不支持给你这种OS搭建 \n"
  fi
}

# 必需的一些命令，需要提前安装
function f_required_cmd() {
  echo "xxx"
}

# 从cluster-config中读取入参
function f_get_config(){
    clusterConfigFile=${1}

    if [[ ! -f ${clusterConfigFile} ]]; then
        printf "${err_msg}配置文件${clusterConfigFile}不存在 \n"
        return 0
    fi

    declare -A config_map
    current_section=""

    # 解析配置文件
    while IFS= read -r line || [[ -n "$line" ]]; do
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # 跳过空行和注释行
        if [[ -z "$line" || "$line" == \#* ]]; then
            continue
        fi

        # 解析段名
        if [[ "$line" == \[*\] ]]; then
            current_section=$(echo "$line" | sed 's/\[\(.*\)\]/\1/')
            continue
        fi

        # 解析键值对
        if [[ "$line" == *"="* ]]; then
            key=$(echo "$line" | cut -d '=' -f 1)
            value=$(echo "$line" | cut -d '=' -f 2-)

            if [[ "$key" == "node_info" ]]; then
                node_info_json="$value"
                node_info_pairs=$(echo "$node_info_json" | jq -r 'to_entries | .[] | "\(.key):\(.value)"')
                while IFS= read -r pair; do
                    t_node_info+=("$pair")
                done <<< "$node_info_pairs"
            elif [[ "$key" == "github_repos" ]]; then
                # 解析数组格式的github_repos
                github_repos=$(echo "$value" | jq -r '.[]')
                IFS=$'\n' read -d '' -r -a t_github_repos <<< "$github_repos"
            else
                # 其他普通变量
                config_map[$key]=${value}
            fi
        fi
    done < "${clusterConfigFile}"

    # 获取变量
    for key in "${!config_map[@]}"; do
        echo "$key: ${config_map[$key]}"
        if [[ ${key} == ${cloud_name} ]]; then t_cloud=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${k8s_version} ]]; then t_k8s_version=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${master_ip} ]]; then t_master_ip=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${docker_mirror} ]]; then t_docker_mirror=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${git_username} ]]; then t_git_username=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${git_email} ]]; then t_git_email=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${code_dir} ]]; then t_code_dir=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${dash_port} ]]; then t_dash_port=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
        if [[ ${key} == ${dash_user} ]]; then t_dash_user=$(echo ${config_map[${key}]} | sed 's/"//g'); fi
    done

    # 检查某些参数是否需要依赖其他参数
    # 1. Required字段
    if [[ ! -n ${t_cloud} ]]; then printf "${err_msg}${cloud_name}不能为空 \n"; return 0; fi
    if [[ ! -n ${t_k8s_version} ]]; then printf "${err_msg}${k8s_version}不能为空 \n"; return 0; fi
    if [[ ! -n ${t_master_ip} ]]; then printf "${err_msg}${master_ip}不能为空 \n"; return 0; fi

    # 2. git字段
    if [[ -n ${t_code_dir} ]]; then
        if [[ ! -n ${t_git_username} ]]; then printf "${err_msg}${git_username}不能为空 \n"; return 0; fi
        if [[ ! -n ${t_git_email} ]]; then printf "${err_msg}${t_git_email}不能为空 \n"; return 0; fi
    fi
    if [[ ! ${#github_repos_array[@]} -eq 0 ]]; then
        if [[ ! -n ${t_git_username} ]]; then printf "${err_msg}${git_username}不能为空 \n"; return 0; fi
        if [[ ! -n ${t_git_email} ]]; then printf "${err_msg}${git_email}不能为空 \n"; return 0; fi
        if [[ ! -n ${t_code_dir} ]]; then printf "${err_msg}${code_dir}不能为空 \n"; return 0; fi
    fi

    # 3. dashboard
    if [[ -n ${t_dash_user} ]]; then
        if [[ ! -n ${t_dash_port} ]]; then printf "${err_msg}${dash_port}不能为空 \n"; return 0; fi
    fi

    return 1
}

function f_check_ok_code() {
  if [[ ${1} == 1 ]]; then
    printf "${info_msg}[${2}]执行成功！ \n"
    return 1
  elif [[ ${1} == 0 ]]; then
    printf "${err_msg}[${2}]执行失败... \n"
    exit 0
  fi

  printf "${err_msg}[${2}]执行失败..., 未知状态码:code=${1} \n"
  exit 0
}

function f_check_cmd_installed() {
    if command -v ${1} >/dev/null 2>&1; then return 0; else return 1; fi
}

function f_ssh() {
    ssh ${1}
}

