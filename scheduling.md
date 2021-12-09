# Manual Scheduling
## specify nodeName in spec of the pod definition file
pod-definition.yaml
```
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: web
        env: prod
        tier: front-end
spec:
    containers:
    - name: nginx-container
      image: nginx
    nodeName: node02
```
## Assign a node to the existing pod
### Create a binding request
pod-binding-deinition.yaml
```
apiVersion: v1
kind: Binding
metadata:
    name: nginx
target:
    apiVersion: v1
    kind: Node
    name: node02
```
Convert the yaml into equivalent JSON format
```
curl --header "Content-Type:application/json" --request POST --data '{"apiVersion: "v1", "kind": "Binding", "metadata": {"name": "nginx"}, "target": {"apiVersion": "v1", "kind": "Node", "name": "node01"}}' http://$SERVER/api/v1/namespaces/default/pods/$PODNAME/binding/
```