# Description of cluster config

## File Structure

不用对齐等号，copy一下直接用

```
[cluster]
k8s_version=
master_ip=
node_info=
docker_mirror=

[git]
git_username=
git_email=
code_dir=
github_repos=

[dashboard]
dash_port=
dash_user=
```

### Examples for kubernetes_v1.27.2

```
[cluster]
k8s_version=1.27.2
master_ip=master_eip
node_info={"node1_eip":"node1_pwd", "node2_eip":"node2_pwd"}
docker_mirror="xxx"

[git]
git_username="Tom123"
git_email="tom123@outlook.com"
code_dir="/root/code"
github_repos=["csi", "ccm", "k8s-autotest"]

[dashboard]
dash_port=30012
dash_user=Tom
```

## Introduction

* Ensure your virtual machines are clean, including have not installed docker, kubernetes, etc.

### cluster

特别说明，只支持同一类型的OS搭建成k8s集群，比如该集群中的机器都是CentOS；别整那既有CentOS，又有Ubuntu的。

* `k8s_version` (String, Required). 想要搭建的k8s集群版本。
  - 小版本。写成1.27.2，就会去搭建v1.27.2版本的集群。支持的版本v1.25(含) - v1.29(含)

* `master_ip` (String, Required). master节点的EIP。

* `node_info` (Map, Optional). node节点的EIP和节点密码，格式是: {"node1_eip":"node1_pwd", "node2_eip":"node2_pwd"}。如果想搭建
  一个单master节点的集群，那就不写该参数。

* `docker_mirror` (String, Optional). docker加速器地址，建议写，不写可能会导致一些问题。

### git

如果不指定git下的任何参数，请勿在cluster-config中填写`[git]`

* `git_username` (String, Optional). 你想在本地设置的git账号的用户名。

* `git_email` (String, Optional). 你想在本地设置的git账号的邮箱。

* `code_dir` (String, Optional). git clone下来的代码放到哪个目录。如果指定了该参数，`git_username`和`git_email`为必选。

* `github_repos` (List, Optional). clone哪些代码仓。取值：**csi**, **ccm**, **packer**, **hh-system**, **k8s-autotest**.
  如果指定了该参数，`git_username`, `git_email`和`code_dir`为必选。

### dashboard

如果不指定dashboard下的任何参数，请勿在cluster-config中填写`[dashboard]`

* `dash_port` (String, Optional). dashboard要开放的端口，可以通过`https://EIP:port`登录。

* `dash_user` (String, Optional). 创建一个用户名为`dash_user`的用户，用于登录dashboard。如果指定了该参数，`dash_port`为必选。