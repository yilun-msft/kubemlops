# Azure Manifest Tests
In order to make sure the Azure manifest on Kubeflow.org is functioning and user could install Kubeflow to AKS cluster. We design Azure Manifest tests to enable continously monitoring Azure Manifest.

## Availability Tests
The tests are two-fold. Firstly, we want to make sure that all pods are healthy, and, therefore, we have /code/tests/availability_tests.py. This test will make sure all the pods for Kubeflow will be up running within a pre-configured amount of time, currently it is 10 minutes. If any of the pods failed to be ready within this time frame, then the test will fail.

## Pipeline Tests
The /code/tests/manifest_tests will actually create a simple pipeline and execute the pipeline on the newly-claimed AKS cluster to validate that basic functionalities are available.

## Debug
Under normal circumstances, when the tests pass, all the resouces created for the tests will be deleted and the core will be released. However, if there are some errors caught during the tests, developers could go into the resource (Kubeflow dashboard) to inspect the run. To access the static IP, one needs to go to the ```Apply Resources``` stage of the Manifest_Test action and the static ip would be seen in the last command.