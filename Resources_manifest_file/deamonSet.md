# daemon Set
## daemon sets is like replica sets
## But it run one copy of your pod on each node and wheneer a node is added it deploy a pod on that node
## One copy always present
## Prefect for monitoring pod on each node
## kube-proxy is also deploy using daemon set
## daemonset-definition.yml
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
    name: myapp-rc
    type: frontend
specs:
    template:
        metadata:
            name: myapp-pod
            env: prod
            tier: frontend
        specs:
            containers:
                - name: nginx-contorller
                  image: ngins
    replication: 3
    selector:
        matchLabels:
            type: front-end
```
## Command
```
kubectl get daemonsets
kubectl describe daemonsets monitoring-daemon
```

## Use of daemonsets
```
In a Kubernetes architecture, DaemonSets are used for deploying background services across clusters, providing support services for every node—such as system operations services, collecting logs, monitoring frameworks like Prometheus, and storage volumes
```