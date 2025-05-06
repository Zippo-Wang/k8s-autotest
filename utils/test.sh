#!/bin/bash

# 参数
DEPLOY_NAME="csi-sfsturbo-controller"
NAMESPACE="kube-system"
PREFIX="swr.cn-north-4.myhuaweicloud.com/k8s-csi/sfsturbo-csi-plugin"
NEW_IMAGE="${kt_docker_user}/sfsturbo-csi-plugin:${new_version}"

# 导出 deployment 的 YAML
kubectl get deployment "${DEPLOY_NAME}" -n "${NAMESPACE}" -o yaml > tmp_deploy.yaml

# 替换以指定前缀开头的 image 字段
sed -i "s|image: ${PREFIX}.*|image: ${NEW_IMAGE}|" tmp_deploy.yaml

# 查看替换效果（可选）
echo "🔁 替换后镜像字段如下："
grep 'image:' tmp_deploy.yaml

# 应用变更
kubectl apply -f tmp_deploy.yaml

# 清理
rm -f tmp_deploy.yaml
