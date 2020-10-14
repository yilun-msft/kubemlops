# Create AKS resources
az aks create -g kf-test-rg -n kf-test-cluster -s Standard_D4s_v3 -c 2 -l westus2 --service-principal ${{ secrets.APP_ID }} --client-secret ${{ secrets.PASSWORD }} --generate-ssh-keys
az aks get-credentials -n kf-test-cluster -g kf-test-rg 
mkdir kubeflow
cd kubeflow
# Download and install Kubeflow
curl -LO https://github.com/kubeflow/kfctl/releases/download/v1.1.0/kfctl_v1.1.0-0-g9a3621e_linux.tar.gz
tar -xvf kfctl_v1.1.0-0-g9a3621e_linux.tar.gz
export BASE_DIR=$(pwd)
echo base dir is ${BASE_DIR}
export PATH=$PATH:$(pwd)
export KF_NAME=kf-test
export KF_DIR=${BASE_DIR}/${KF_NAME}
mkdir -p ${KF_DIR}
cd ${KF_DIR}
echo kf dir is ${KF_DIR}
kfctl -h
# Install istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.8 TARGET_ARCH=x86_64 sh -
cd istio-1.6.8
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo
kubectl label namespace default istio-injection=enabled
cd ${KF_DIR}
echo currently at $(pwd)
echo ${PATH}
kfctl apply -V -f https://raw.githubusercontent.com/kubeflow/manifests/v1.1-branch/kfdef/kfctl_azure.v1.1.0.yaml
echo Getting External Ip
echo $(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')