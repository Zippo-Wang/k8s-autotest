#!/bin/bash

source ${kt_project_path}/main/constants.sh


CONFIG_FILE="/home/huawei/my_scripts/cluster-config"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "配置文件 $CONFIG_FILE 不存在"
    exit 1
fi

declare -A config_map
declare -a node_info_array
declare -a github_repos_array
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
            # 解析JSON格式的node_info
            node_info_json="$value"
            node_info_pairs=$(echo "$node_info_json" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"')
            while IFS= read -r pair; do
                node_info_array+=("$pair")
            done <<< "$node_info_pairs"
        elif [[ "$key" == "github_repos" ]]; then
            # 解析数组格式的github_repos
            github_repos=$(echo "$value" | jq -r '.[]')
            IFS=$'\n' read -d '' -r -a github_repos_array <<< "$github_repos"
        else
            # 其他普通变量
            config_map["$key"]="$value"
        fi
    fi
done < "$CONFIG_FILE"

# 打印变量（用于调试）
t_cloud="cloud"
t_k8s_version="k8s_version"
t_master_ip="master_ip"
t_docker_mirror="docker_mirror"
t_git_username="git_username"
t_git_email="git_email"
t_code_dir="code_dir"
t_dash_port="dash_port"
t_dash_user="dash_user"
for key in "${!config_map[@]}"; do
    echo "$key: ${config_map[$key]}"
    if [[ ${key} == ${cloud_name} ]]; then t_cloud=${config_map[${key}]}; fi
    if [[ ${key} == ${k8s_version} ]]; then t_k8s_version=${config_map[${key}]}; fi
    if [[ ${key} == ${master_ip} ]]; then t_master_ip=${config_map[${key}]}; fi
    if [[ ${key} == ${docker_mirror} ]]; then t_docker_mirror=${config_map[${key}]}; fi
    if [[ ${key} == ${git_username} ]]; then t_git_username=${config_map[${key}]}; fi
    if [[ ${key} == ${git_email} ]]; then t_git_email=${config_map[${key}]}; fi
    if [[ ${key} == ${code_dir} ]]; then t_code_dir=${config_map[${key}]}; fi
    if [[ ${key} == ${dash_port} ]]; then t_dash_port=${config_map[${key}]}; fi
    if [[ ${key} == ${dash_user} ]]; then t_dash_user=${config_map[${key}]}; fi
done

# 检查某些参数是否需要依赖其他参数
# 1. Required字段
if [[ ! -n ${t_cloud} ]]; then printf "${err_msg}${cloud_name}不能为空 \n"; fi
if [[ ! -n ${t_k8s_version} ]]; then printf "${err_msg}${k8s_version}不能为空 \n"; fi
if [[ ! -n ${t_master_ip} ]]; then printf "${err_msg}${master_ip}不能为空 \n"; fi

# 2. git字段
if [[ -n ${t_code_dir} ]]; then
    if [[ ! -n ${t_git_username} ]]; then printf "${err_msg}${git_username}不能为空 \n"; fi
    if [[ ! -n ${t_git_email} ]]; then printf "${err_msg}${t_git_email}不能为空 \n"; fi
fi
if [[ ! ${#github_repos_array[@]} -eq 0 ]]; then
    if [[ ! -n ${t_git_username} ]]; then printf "${err_msg}${git_username}不能为空 \n"; fi
    if [[ ! -n ${t_git_email} ]]; then printf "${err_msg}${git_email}不能为空 \n"; fi
    if [[ ! -n ${t_code_dir} ]]; then printf "${err_msg}${code_dir}不能为空 \n"; fi
fi

# 3. dashboard
if [[ -n ${t_dash_user} ]]; then
    if [[ ! -n ${t_dash_port} ]]; then printf "${err_msg}${dash_port}不能为空 \n"; fi
fi

echo ${node_info_array[@]}
echo ${github_repos_array[@]}
