kubectl apply -f 01-rollout-sample-yaml

kubectl argo rollouts list rollouts

kubectl argo rollouts get rollouts <rollout name>

kubectl argo rollouts get rollouts <rollout name> --watch