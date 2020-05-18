# https://docs.seldon.io/projects/seldon-core/en/latest/workflow/install.html
kubectl create namespace seldon-system
helm install seldon-core seldon-core-operator \
    --repo https://storage.googleapis.com/seldon-charts \
    --set usageMetrics.enabled=true,crd.create=true \
    --namespace seldon-system
# https://docs.seldon.io/projects/seldon-core/en/latest/graph/inference-graph.html - deploys "simple.yaml"
# https://www.kubeflow.org/docs/components/serving/seldon/#seldon-serving
cat <<EOF | kubectl create -f -
apiVersion: machinelearning.seldon.io/v1
kind: SeldonDeployment
metadata:
  name: seldon-modelkf
spec:
  name: test-deployment
  predictors:
  - componentSpecs:
    - spec:
        containers:
        - image: seldonio/mock_classifier_rest:1.3
          name: classifier
    graph:
      children: []
      endpoint:
        type: REST
      name: classifier
      type: MODEL
    name: example
    replicas: 1
EOF
kubectl port-forward $(kubectl get pods -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].metadata.name}') -n istio-system 8004:80
curl -s -d '{"data": {"ndarray":[[1.0, 2.0, 5.0]]}}'    -X POST http://localhost:8004/seldon/seldon-system/seldon-modelkf/api/v1.0/predictions    -H "Content-Type: application/json"
# Got invalid response, stopped...

# https://github.com/SeldonIO/seldon-core/blob/dc6e7ea222afaaf861c9b960247c70842a590076/examples/kubeflow/kubeflow_seldon_e2e_pipeline.ipynb
pip install -r requirements-dev.txt
#Successfully built kfp googleapis-common-protos
#ERROR: kfp 0.1.20 has requirement kubernetes<=9.0.0,>=8.0.0, but you'll have kubernetes 11.0.0 which is incompatible.
kubectl -n kubeflow patch deployments. workflow-controller --patch '{"spec": {"template": {"spec": {"containers": [{"name": "workflow-controller", "image": "argoproj/workflow-controller:v2.3.0-rc3"}]}}}}'
kubectl -n kubeflow patch deployments. ml-pipeline --patch '{"spec": {"template": {"spec": {"containers": [{"name": "ml-pipeline-api-server", "image": "elikatsis/ml-pipeline-api-server:0.1.18-pick-1289"}]}}}}'
#kubectl -n kubeflow patch configmaps workflow-controller-configmap --patch '{"data": {"config": "{ executorImage: argoproj/argoexec:v2.3.0-rc3,artifactRepository:{s3: {bucket: mlpipeline,keyPrefix: artifacts,endpoint: minio-service.kubeflow:9000,insecure: true,accessKeySecret: {name: mlpipeline-minio-artifact,key: accesskey},secretKeySecret: {name: mlpipeline-minio-artifact,key: secretkey}}}}" }}'
kubectl edit configmaps workflow-controller-configmap -n kubeflow
pytest ./pipeline/pipeline_tests/. --disable-pytest-warnings
# ______________________ ERROR collecting pipeline/pipeline_tests/test_pipeline.py ______________________ 
# ImportError while importing test module 'C:\src\github\seldon-core\examples\kubeflow\pipeline\pipeline_tests\test_pipeline.py'.
# Hint: make sure your test modules/packages have valid Python names.
# Traceback:
# pipeline\pipeline_tests\test_pipeline.py:3: in <module>
#     import dill
# E   ModuleNotFoundError: No module named 'dill'
wget https://github.com/openshift/source-to-image/releases/download/v1.3.0/source-to-image-v1.3.0-eed2850f-linux-amd64.tar.gz
tar -xzf source-to-image-v1.3.0-eed2850f-linux-amd64.tar.gz
sudo chmod +x ./s2i
sudo mv s2i /usr/local/bin
cd pipeline/pipeline_steps/clean_text/ && ./build_image.sh
cd ../data_downloader && ./build_image.sh
cd ../lr_text_classifier && ./build_image.sh
cd ../spacy_tokenize && ./build_image.sh
cd ../tfidf_vectorizer && ./build_image.sh