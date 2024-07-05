# k8s-autotest

### 已经测试过的系统
* centos 7.9

其他系统**可能**存在不兼容

### 功能说明
* **支持一键搭建k8s集群【爆火】**。详见[搭建k8s集群](https://github.com/Zippo-Wang/k8s-autotest/blob/1f32061024716054e306f064b3727c998054e2bc/docs/build-cluster.md)
* 支持一键安装Huaweicloud CSI、CCM插件。
* 支持一键运行Huaweicloud CSI、CCM用例。
* 支持一键打包Huaweicloud CSI、CCM项目并推送到docker hub。
* 支持一键监控k8s集群内对象状态。

入门教程: [使用k8s-autotest]()。TODO: 提交PR之后，才会生成一个链接 

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
# centos。编辑`/etc/profile`，仅需修改`kt_project_path`变量值
# 如果步骤1 clone下来的，就不用修改
export kt_project_path="/root/code/k8s-autotest"
export kt_main='kt'
alias kt="source $kt_project_path/main/main.sh"

# ubuntu。下个版本支持
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
