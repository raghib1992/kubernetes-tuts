# Rollout and Versioning
## When you first create deployment -> create rollout -> create new deployment version
## command to check the status of the rollout
```
kubectl rollout status deployment/<deployment-name>
```
## Command to check the history to revision (deloyment version)
```
kubectl rollout history deployment/<deployment-name>
```
# Update strategy
## Recreate strategy: destroy all application first and then deploy newer version
## Rolling Update strategy: destroy one by one, and deploy one by one (default)
## Command to update image
```
kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1
```
# Upgrade
## deployment create new replica set for upgrade new pod and start deploying pod in new replica set and delete pod from old replica set
## Rollback to old version
```
kubectl rollout undo deployment/<deployment-name>
kubectl get replicasets 
```