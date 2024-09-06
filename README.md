# k8s-autotest

### 已经测试过的系统
* centos 7.9

其他系统**可能**存在不兼容

### 功能说明
* **支持一键搭建k8s集群【爆火】**。详见[搭建k8s集群](docs/build-cluster.md)
* 支持一键安装Huaweicloud CSI、CCM插件。
* 支持一键运行Huaweicloud CSI、CCM用例。
* 支持一键打包Huaweicloud CSI、CCM项目并推送到docker hub。
* 支持一键监控k8s集群内对象状态。

入门教程: [使用k8s-autotest](docs/usage.md) 

更多详情: 使用`kt help`查看本系统支持的全部命令。

### 如何安装

1）直接clone仓库
```git
mkdir /root/code
cd /root/code
git clone git@github.com:Zippo-Wang/k8s-autotest.git
```

2）配置环境变量
```bash
# centos。编辑`/etc/profile`，需修改`kt_project_path`和`kt_code_path`变量值
# kt_project_path: k8s-autotest project所在目录
# kt_code_path: csi、ccm project所在目录的父目录
# 错误示例：kt_project_path="/root/code/k8s-autotest/"，即不要带最后面的斜线
export kt_project_path="/root/code/k8s-autotest"
export kt_code_path="/root/code"
export kt_main='kt'
alias kt="source $kt_project_path/main/main.sh"
```

3）使环境变量立即生效
```bash
# centos
source /etc/profile
```

4）执行初始化，然后重新打开终端窗口使初始化生效
```bash
kt init
```
