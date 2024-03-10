# Project

### Projects provide a logical grouping of applications.
### Useful when ArgoCD is used by multiple teams.
- Allow only specific sources "trusted git repos"
- Allow apps to be deployed into specific clusters and namespaces
- Allow specific resources to be deployed "Deployments, Statefulsets .. etc"
### Creating Projects Options
- Declaratively
- CLI
- Web UI

#### Declarative approach
1. Create yaml file
- project.yaml
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
- project.yaml for specific namespace and destination 
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
  - namespace: ns-1
    server: "https://kubernetes.default.svc"

  clusterResourceWhitelist:
  - group: '*'
    kind: '*'

  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```
- project.yaml for Specific Source Repo
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
    kind: '*'

  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```

- Allow specific Cluster scoped resources
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

- Allow specific Namespace scoped resources
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

- Blacklist specific Namespace scoped resources
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

## Project Roles Feature
- Enables you to create a role with set of policies “permissions” to grant access to a project's applications.
- You can use it to grant CI system a specific access to project applications.
- It must be associated with JWT.
- You can use it to grant oidc groups a specific access to project applications.

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
  - group: 'apps'
    kind: 'Deployment'
  roles:
  - name: ci role
    description: Sync privileges for demo project
    policies:
    - p, proj:demo project:ci role , applications, sync, demo project/*, allow
```
### Creating a token
- Project roles is not useful without generating a JWT.
- Generated tokens are not stored in ArgoCD
- To create a token using CLI 
```
argocd proj role create-token PROJECT ROLE-NAME
```
##### Expected output:
```
![alt text](image.png)
```
### Using the token in CLI
- A user can leverage tokens in the cli by either passing them in using the auth token flag or setting the ARGOCD_AUTH_TOKEN environment variable. 
```
argocd cluster list --auth-token token-value
```