# Initialize variables:
# DATABRICKS_HOST=
# DATABRICKS_TOKEN=
# CLUSTER_ID=
# KUBEFLOW_NAMESPACE=kubeflow

kubectl create secret generic databricks-secret --from-literal=DATABRICKS_HOST=$DATABRICKS_HOST --from-literal=DATABRICKS_TOKEN=$DATABRICKS_TOKEN --from-literal=CLUSTER_ID=$CLUSTER_ID -n $KUBEFLOW_NAMESPACE
