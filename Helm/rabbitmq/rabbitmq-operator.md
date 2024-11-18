Add repo 
helm repo add bitnami https://charts.bitnami.com/bitnami

install rabbitmq operator 
helm install rabbitmq bitnami/rabbitmq-cluster-operator -n rabbitmq-system --create-namespace

Note: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - clusterOperator.resources
  - msgTopologyOperator.resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/



helm -n rabbitmq-system ls
helm -n rabbitmq-system status rabbitmq
helm -n rabbitmq-system status rabbitmq --show-resources

Install Rabbitmq cluster

helm install rabbitmq-cluster bitnami/rabbitmq -n rabbitmq-system

helm upgrade rabbitmq-cluster -n rabbitmq-system -f myvalues.yaml



