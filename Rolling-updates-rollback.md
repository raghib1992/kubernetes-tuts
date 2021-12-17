# Rollout and Versioning
## When you first create deployment, its trigger rollout, rollout create deploy new revision
## command to check the status of the rollout
```
kubectl rollout status deployment/myapp-deployment
kubectl rollout history deployment/myapp-deployment
```
# Update strategy
## Recreate strategy: destroy all application first and then deploy newer version
## Rolling Update strategy: destroy one by one, and deploy one by one (default)
## Command to update image
```
kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1
```
# Upgrade
## deplohyment create new replica set for upgrade new pod and start deploying pod in new replica set and delete pod from old replica set
## Rollback to old version
```
kubectl rollout undo deployment/myapp-deployment
kubectl get replicasets 
```