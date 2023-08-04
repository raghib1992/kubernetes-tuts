# Create the ConfigMap
kubectl create configmap game-config --from-file=configure-pod-container/configmap/

kubectl describe configmaps game-config

kubectl get configmaps game-config -o yaml


kubectl create configmap game-config-2 --from-file=configure-pod-container/configmap/game.properties

kubectl create configmap game-config-2 --from-file=configure-pod-container/configmap/game.properties --from-file=configure-pod-container/configmap/ui.properties


kubectl create configmap game-config-env-file \
       --from-env-file=configure-pod-container/configmap/game-env-file.properties

kubectl create configmap config-multi-env-files \
        --from-env-file=configure-pod-container/configmap/game-env-file.properties \
        --from-env-file=configure-pod-container/configmap/ui-env-file.properties

# Define the key to use when creating a ConfigMap from a file
kubectl create configmap game-config-3 --from-file=<my-key-name>=<path-to-file>


# Create ConfigMaps from literal values 
kubectl create configmap special-config --from-literal=special.how=very --from-literal=special.type=charm


Apply the kustomization directory to create the ConfigMap object:
kubectl apply -k .
