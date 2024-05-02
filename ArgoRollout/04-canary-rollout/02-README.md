kubectl apply -f 01-rollout-sample-yaml

kubectl argo rollouts list rollouts

kubectl argo rollouts get rollouts <rollout name>

kubectl argo rollouts get rollouts <rollout name> --watch

### To abort upgrading process
```
kubectl argo rollouts abort rollouts <rollout name>
```
### To Rollback to previous version
![alt text](image.png)
```sh
kubectl argo rollouts undo <rollout name>
```
### Canary pause and resume
```
kubectl argo rollouts pause <rollout name>
kubectl argo rollouts resume <rollout name>
```