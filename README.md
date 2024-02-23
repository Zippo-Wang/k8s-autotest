# k8s-autotest

仅支持centos 7.9，其他系统可能存在不兼容
### 1、test-case
1）支持的服务
```txt
EVS
OBS
SFS-Turbo
```

2）测试用例的文件命名必须为以下几个
```txt
pv.yaml, sc.yaml, pvc.yaml, pvc2.yaml, pod.yaml
```

3）特殊用例，特殊名字，特殊处理
```txt
snapshotx-xxx.yaml
```

### 2、environment
1）先配置环境变量
`vim /etc/profile`，仅需修改`kt_project_path`变量值
```bash
export kt_project_path="/root/code/k8s-autotest"
export kt_main='kt'
alias kt="source $kt_project_path/script/main.sh"
```

2）执行初始化，然后重新打开终端窗口使初始化生效
```bash
kt init
```

### 3、script使用

1）执行evs服务的测试用例，创建对象
```bash
kt create evs
```

2）删除sfs-turbo服务测试用例创建的对象
```bash
kt delete sfs-turbo
```

3）自定义目录
```bash
kt create /root/code/k8s-autotest/test-case/OBS/01_obs-dynamic
```

4）另起窗口，监控pod
```bash
# watch -n 1 -d kubectl get pod -o wide
kt watch pod
```

5）查看帮助
```bash
kt --help
```
