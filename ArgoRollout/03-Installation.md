
# Argo Rollout Installation System Requirement
1. kubernetes version 1.16 or above
2. CLuster Configuration: valid kubeconfig file
3. Resources Allocation: Allocate CPU and memory for argo rollout controller
4. Network Setup: configured network for traffic routing
5. Permission: Need RBAC to manage k8s resources

# Install argo rollout
### Step1: Install kubectl
### Step2: Create namespace argo-rollouts
```
kubectl create ns argo-rollouts
```
### Step3: Install argo rollout
```
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```
### Step 4: Install plugins
- The kubectl plugin is optional, but is convenient for managing and visualizing rollouts from the command line.
- Brew
```
brew install argoproj/tap/kubectl-argo-rollouts
```
- **Manual**
- Install Argo Rollouts Kubectl plugin with curl.
```sh
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-darwin-amd64
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
# For Linux dist, replace darwin with linux
```
- Make the kubectl-argo-rollouts binary executable.
```sh
chmod +x ./kubectl-argo-rollouts-darwin-amd64
# Linux
chmod +x ./kubectl-argo-rollouts-linux-amd64
```
- Move the binary into your PATH.
```sh
sudo mv ./kubectl-argo-rollouts-darwin-amd64 /usr/local/bin/kubectl-argo-rollouts

# Linux
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
```
- Test to ensure the version you installed is up-to-date:
```sh
kubectl argo rollouts version
```
 
