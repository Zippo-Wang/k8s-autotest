# k8s-autotest

已经测试过的系统：CentOS 7.9, 其他系统**可能**存在不兼容
【注】不兼容也只是自动补全功能不兼容, 其他功能照常使用
### 1、支持的服务
```bash
# csi
evs
obs
sfs-turbo

# ccm
ccm
```

### 2、script使用
```bash
# 安装cloud-config
kt config cloud-config

# 安装evs相关配置
kt install evs

# 执行evs服务的测试用例, 创建对象
kt create evs

# 删除sfs-turbo服务测试用例创建的对象
kt delete sfs-turbo

# 自定义目录
kt create /root/code/k8s-autotest/test-case/csi/obs/01_obs-dynamic

# 执行ccm用例
kt create ccm

# 另起窗口, 监控pod
# watch -n 1 -d kubectl get pod -o wide
kt watch pod

# 查看命令帮助
kt install --help
kt create --help

# 查看系统帮助
kt help
kt -help
kt --help

# 查看版本
kt version
kt -version
kt --version
```
