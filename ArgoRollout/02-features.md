# Research the Argo Rollouts Features.
### The benefits of using Argo Rollouts for application delivery are followings:
- Advance deployment strategies like Canary Deployment, Blue-Green Deployment, Rolling Updates, Recreate, Fine Grained
- we can add manual or automatic promote of deployment steps in rollouts:
- Sample rollout for auto promotion of steps in strategy in every 10 sec
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: example-rollout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: rollouts-demo
        image: argoproj/rollouts-demo:blue
        ports:
        - containerPort: 8080
  strategy:
    canary:
      steps:
      - setWeight: 20
      - pause: {duration: 10s}
      - setWeight: 40
      - pause: {duration: 10s}
      - setWeight: 60
      - pause: {duration: 10s}
      - setWeight: 80
      - pause: {duration: 10s}
```
- If pause duration is not mention, then its need to promote manually
![alt text](<image1.png>)

- Add experiments on canary i.e new version to allows users to have ephemeral runs of one or more ReplicaSets.
```yml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: rollout-experiment-step
spec:
  replicas: 4
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: rollout-experiment-step
  template:
    metadata:
      labels:
        app: rollout-experiment-step
    spec:
      containers:
      - name: rollouts-demo
        image: argoproj/rollouts-demo:blue
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
  strategy:
    canary:
      steps:
      - setWeight: 25
      # The second step is the experiment which starts a single canary pod
      - experiment:
          templates:
          - name: canary
            specRef: canary
          # This experiment performs its own analysis by referencing one or more AnalysisTemplates
          # here. The success or failure of these runs will progress or abort the rollout respectively.
          analyses:
          - name: random-fail
            templateName: random-fail

  # List of AnalysisTemplate references to perform during the experiment
kind: AnalysisTemplate
apiVersion: argoproj.io/v1alpha1
metadata:
  name: random-fail
spec:
  metrics:
  - name: random-fail
    count: 2
    interval: 5s
    failureLimit: 1
    provider:
      job:
        spec:
          template:
            spec:
              containers:
              - name: sleep
                image: alpine:3.8
                command: [sh, -c]
                args: [FLIP=$(($(($RANDOM%10))%2)) && exit $FLIP]
              restartPolicy: Never
          backoffLimit: 0
```
- Experiment auto approval using prometheus metrics result
![alt text](<Screenshot from 2024-05-05 01-47-34.png>)

# Compare Argo Rollouts with existing application delivery tools like ArgoCD & Kargo
# Identify potential challenges or limitations of implementing Argo Rollouts.
# Find out how we can add permission and Login access using SSO
