
{{- define "jitsi-meet.jvb.fullname" -}}
{{ include "jitsi-meet.fullname" . }}-jvb
{{- end -}}

{{- define "jitsi-meet.jvb.labels" -}}
{{ include "jitsi-meet.labels" . }}
app.kubernetes.io/component: jvb
{{- end -}}

{{- define "jitsi-meet.jvb.selectorLabels" -}}
{{ include "jitsi-meet.selectorLabels" . }}
app.kubernetes.io/component: jvb
{{- end -}}

{{- define "jitsi-meet.jvb.secret" -}}
{{ include "call-nested" (list . "prosody" "prosody.fullname") }}-jvb
{{- end -}}
