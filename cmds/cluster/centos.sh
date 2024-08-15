#!/bin/bash

input_type=""
input_version=""
input_master=""
input_node=()
input_password=()
input_dashboard_name=""
input_dashboard_port=""
input_mirror=""

para_type="--type"                  # master or node
para_version='--version'            # version of kubernetes
para_master='--master'              # master ip
para_node='--node'                  # node private ip
para_password='--password'          # pwd of each node
para_dashboard_name='--dashname'    # name of login to dashboard
para_dashboard_port='--dashport'    # port of login to dashboard
para_mirror='--mirror'              # weather to change mirror and yum/apt update[default false]

info_msg="\033[0;30;42m[INFO]\033[0m"    # green bold, INFO
warn_msg="\033[0;30;43m[WARN]\033[0m"    # yellow bold, WARN
err_msg="\033[0;30;41m[ERROR]\033[0m"    # red bold, ERROR

build_dir="/root/build-k8s"
code_dir="/root/code"

kubeadm_join_cmd=""
green='\033[0;32m'
yellow='\033[0;33m'
cend='\033[0m'

# 'fc' specify it is a Centos Function
function fc_main() {
    fc_parse_cmd $@
    fc_validate_input_para

    if [[ ${input_type} == "master" ]]; then
        fc_master
    elif [[ ${input_type} == "node" ]]; then
        fc_node
    fi

    wait_time=0
    while [[ -e /tmp/fc_master.lock ]]; do
        sleep 10
        wait_time=$((wait_time + 1))
        if [[ ${wait_time} == 180 ]]; then  # 1800s/60s=30min
            printf "${err_msg} wait for build cluster time out \n"
            exit
        fi
    done
    fc_end_output
}

function fc_master() {
    touch /tmp/fc_master.lock
    if [[ ${input_mirror} == "true" ]]; then
        fc_change_mirrors
        fc_install_common_cmd
    fi
    fc_tmout
    fc_write_environment_variable
    fc_install_docker
    fc_config_host
    fc_change_linux_core_parameter
    fc_config_ipvs
    fc_install_kube
    fc_config_kubelet_cgroup
    fc_kubeadm_init
    fc_kubeadm_join
    fc_install_network_plugin
    fc_boot_up_nfs_system
    fc_install_golang
    fc_get_repos

    if [[ -n ${para_dashboard_name} && -n ${para_dashboard_port} ]]; then
        fc_install_dashboard
    fi
    rm -rf /tmp/fc_master.lock
}

function fc_node() {
    if [[ ${input_mirror} == "true" ]]; then
        fc_change_mirrors
        fc_install_common_cmd
    fi
    fc_tmout
    fc_write_environment_variable
    fc_install_docker
    fc_change_linux_core_parameter
    fc_config_ipvs
    fc_install_kube
    fc_config_kubelet_cgroup
    wait_time=0
    while [[ -e /etc/kubernetes/admin.conf ]]; do
        printf "${err_msg} wait for admin.conf... \n"
        sleep 10
        wait_time=$((wait_time + 1))
        if [[ ${wait_time} == 60 ]]; then  # 600/60s=10min
            printf "${err_msg} time out! please manually copy /etc/kubernetes/admin.conf from master into node \n"
            exit
        fi
    done

    fc_mkfile
    fc_node_join
    fc_boot_up_nfs_system
    fc_install_golang
    fc_get_repos
}

# common function: check if specified cmd could execute successfully
function fc_check_cmd() {
    if ! command -v ${1} >/dev/null 2>&1 ; then
        printf "${err_msg}failed to execute ${1}, please install manually and retry \n"
        exit
    fi
}

# parse input all cmd
function fc_parse_cmd() {
    printf "${info_msg} start to parse input command \n"
    while [ "$#" -gt 0 ]; do
        case $1 in
            ${para_type}=*) input_type="${1#*=}"; shift ;;
            ${para_version}=*) input_version="${1#*=}"; shift ;;
            ${para_master}=*) input_master="${1#*=}"; shift ;;
            ${para_mirror}=*) input_mirror="${1#*=}"; shift ;;
            ${para_node}=*)
                IFS=',' read -r -a input_node <<< "${1#*=}"
                shift
                ;;
            ${para_password}=*)
                IFS=',' read -r -a input_password <<< "${1#*=}"
                shift
                ;;
            #${para_docker}=*) input_docker="${1#*=}"; shift ;;
            ${para_dashboard_name}=*) input_dashboard_name="${1#*=}"; shift ;;
            ${para_dashboard_port}=*) input_dashboard_port="${1#*=}"; shift ;;
            *) echo "Unknown parameter: $1"; exit ;;
        esac
    done
}


function fc_validate_input_para() {
    printf "${info_msg} start to validate input parameters \n"

    # type
    if [[ -z ${input_type} ]]; then
        printf "${err_msg}parameter [${input_type}] must not be empty \n"
        exit
    elif [[ ${input_type} != "master" && ${input_type} != "node" ]]; then
        printf "${err_msg}parameter [${input_type}] must be one of 'master' 'node' \n"
        exit
    fi

    # version
    if [[ -z ${input_version} ]]; then
        printf "${err_msg}parameter [${para_version}] must not be empty \n"
        exit
    fi

    # master
    if [[ -z ${input_master} ]]; then
        printf "${err_msg}parameter [${para_master} must not be empty \n"
        exit
    fi

    # docker
#     if [[ -z ${input_docker} ]]; then
#         printf "${err_msg}parameter [${para_docker}] must not be empty \n"
#         exit
#     fi

    # node ip
    if [[ ${#input_node[@]} == 0 ]]; then
        printf "${info_msg} you will create a kubernetes cluster with single-node \n"
    fi

    # password
    if [[ ${#input_password[@]} == 0 && ${#input_node[@]} != 0 ]]; then
        printf "${err_msg}node password must not be empty \n"
        exit
    elif [[ ${#input_node[@]} != ${#input_password[@]} ]]; then
        printf "${err_msg}node number is not matched password number \n"
        exit
    fi

    # dashboard
    if [[ -z ${input_dashboard_name} && -z ${input_dashboard_port} ]]; then
        printf "${info_msg}will not install dashboard \n"
    elif [[ -z ${input_dashboard_name} && -n ${input_dashboard_port} ]]; then
        printf "${err_msg}'dashname' and 'dashport' must be set at the same time \n"
        exit
    elif [[ -n ${input_dashboard_name} && -z ${input_dashboard_port} ]]; then
        printf "${err_msg}'dashname' and 'dashport' must be set at the same time \n"
        exit
    fi

    # mirror
    if [[ ${input_mirror} == "true" ]]; then
        printf "${err_msg} will change system mirror and update yum/apt \n"
    elif [[ -z ${input_mirror} || ${input_mirror} == "false" ]]; then
        printf "${info_msg} do not change system mirror and update yum/apt \n"
    fi
}

function fc_change_mirrors() {
    printf "${info_msg} start to change mirrors of CentOS and Kubernetes \n"

    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

echo '
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/contrib/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/contrib/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
' >> /etc/yum.repos.d/centos-aliyun.repo

sleep 2

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes-127]
name=Kubernetes 1.27
baseurl=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.27/rpm/repodata/repomd.xml.key

[kubernetes-128]
name=Kubernetes 1.28
baseurl=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.28/rpm/repodata/repomd.xml.key

[kubernetes-129]
name=Kubernetes 1.29
baseurl=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.29/rpm/repodata/repomd.xml.key

[kubernetes-old]
name=Kubernetes old
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgchech=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

sleep 2

echo '
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/debug-$basearch/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/source/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-test]
name=Docker CE Test - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-test-debuginfo]
name=Docker CE Test - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/debug-$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-test-source]
name=Docker CE Test - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/source/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
[docker-ce-nightly]
name=Docker CE Nightly - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/$basearch/nightly
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-nightly-debuginfo]
name=Docker CE Nightly - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/debug-$basearch/nightly
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-nightly-source]
name=Docker CE Nightly - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/$releasever/source/nightly
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
' >> /etc/yum.repos.d/docker-ce.repo

sleep 2

yum makecache
}

function fc_install_common_cmd() {
    printf "${info_msg} start to install common commands, it will takes some minutes \n"
    sudo yum -y update

    yum -y install wget

    yum -y install gcc
    yum -y install gcc-c++

    yum -y install bind-utils

    yum -y install vim*
    yum -y install nano

    yum -y install git
    yum -y install ipset ipvsadm
    yum -y install expect
    yum -y install sshpass
}

function fc_tmout() {
    printf "${info_msg} start to change client alive time \n"

cat <<EOF>> /etc/ssh/sshd_config
ClientAliveInterval 600
ClientAliveCountMax 100
EOF

    systemctl restart sshd
}

function fc_write_environment_variable() {
    printf "${info_msg} start to modify environment variables \n"

    mkdir ${code_dir}
    mkdir ${build_dir}
    mkdir /root/logs

echo '
# ssh
export TMOUT=0

# packer
export PATH=$PATH:/usr/local/bin
export HW_DEBUG=1
export PACKER_LOG=1
export PACKER_LOG_PATH="/root/logs/packer.log"

# k8s csi env
#export REGISTRY_SERVER=""
#export REGISTRY=""

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

source /etc/profile
}

function fc_install_docker() {
    printf "${info_msg} start to install docker \n"

    yum install -y docker
    fc_check_cmd "docker -v"

cat <<EOF>> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

    yum -y install containerd
    systemctl daemon-reload
    systemctl restart docker
    systemctl restart containerd
}

function fc_config_host() {
    printf "${info_msg} start to config host \n"
    master_hostname=$(hostname)
    echo "${input_master} ${master_hostname}" >> /etc/hosts

    if [[ ${#input_node[@]} -eq 0 ]]; then
        return
    fi

    declare -A hostnames
    node_num=${#input_node[@]}
    while (( node_num != 0 )); do
        node_num=$((node_num - 1))
        name=$(sshpass -p "${input_password[node_num]}" ssh -o StrictHostKeyChecking=no "root@${input_node[node_num]}" "hostname")
        hostnames[${input_node[node_num]}]=${name}
    done

    hosts_config="${input_master} ${master_hostname} \n"
    for key in ${!hostnames[@]}; do
        hosts_config="${hosts_config}${key} ${hostnames[$key]} \n"
    done

    write_host="printf \"${hosts_config}\" >> /etc/hosts"
    echo -e ${hosts_config} >> /etc/hosts
    node_num=${#input_node[@]}
    while (( node_num != 0 )); do
        node_num=$((node_num - 1))
        sshpass -p "${input_password[node_num]}" ssh -o StrictHostKeyChecking=no "root@${input_node[node_num]}" ${write_host}
    done
}

function fc_change_linux_core_parameter() {
    printf "${info_msg} start to config linux core parameters \n"

    echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/kubernetes.conf
    echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/kubernetes.conf
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/kubernetes.conf
    sysctl -p
    modprobe br_netfilter
    lsmod | grep br_netfilter
}

function fc_config_ipvs() {
    printf "${info_msg} start to config ipvs \n"

cat <<EOF>> /etc/sysconfig/modules/ipvs.modules
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF

    chmod +x /etc/sysconfig/modules/ipvs.modules
    /bin/bash /etc/sysconfig/modules/ipvs.modules
    lsmod | grep -e ip_vs -e nf_conntrack_ipv4
}

# install kubeadm kubelet kubectl
function fc_install_kube() {
    printf "${info_msg} start to install kubeadm, kubelet and kubectl \n"

    yum -y install --setopt=obsoletes=0 kubeadm-${input_version} kubelet-${input_version} kubectl-${input_version}
    fc_check_cmd "kubeadm version"
    fc_check_cmd "kubelet --version"
    fc_check_cmd "kubectl version"
}

function fc_config_kubelet_cgroup() {
    printf "${info_msg} start to config kubelet cgroup \n"

cat <<EOF>> /etc/sysconfig/kubelet
KUBELET_CGROUP_ARGS="--cgroup-driver=systemd"
KUBE_PROXY_MODE="ipvs"
EOF

systemctl enable kubelet
systemctl restart kubelet
}

function fc_mkfile() {
    printf "${info_msg} start to make kubernetes files \n"

    rm -rf /etc/containerd/config.toml
    systemctl restart containerd

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
    source ~/.bash_profile
}

# node exclusive function
function fc_node_join() {
    (${kubeadm_join_cmd})
}

function fc_kubeadm_init() {
    printf "${info_msg} start to execute kubeadm init \n"

    rm -rf /etc/containerd/config.toml
    systemctl restart containerd

    kubeadm init \
  --apiserver-advertise-address=0.0.0.0 \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version=v${input_version} \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 > ${build_dir}/kubeadm-init-output.txt 2>&1

    fc_mkfile

    declare -A hostnames    # ip:pwd
    node_num=${#input_node[@]}
    while (( node_num != 0 )); do
        node_num=$((node_num - 1))
        sshpass -p ${input_password[node_num]} scp /etc/kubernetes/admin.conf root@${input_node[node_num]}:/etc/kubernetes
        sleep 2
    done
}

function fc_kubeadm_join() {
    printf "${info_msg} start to execute join other nodes to cluster \n"

    kubeadm_join_cmd=$(awk '/kubeadm join/{flag=1} flag' "${build_dir}/kubeadm-init-output.txt")

#     # difficult to accomplish...
#     if [ -n "${kubeadm_join_cmd}" ]; then
#         printf "${info_msg}successfully get 'kubeadm join ***' \n"
#         node_num=${#input_node[@]}
#         while (( node_num != 0 )); do
#             node_num=$((node_num - 1))
#             sshpass -p "${input_password[node_num]}" ssh -o StrictHostKeyChecking=no "root@${input_node[node_num]}" ${kubeadm_join_cmd}
#         done
#     else
#         printf "${err_msg}failed to get 'kubeadm join ***' from ${build_dir}/kubeadm-init-output.txt, "
#         printf "${info_msg}Please manually execute kubeadm join \n"
#         exit
#     fi
}

function fc_install_network_plugin() {
    printf "${info_msg} start to install network plugin \n"
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
}

function fc_boot_up_nfs_system() {
    printf "${info_msg} start to boot up nfs system \n"

    systemctl start nfs && systemctl enable nfs
    systemctl status nfs
}

function fc_install_golang() {
    printf "${info_msg} start to install Golang_1.21.8 \n"
    wget https://golang.google.cn/dl/go1.21.8.linux-amd64.tar.gz -P ${build_dir}
    tar -zxvf ${build_dir}/go1.21.8.linux-amd64.tar.gz -C /usr/local
    fc_check_cmd "go version"
    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.cn,direct
}

function fc_get_repos() {
    printf "${info_msg} start to get repo [csi] \n"
    git clone https://github.com/huaweicloud/huaweicloud-csi-driver.git ${code_dir}/huaweicloud-csi-driver
    sleep 5
    printf "${info_msg} start to get repo [ccm] \n"
    git clone https://github.com/kubernetes-sigs/cloud-provider-huaweicloud.git ${code_dir}/cloud-provider-huaweicloud
    sleep 5
    printf "${info_msg} start to get repo [kt] \n"
    git clone https://github.com/Zippo-Wang/k8s-autotest.git ${code_dir}/k8s-autotest
    sleep 5
    $(kt init > /dev/null 2>&1)
    sleep 10
}

function fc_install_dashboard() {
    printf "${info_msg} start to install dashboard \n"
    wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml -P ${build_dir}
    sleep 5

    filename="${build_dir}/recommended.yaml"
    awk -v port="${input_dashboard_port}" '
BEGIN { inside_spec = 0; inside_ports = 0; type_added = 0; nodeport_added = 0 }
{
    if ($0 ~ /spec:/) {
        inside_spec = 1
        type_added = 0
    }
    if (inside_spec && !type_added && $0 ~ /ports:/) {
        print "  type: NodePort"
        type_added = 1
    }
    if (inside_spec && $0 ~ /ports:/) {
        inside_ports = 1
    }
    if (inside_ports && $0 ~ /- targetPort: 8443/) {
        print
        next
    }
    if (inside_ports && !nodeport_added && $0 ~ /- port: 443/) {
        print
        print "      nodePort: " port
        nodeport_added = 1
        inside_ports = 0  # reset after inserting nodePort
        next
    }
    # If nodePort was added, copy remaining lines and exit processing
    if (nodeport_added) {
        print
        while (getline > 0) {
            print
        }
        exit
    }
    print
}' "$filename" > tmpfile && mv tmpfile "$filename"

kubectl apply -f ${build_dir}/recommended.yaml

cat <<EOF  >> ${build_dir}/usr.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${input_dashboard_name}
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${input_dashboard_name}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: ${input_dashboard_name}
  namespace: kubernetes-dashboard
EOF

    kubectl apply -f ${build_dir}/usr.yaml
    (kubectl proxy --port=${input_dashboard_port}) &
    printf "${info_msg}Now, you can use kubectl create token ${input_dashboard_name} -n kubernetes-dashboard to create token \n"
    printf "${info_msg}Use https://EIP:${input_dashboard_port} to login dashboard! \n"
}

function fc_end_output() {
    echo "---------------------------------------------------------------------------------- "
    printf "${info_msg}${yellow}System environment variables:${cend} ${green}/etc/profile${cend} \n"
    printf "${info_msg}${yellow}Code directory:${cend} ${green}${code_dir}${cend} \n"
    printf "${info_msg}${yellow}Pkg directory:${cend} ${green}${build_dir}${cend} \n"
    printf "${info_msg}${yellow}GOPATH: ${code_dir}, GOROOT: /usr/local/go \n"
    if [[ -n ${para_dashboard_name} && -n ${para_dashboard_port} ]]; then
        printf "${info_msg}${yellow}Dashboard username: ${input_dashboard_name}, port: ${input_dashboard_port}${cend} \n"
    fi
    echo "---------------------------------------------------------------------------------- "
    printf "${info_msg}${green}kubectl get nodes${cend} \n"
    kubectl get nodes
}

# start_time=$(date +%s)
# fc_main "$@"
# end_time=$(date +%s)
# duration=$((end_time - start_time))
# minute=$(( (duration % 3600) / 60 ))
# second=$((duration % 60))
# printf "${info_msg}Build completed! Spend ${minute}:${second} (min:sec) \n"

