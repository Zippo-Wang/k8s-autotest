# k8s-autotest

### test-case
EVS、OBS、SFS-Turbo

### script

1.create
```bash
sh k8s-autotest.sh create /root/obs
```

2.delete
```bash
sh k8s-autotest.sh delete /root/obs
```

3.file name must be one of as follows:
```txt
pv.yaml, sc.yaml, pvc.yaml, pvc2.yaml, pod.yaml
```

4.special file name
```txt
snapshotx-xxx.yaml
```
