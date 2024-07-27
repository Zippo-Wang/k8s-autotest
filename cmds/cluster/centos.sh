#!/usr/bin/env bash

tmpdir=/tmp/build-k8s_abcde

f_centos_main() {
    mkdir /tmp/build-k8s_abcde

    f_centos_check_jq
    f_check_ok_code ${?} "check jq tool"

    f_get_config ${clusterConfigFilePath}
    f_check_ok_code ${?} "get cluster config"

#     f_centos_change_os_mirror
#     f_check_ok_code ${?} "change os mirror"

#     f_centos_install_common_cmd
#     f_check_ok_code ${?} "install common cmd"

#     f_centos_config_env
#     f_check_ok_code ${?} "config os environment"

#     f_centos_install_docker
#     f_check_ok_code ${?} "install docker"


}

# 解析cluster-config用的一个命令
f_centos_check_jq() {
    if ! command -v jq &> /dev/null; then
        printf "${info_msg}你的OS中没有jq工具，即将开始安装 \n"
        sudo yum install -y epel-release
        sudo yum install -y jq
    fi
    if ! command -v jq &> /dev/null; then
        printf "${err_msg}安装失败，请手动安装 \n"
        return 0
    fi
    return 1
}

f_centos_change_os_mirror() {
    sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    sudo cp ${kt_project_path}/pkg/CentOS7_Aliyun.repo /etc/yum.repos.d/CentOS-Base.repo
    sudo yum clean all
    sudo yum makecache
    return 1
}

f_centos_install_common_cmd() {
   (cd ${tmpdir} && sudo yum -y update)

    cmds=("gcc" "gcc-c++" "vim*" "git")
    for c in ${cmds[@]};
    do
        if ! command -v ${c} >/dev/null 2>&1; then
            (cd ${tmpdir} && sudo yum -y install ${c})
        fi
    done
    return 1
}

# TODO: 这个地方写死了
f_centos_config_env() {
    echo '
# ssh 不断开
export TMOUT=0

# packer
export PATH=$PATH:/usr/local/bin
export HW_DEBUG=1
export PACKER_LOG=1
export PACKER_LOG_PATH="/root/logs/packer.log"

# k8s csi env
export REGISTRY_SERVER=""
export REGISTRY="zippowang"


# go env
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GOPATH=/root/code


# k8s-autotest
export kt_project_path="/root/code/k8s-autotest"
export kt_code_path="/root/code"
export kt_main='kt'
alias kt="source $kt_project_path/main/main.sh"

# cc
export PATH=$PATH:/root/code

' >> /etc/profile
    return 1
}

f_centos_install_docker() {
    (cd ${tmpdir} && curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun)
    echo ${docker_mirror} >> /etc/default/docker
    echo "DOCKER_OPTS"=\"--${t_docker_mirror}\" >> /home/huawei/my_scripts/test.txt
    systemctl restart docker
    return 1
}
