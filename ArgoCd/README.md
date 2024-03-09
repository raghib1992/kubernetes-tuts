1. What is gitops
- Infrastructure as code, Configuration as code.
- Collaboration + change mechanism (Code review)
- Continues integration and continues delivery pipelines.
- Push model
- Pull model


2. What is ArgoCD
- It is a Gitops based CD with pull model design
- ArgoCD is a GitOps continues delivery tool for Kubernetes.
- ArgoCd is not a CI tools
- Git as the source of truth.
    - Developer and DevOps engineer will update the Git code only.
- Keep your cluster in sync with Git.
- Easy rollback.
- More security : Grant access to ArgoCD only.
- Disaster recovery solution : You easily deploy the same apps to any k8s cluster

3. Application
- define source and destination to deplaoy group of k8s resources
- APllication consists two things:
    - Source: k8s manifests.
    - Destination: cluster and namespace.
- Apllication source tools
    - Helm chart
    - Kustomize app
    - Directory of YAML files
    - Josnnet

4. Project
- Logical grouping of application


5. Desired state and actual state

6. Sync
- Process of making desired state to actual state

7. Refresh (Compare)
- Argo CD auto refresh in every 3 min
- Compare latest code in git with the live state. Figure out what is different

8. Architecture
- ArgoCD consist of 3 main components
    1. ArgoCD Server (API + Web Server).
        - Its a gRPC /REST server which exposes the API consumed by the Web UI, CLI.
        - Application management (Create, Update, Delete).
        - Application operations (ex: Sync, Rollback)
        - Repos and clusters management.
        - Authentication.
    2. ArgoCD Repo Server.
        - Clone git repo.
        - Generate k8s manifests.
    3. ArgoCD Application Controller.
        - Its a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state.
        - Communicate with Repo server to get the generated manifests.
        - Communicate with k8s API to get actual cluster state.
        - Deploy apps manifests to destination clusters.
        - Detects OutofSync Apps and take corrective actions “If needed”.
        - Invoking user defined hooks for lifecycle events PreSync , Sync, PostSync
    4. Additional Components
        - Redis: used for caching.
        - Dex: identity service to integrate with external identity providers.
        - ApplicationSet Controller : It automates the generation of Argo CD Applications.