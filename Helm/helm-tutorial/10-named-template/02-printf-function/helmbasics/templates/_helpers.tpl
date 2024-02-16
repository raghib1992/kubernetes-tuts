{{/* Common Labels */}}
{{- define "helmbasics.labels" }}
  app: nginx
{{- end }}


{{/* k8s Resource Name: tring COncat with Hyphen */}}
{{- define "helmbasics.resourceName" }}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}