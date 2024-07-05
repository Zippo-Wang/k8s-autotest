# k8s-autotest

已经测试过的系统：centos 7.9，其他系统**可能**存在不兼容
### 1、test-case
1）支持的服务
```bash
# csi
EVS
OBS
SFS-Turbo

# ccm
ccm
```

2）测试用例的文件命名必须为以下几个
```bash
# csi
pv.yaml, sc.yaml, pvc.yaml, pvc2.yaml, pod.yaml

# ccm
elb-service.yaml
```

3）特殊用例，特殊名字，特殊处理
```txt
snapshotx-xxx.yaml
```

### 2、script使用
```bash
# 安装evs相关配置【不含cloud-config】
kt install evs

# 执行evs服务的测试用例，创建对象
kt create evs

# 删除sfs-turbo服务测试用例创建的对象
kt delete sfs-turbo

# 自定义目录
kt create /root/code/k8s-autotest/test-case/csi/OBS/01_obs-dynamic

# 执行ccm用例
kt create ccm

# 另起窗口，监控pod
# watch -n 1 -d kubectl get pod -o wide
kt watch pod

# 查看帮助
kt help
kt -help
kt --help
```
