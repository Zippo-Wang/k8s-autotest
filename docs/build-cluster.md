

## Introduction

* Ensure your virtual machines are clean, including have not installed docker,containerd, kubernetes, etc.

### cluster

特别说明, 只支持同一类型的OS搭建成k8s集群, 比如该集群中的机器都是CentOS；别整那既有CentOS, 又有Ubuntu的。
支持搭建集群的系统：**CentOS**

* `--type` (String, Required). 这个节点的类型。取值如下
  - `master`。该节点是master
  - `node`。该节点是node

* `--version` (String, Required). 要搭建集群的版本。也可以自己看**yum list --showduplicates | grep kubelet**
```
1.27.0 ~ 1.27.16
1.28.0 ~ 1.28.12
1.29.0 ~ 1.29.7
```

* `--master` (String, Required). master节点的私有IP。

* `--node` (String, Optional). node节点的私有IP, 以逗号分割, 跟密码一一对应。
  例如**--node=192.168.0.5,192.168.0.6**

* `--password` (String, Required). node节点的密码, 跟私有IP一一对应 以逗号分割。
  例如**--node=xxx,yyy**

* `--dashname` (String, Optional). 安装dashboard, 创建的用户叫什么。

* `--dashport` (Int, Optional). 安装dashboard, 用哪个端口。

* `--mirror` (Bool, Optional). 是否使用脚本给写入镜像源。默认`false`
  - `true`。使用, 且安装一系列命令, 会有点耗时, 大概10-15min
  - `false`。不使用, 也不安装命令, 超快, 5min左右。(确保自己基础命令安装好了, 而且你自己的镜像源中有docker/containerd/kubelet/kubeadm/kubectl)

[Note] 手动安装怎么装？
```bash
# centos
yum -y install wget
yum -y install gcc
yum -y install gcc-c++
yum -y install bind-utils
yum -y install vim*
yum -y install git
yum -y install ipset ipvsadm
yum -y install expect
yum -y install sshpass
```

### 一个例子
```bash
# master
sh /root/centos.sh \
	--type=master \
	--version=1.27.2 \
	--master=192.168.0.100 \
	--node=192.168.0.101,192.168.0.102 \
	--password='xxxxx','yyyyy' \
	--dashname=namexxx \
	--dashport=30017 \
	--mirror=true

# node
sh /root/centos.sh \
	--type=node \
	--version=1.27.2 \
	--master=192.168.0.100 \
	--node=192.168.0.101,192.168.0.102 \
	--password='xxxxx','yyyyy' \
	--mirror=true
```

