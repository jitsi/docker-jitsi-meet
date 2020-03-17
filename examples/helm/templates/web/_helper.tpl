
{{- define "jitsi-meet.web.fullname" -}}
{{ include "jitsi-meet.fullname" . }}-web
{{- end -}}

{{- define "jitsi-meet.web.labels" -}}
{{ include "jitsi-meet.labels" . }}
app.kubernetes.io/component: web
{{- end -}}

{{- define "jitsi-meet.web.selectorLabels" -}}
{{ include "jitsi-meet.selectorLabels" . }}
app.kubernetes.io/component: web
{{- end -}}

