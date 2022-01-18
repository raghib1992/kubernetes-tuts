# Prometheus
## It also run as daemon
## To monitor control plane

## create namespace 
```
kubectl create namespace prometheus
```

## Install Metric Server
## ref https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
## Deploy prometheus
## Ref https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html
## port forward the Prometheus console to your local machine
```
kubectl --namespace=prometheus port-forward deploy/prometheus-server 9090
```
********************************************************

# Grafana 
## Deploy Grafana on top of Prometheus to visualize Metric
## Ref https://aws.amazon.com/blogs/containers/monitoring-amazon-eks-on-aws-fargate-using-prometheus-and-grafana/

## 1. Install Grafana
```
kubectl create namespace grafana
```
```
helm install grafana stable/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --set datasources."datasources\.yaml".apiVersion=1 \
    --set datasources."datasources\.yaml".datasources[0].name=Prometheus \
    --set datasources."datasources\.yaml".datasources[0].type=prometheus \
    --set datasources."datasources\.yaml".datasources[0].url=http://prometheus-server.prometheus.svc.cluster.local \
    --set datasources."datasources\.yaml".datasources[0].access=proxy \
    --set datasources."datasources\.yaml".datasources[0].isDefault=true \
    --set service.type=LoadBalancer
```

## 2. Check if Grafana is deployed properly
```
kubectl get all -n grafana
```

## 3. Get Grafana ELB url
```
export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "http://$ELB"
```

## 4. When logging in, use username "admin" and get password by running the following:
```
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
## IN Grafana dashboard
#### Import -> 3119 -> load

## 5. Grafana Dashboards for K8s:
```
https://grafana.com/grafana/dashboards?dataSource=prometheus&direction=desc&orderBy=reviewsCount
```

## 6. Uninstall Prometheus and Grafana
```
helm uninstall prometheus --namespace prometheus
helm uninstall grafana --namespace grafana
```
**********************************************
# CloudWatch Insight
## Attach cloudwatch policy to ec2
## Ref https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-EKS-quickstart.html
