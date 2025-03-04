## Automated Sync
- By default, ArgoCD polls Git repositories every 3 minutes to detect changes to the manifests.
- Argo CD can automatically sync apps when it detects differences between the desired manifests in Git, and the live state in the cluster.
    - No need to do manual sync anymore.
    - CI/CD pipelines no longer need direct access.
- **Notes:**
    - An automated sync will only be performed if the application is OutOfSync
    - Automatic sync will not reattempt a sync if the previous sync attempt against the  same commit SHA and parameters had failed.
    - Rollback cannot be performed against an application with automated sync enabled.


### Enable Auto-Sync In Declaratively Approach
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: 
  name: guestbook
  namespace: argocd
spec: 
  destination: 
    namespace: guestbook
    server: "https://kubernetes.default.svc"
  project: default
  source: 
    path: guestbook
    repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
    targetRevision: master
  syncPolicy:
    automated: {}
```
### Auto Sync CLI
```sh
argocd
app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc --sync-policy automated
```

### Auto Sync Web UI
![alt text](image-3.png)

### Create automate syncing
1. Create Application with auto sync enable
```sh
kubectl -n argocd apply -f 05-manifest-files/01-application.yaml
```
2. Modify manifest in github repo and verify the sync in argocd


## Automated Pruning    
- Default no prune: when automated sync is enabled, by default for safety automated sync will not delete resources when Argo CD detects the resource is no longer defined in Git.
- Pruning can be enabled to delete resources automatically as part of the automated sync.

### Auto Prune Declaratively
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: 
  name: guestbook
  namespace: argocd
spec: 
  destination: 
    namespace: guestbook
    server: "https://kubernetes.default.svc"
  project: default
  source: 
    path: guestbook
    repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
    targetRevision: master
  syncPolicy:
    automated: {}
        prune: true
```

### Auto Prune- CLI
```sh
argocd app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc --auto-prune
```

### Auto Prune Web UI
![alt text](image-4.png)

### Prune manually manual sync.
![alt text](image-5.png)

### Create Application with automatic Prune
1. Create Application with auto sync enable
```sh
kubectl -n argocd apply -f 05-manifest-files/02-application.yaml
```
2. Delete manifest in github repo and verify the sync in argocd

## Automated Self Healing
- By default, changes that are made to the live cluster will not trigger automated sync.
- ArgoCD has a feature to enable self healing when the live cluster state deviates from Git state.
### Auto Self Heal Declaratively
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: 
  name: guestbook
  namespace: argocd
spec: 
  destination: 
    namespace: guestbook
    server: "https://kubernetes.default.svc"
  project: default
  source: 
    path: guestbook
    repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
    targetRevision: master
  syncPolicy:
    automated: {}
        selfHeal: true
```

### Auto Prune- CLI
```sh
argocd app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc --self-heal
```

### Auto Self Heal Web UI
![alt text](image-6.png)

### Create Application with Self Healing
1. Create Application with auto sync enable
```sh
kubectl -n argocd apply -f 05-manifest-files/03-application.yaml
```
2. Scale deployment by command
```
kubectl -n heal scale deployment/guestbook-ui --replicas=2
```
3. Verify the same
```
kubectl -n heal get deploy -w
```

## Sync options
- Users can customize how resources are synced between target cluster and desired state.
- Most of the options available at application level.
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: example
spec:
....
syncPolicy:
    syncOptions:
```
- Some of the options available using resources annotations.
```yml
metadata:
    annotations:
        argocd.argoproj.io…………
```
### No Prune
- ArgoCD can prevent an object from being pruned.
![alt text](image-7.png)
- The app will be in out of sync but still does not prune the resource.
- In the resource itself, can be used as annotation as below:
```yml
metadata:
    annotations:
        argocd.argoproj.io/sync options: Prune=false
```

### Disable Kubectl Validation
- Some resources need to be applied without validating the resources `kubectl apply
validate=false`
- You can achieve this in ArgoCD by at application level or resource level.
    - Application level:
    ```yml
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
        name: example
    spec:
    ....
        syncPolicy:
            syncOptions:
            - Validate=false
    ```
    - Resource level using annotation :
    ```yml
    metadata:
        annotations:
            argocd.argoproj.io/sync options: Validate=false
    ```

### Selective Sync
- When syncing using auto sync ArgoCD applies every object in the application.
- Selective sync option will sync only out of sync resources. You need when you have thousands of resources in which sync take a long time and puts pressure on Api server.
- Can be applied at application level only:
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: example
spec:
    ....
        syncPolicy
            syncOptions:
                - ApplyOutOfSyncOnly =true
```

### Prune Last
- ArgoCD can control the sequence of creation/pruning resources, aka waves.
- You can prune some resources to happen as final using “Prune Last”.
- You can achieve this in ArgoCD by at application level or resource level.
    - Application level:
    ```yml
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
        name: example
    spec:
    ....
    syncPolicy:
        syncOptions:
            - PruneLast=true
    ```
    - Resource level using annotation
    ```yml
    metadata:
        annotations:
            argocd.argoproj.io/sync options: PruneLast =true
    ```

### Replace Resources
- By default ArgoCD use “ kubectl apply” to deploy the resources changes.
- In some cases you need to “Replace/Recreate” the resources, ArgoCD can do this by using replace=true.
- You can achieve this in ArgoCD by at application level or resource level.
    - Application level:
    ```yml
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
        name: example
    spec:
        ....
        syncPolicy:
            syncOptions:
                - Replace=true
    ```
   - Resource level using annotation
    ```yml
    metadata:
        annotations:
            argocd.argoproj.io/sync options: Replace=true
    ```
### Fail on Shared Resource
- By default ArgoCD will apply the resources even if it was available in multiple applications.
- You can configure the sync to fail if any resource is found in other applications by using FailOnSharedResource =true.
- Can be applied at application level only:
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: example
spec:
  ....
   syncPolicy
     syncOptions:
        - FailOnSharedResource =true
```
### Create Application with no-prune at resource level
1. Create Application
```
kubectl -n argocd apply -f 05-manifest-files/04-application.yaml
```
2. Delete deployment from github repo
3. CHeck resource in Argocd is it delete or not
4. Resource will not be delete and show out of sync

### Create Application with Selective SYnc Option
1. Create Application
```
kubectl -n argocd apply -f 05-manifest-files/05-application.yaml
```
2. Modify deployment repilcas from 3 to 4 in github repo
3. CHeck sync in Argocd, it will sync only deployment

### Create Application for Shared Resources
1. Create Application
```
kubectl -n argocd apply -f 05-manifest-files/06-application.yaml
```
2. CHeck Argocd, Warnign for shared resources
### Create Application Replace/Recreate Resources
1. Create Application
```
kubectl -n argocd apply -f 05-manifest-files/07-application.yaml
```
2. Check manifest file in Argocd, not find the annotation for last sync
