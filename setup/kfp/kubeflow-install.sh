#!/bin/sh


kubectl apply -k github.com/kubeflow/pipelines/manifests/kustomize/cluster-scoped-resources
kubectl wait crd/applications.app.k8s.io --for condition=established --timeout=60s


### Comment out this section if using Azure MySQL or MinIO ###
# Update Argo workflow config to use "pns" containerRuntimeExecutor instead of default "docker"
# to support containerd
# https://github.com/kubeflow/pipelines/issues/1654
# https://github.com/kubeflow/pipelines/issues/1654#issuecomment-595722994
kubectl patch configmap/workflow-controller-configmap -n kubeflow --patch  "$(cat workflow-controller-configmap-patch.yaml)"
kubectl apply -k github.com/kubeflow/pipelines/manifests/kustomize/env/platform-agnostic

### Uncomment this section if using Azure MySQL or MinIO ###
# Remember to update the missing values in .env files first
# kubectl apply -k ./azure

# Apply this role and binding to fix the permission issue of cache-deployer-deployment
# https://github.com/kubeflow/pipelines/pull/4246
kubectl apply -f crb.yaml
kubectl apply -f istio-resources.yaml

