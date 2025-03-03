# Project

#### Projects provide a logical grouping of applications.
### Useful when ArgoCD is used by multiple teams.
- Allow only specific sources "trusted git repos"
- Allow apps to be deployed into specific clusters and namespaces
- Allow specific resources to be deployed "Deployments, Statefulsets .. etc"
### Creating Projects Options
- Declaratively
- CLI
- Web UI

1. Declarative approach
### Create yaml file
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Dev project
  sourceRepos:
  - '*'
  destinations:
  - namespace: '*'
    server: '*'
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```
### Create project for specific namespace and destination 
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Learning project
  sourceRepos:
  - '*'
  destinations:
  - namespace: ns-1 # Only permit this namespace
    server: "https://kubernetes.default.svc"
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```
### Creating project for Specific Source Repo
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Learning project
  sourceRepos: # Only permit this Git repos
    - "https://github.com/raghib1992/argocd-example-apps.git"
  destinations:
  - namespace: ns-1
    server: "https://kubernetes.default.svc"
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```
### Create Project, Allow specific Cluster scoped resources
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Dev project
  sourceRepos: # Only permit this Git repos
    - "https://github.com/mabusaa/argocd-example-apps.git"
  destinations:
  - namespace: ns-1
    server: "https://kubernetes.default.svc"
  clusterResourceWhitelist: # Deny all cluster scoped resources from being created, except for Namespace
  - group: '*'
    kind: 'Namespace'
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```
### Create Project, Allow specific Namespace scoped resources
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Dev project
  sourceRepos: # Only permit this Git repos
    - "https://github.com/mabusaa/argocd-example-apps.git"
  destinations:
  - namespace: ns-1
    server: "https://kubernetes.default.svc"
  clusterResourceWhitelist:
  - group: '*'
    kind: 'Namespace'
  namespaceResourceWhitelist:
  - group: 'apps'
    kind: 'Deployment'
```
### Create Project, Blacklist specific Namespace scoped resources
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Dev project
  sourceRepos: # Only permit this Git repos
    - "https://github.com/mabusaa/argocd-example-apps.git"

  destinations:
  - namespace: ns-1
    server: "https://kubernetes.default.svc"

  clusterResourceWhitelist: # Deny all cluster scoped resources from being created, except for Namespace
  - group: '*'
    kind: 'Namespace'

  namespaceResourceBlacklist: # Allow all namespaced scoped resources to be created, except for NetworkPolicy
  - group: '*'
    kind: NetworkPolicy
```
## Create Project and application in that project
1. Create Project
```
kubectl apply -f 03-manifest-files/01-project.yaml
```
2. Create application in that project
```
kubectl apply -f 03-manifest-files/01-application.yml
```
***
# Project Roles Feature
- Enables you to create a role with set of policies “permissions” to grant access to a project's applications.
- You can use it to grant CI system a specific access to project applications.
- It must be associated with JWT.
- You can use it to grant oidc groups a specific access to project applications.
### Create Project manifest files with ROles for sync only
```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: prod-project
  namespace: argocd
spec:
  description: Prod project
  sourceRepos: # Only permit this Git repos
    - "https://github.com/raghib1992/argocd-example-apps.git"

  destinations:
  - namespace: ns-1
    server: "https://kubernetes.default.svc"

  clusterResourceWhitelist: # Deny all cluster scoped resources from being created, except for Namespace
  - group: '*'
    kind: '*'

  namespaceResourceWhitelist:
  - group: 'apps'
    kind: 'Deployment'
  roles:
  - name: ci-role
    description: Sync privileges for demo project
    policies:
    - p, proj:demo project:ci role , applications, sync, demo project/*, allow
```
### Create Project
```sh
kubectl apply -f 03-manifest-files/02-project.yaml
```
### Create Application
```sh
kubectl apply -f 03-manifest-files/02-application.yml
```
### Verify Project
```sh
kubectl -n argocd get appproj
kubectl -n argocd describe appproj prod-project
kubectl -n argocd get application prod-app
``` 
### Creating a token
- Project roles is not useful without generating a JWT.
- Generated tokens are not stored in ArgoCD
- To create a token using CLI 
```sh
argocd proj role create-token PROJECT ROLE-NAME
argocd proj role create-token prod-project ci-role

# Output
Create token succeeded for proj:prod-project:ci-role.
  ID: 01b9d114-6a82-419a-ad65-ad3c3c2252f8
  Issued At: 2025-03-03T20:32:16+05:30
  Expires At: Never
  Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJwcm9qOnByb2QtcHJvamVjdDpjaS1yb2xlIiwibmJmIjoxNzQxMDE0MTM2LCJpYXQiOjE3NDEwMTQxMzYsImp0aSI6IjAxYjlkMTE0LTZhODItNDE5YS1hZDY1LWFkM2MzYzIyNTJmOCJ9.cT3SZU1e8_q_G0vCOC1X27IJqi7fNnboKiiUwANgj5I
```
##### Expected output:
```
![alt text](image.png)
```
### Using the token in CLI
- A user can leverage tokens in the cli by either passing them in using the auth token flag or setting the ARGOCD_AUTH_TOKEN environment variable. 
```sh
ARGOCD_AUTH_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJwcm9qOnByb2QtcHJvamVjdDpjaS1yb2xlIiwibmJmIjoxNzQxMDE0MTM2LCJpYXQiOjE3NDEwMTQxMzYsImp0aSI6IjAxYjlkMTE0LTZhODItNDE5YS1hZDY1LWFkM2MzYzIyNTJmOCJ9.cT3SZU1e8_q_G0vCOC1X27IJqi7fNnboKiiUwANgj5I

# Try to delete 
argocd app delete prod-app --auth-token $ARGOCD_AUTH_TOKEN
# Output
FATA[0002] rpc error: code = PermissionDenied desc = permission denied
```
