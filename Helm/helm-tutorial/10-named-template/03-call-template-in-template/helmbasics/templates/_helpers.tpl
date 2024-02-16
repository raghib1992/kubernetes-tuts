{{/* Common Labels*/}}
{{- define "helmbasics.labels" }}
    app: nginx
    template-in-template: {{ include "helmbasics.resourceName" . }}
{{- end }}

{{/*  k8s Resource Name */}}
{{- define "helmbasics.resourceName" }}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end}}