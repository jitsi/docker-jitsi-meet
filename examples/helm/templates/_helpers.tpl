{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jitsi-meet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jitsi-meet.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jitsi-meet.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "jitsi-meet.labels" -}}
helm.sh/chart: {{ include "jitsi-meet.chart" . }}
{{ include "jitsi-meet.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "jitsi-meet.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jitsi-meet.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jitsi-meet.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "jitsi-meet.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
  https://github.com/helm/helm/issues/4535
*/}}
{{- define "call-nested" }}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 }}
{{- $template := index . 2 }}
{{- include $template (dict "Chart" (dict "Name" $subchart) "Values" (index $dot.Values $subchart) "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end }}

{{- define "jitsi-meet.xmpp.domain" -}}
{{- if  .Values.xmpp.domain -}}
  {{ .Values.xmpp.domain }}
{{- else -}}
  {{ .Release.Namespace }}.svc
{{- end -}}
{{- end -}}

{{- define "jitsi-meet.xmpp.server" -}}
{{- if .Values.prosody.server -}}
  {{ .Values.prosody.server }}
{{- else -}}
  {{ include "call-nested" (list . "prosody" "prosody.fullname") }}.{{ .Release.Namespace }}.svc
{{- end -}}
{{- end -}}


{{- define "jitsi-meet.publicURL" -}}
{{- if .Values.publicURL }}
{{- .Values.publicURL -}}
{{- else -}}
{{- if .Values.web.ingress.tls -}}https://{{- else -}}http://{{- end -}}
{{- if .Values.web.ingress.tls -}}
{{- (.Values.web.ingress.tls|first).hosts|first -}}
{{- else if .Values.web.ingress.hosts -}}
{{- (.Values.web.ingress.hosts|first).host -}}
{{ required "You need to define a publicURL or some value for ingress" .Values.publicURL }}
{{- end -}}
{{- end -}}
{{- end -}}
