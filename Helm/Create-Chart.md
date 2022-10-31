By default helm use nginx chart (starter pack) to create chart

1. chart.yaml - It contain metadata of the chart
2. charts folder - If this current chart depends on any other chart that will be packaged and located in charts folder
3. templates folder - contain all the template which render and manager k8s manifests file
4. values.yaml file -It conatin value for manifest file
