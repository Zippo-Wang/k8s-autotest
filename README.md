# k8s-autotest

### 已经测试过的系统
* Linux
  * CentOS
  * Ubuntu
* Windows不支持

其他系统**可能**存在不兼容

### 如何使用

1）直接clone仓库
```git
mkdir /root/code
cd /root/code
git clone git@github.com:Zippo-Wang/k8s-autotest.git
```

2）配置环境变量
```bash
# centos。编辑`/etc/profile`, 需修改`kt_project_path`和`kt_code_path`变量值
# kt_project_path: k8s-autotest project所在目录
# kt_code_path: csi、ccm project所在目录的父目录
# 错误示例：kt_project_path="/root/code/k8s-autotest/", 即不要带最后面的斜线
export kt_project_path="/root/code/k8s-autotest"
export kt_code_path="/root/code"
export kt_main='kt'

export kt_docker_user='your docker name'    # 想用'kt update xxx'必须配这个环境变量

alias kt="source $kt_project_path/main/main.sh"
```

3）使环境变量立即生效
```bash
# centos
source /etc/profile
```

4）执行初始化, 然后重新打开终端窗口使初始化生效
```bash
kt init
```
