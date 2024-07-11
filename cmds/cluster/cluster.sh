#!/usr/bin/env bash

# 全局变量
os_version="centos7" # 是什么系统。根据f_find_os函数的返回而变化，默认centos7
os_cmd="yum"         # 对应的命令。根据f_find_os函数的返回而变化，默认yum
os_flag=0            # 入参中，所提供的节点是不是同一种系统。


# 程序的总入口
function f_build_cluster(){
  echo "xxx"
}

# 先看看这个Linux是什么系统，CentOS? Ubuntu? Other?
# 目前，只支持centos; 未来，会支持ubuntu; 其他系统，暂不考虑
function f_find_os(){
  echo "xxx"
}

# 换源，默认换成aliyun的源
function f_change_mirror(){
  echo "xxx"
}

# 必需的一些命令，需要提前安装
function f_required_cmd() {
  echo "xxx"
}


# 从cluster-config中读取入参
function f_get_config(){
  echo "xxx"
}
