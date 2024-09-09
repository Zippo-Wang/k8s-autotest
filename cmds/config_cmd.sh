#!/usr/bin/env bash

function f_config_clear() {
    env_dir="/etc/profile"
    script_dir="/root/scripts"

    if [[ ! -d ${script_dir} ]] ; then
        sudo mkdir ${script_dir}
    fi

    sudo touch ${script_dir}/c
    sudo chmod 777 -R ${script_dir}

sudo cat <<EOF>> ${script_dir}/c
clear
clear
clear
clear
clear

EOF

    echo 'export PATH=$PATH:/root/scripts' >> ${env_dir}
    source ${env_dir}
    printf "${info_msg}命令执行成功, 敲一个小写的${font_green}c${cend}试试 \n"
}

function f_config_cloud_config() {
    default_dir="/root/build-k8s/cloud-config"
    cloud_config_dir=${1}

    # 判断有没有指定 cloud-config 的路径
    if [[ -z ${cloud_config_dir} ]]; then
        printf "${info_msg}未指定cloud-config具体路径, 将使用默认路径: ${default_dir} \n"
        cloud_config_dir=${default_dir}
    fi

    # 判断传入的路径是否有cloud-config
    if [[ ! -e ${cloud_config_dir} ]]; then
       printf "${err_msg}该路径下不存在cloud-config: ${cloud_config_dir} \n"
       return 0
    fi

    printf "${info_msg}执行: kubectl create secret -n kube-system generic cloud-config --from-file=${cloud_config_dir} \n"
    kubectl create secret -n kube-system generic cloud-config --from-file=${cloud_config_dir}
    printf "${info_msg}执行完成, 查看是否创建成功: kubectl get secret -n kube-system \n"
}
