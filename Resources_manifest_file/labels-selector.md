# Labels and Selector
Labels are applied on the pods and selector are used with replica sets and deployment to identify the pods with the match labels

## search pod with labels
```
kubeclt get pods --selector <key>=<value>
```