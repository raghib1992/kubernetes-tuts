## dep-def.yml
```
apiVersion: apps/v1
kind: Deployment
metadata:
    name: php-apache
specs:
    template:
        metadata:
            run: php-apache
        specs:
            containers:
                - name: php-apache
                  image: ngins
                  ports:
                  - containerPort: 80
                  resources:
                    requests:
                      cpu: 500m
                    limits:
                      cpu: 1000m
    replication: 3
    selector:
        matchLabels:
            run: php-apache
```

## hpa manifest file
```
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
    name: php-apache
specs:
    scaleTargetRef: 
        apiVersion: apps/v1
        kind: Deployment
        name: php-apache
    minReplicas: 1
    maxReplicas: 10
    targetCPUUtilizationPercentage: 50
```
************************************************
# Deploy HPA
## Ref https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

## Install metric server as deployment
## deploy deployment and hpa
**********************************************