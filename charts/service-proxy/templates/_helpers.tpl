{{/*
Expand the name of the chart.
*/}}
{{- define "service-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "service-proxy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "service-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "service-proxy.labels" -}}
helm.sh/chart: {{ include "service-proxy.chart" . }}
{{ include "service-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "service-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "service-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "service-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
host name
*/}}
{{- define "service-proxy.host" -}}
{{- if .Values.route.host }}
{{- .Values.route.host }}
{{- else if .Values.route.domain }}
{{- printf "%s-%s.%s" .Release.Namespace .Release.Name .Values.route.domain }}
{{- end }}
{{- end }}
{{- define "service-proxy.adminHost" -}}
{{- if .Values.adminRoute.host }}
{{- .Values.adminRoute.host }}
{{- else if .Values.adminRoute.domain }}
{{- printf "%s-%s.%s" .Release.Namespace .Release.Name .Values.adminRoute.domain }}
{{- end }}
{{- end }}

{{/*
all host names
*/}}
{{- define "service-proxy.hosts" -}}
{{- $hosts := prepend .Values.route.extraHosts (include "service-proxy.host" . ) }}
{{- join "@" $hosts }}
{{- end }}

{{- define "service-proxy.adminHosts" -}}
{{- $hosts := prepend .Values.adminRoute.extraHosts (include "service-proxy.adminHost" . ) }}
{{- join "@" $hosts }}
{{- end }}

{{/*
caCert handling
*/}}
{{- define "service-proxy.backendServiceHasCaCert" }}
{{- or .Values.backendService.caCert .Values.backendService.caCertConfigmap.name }}
{{- end}}

{{- define "service-proxy.backendServiceCaCertConfigmapName" }}
{{- if .Values.backendService.caCert }}
{{- printf "%s-ca" (include "service-proxy.fullname" .) }}
{{- else if .Values.backendService.caCertConfigmap.name }}
{{- .Values.backendService.caCertConfigmap.name }}
{{- end }}
{{- end }}
