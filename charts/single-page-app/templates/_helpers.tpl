{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "single-page-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "single-page-app.fullname" -}}
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
{{- define "single-page-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "single-page-app.labels" -}}
helm.sh/chart: {{ include "single-page-app.chart" . }}
{{ include "single-page-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "single-page-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "single-page-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "single-page-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "single-page-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



      # {{- if .Values.existingImageStream.name }}
      #   name: {{ .Values.existingImageStream.name }}:latest
      # {{- else }}
      #   name: {{ include "single-page-app.fullname" . }}:latest
      # {{- end }}


{{/*
host name
*/}}
{{- define "single-page-app.imageRepo" -}}
{{- if .Values.image.repository }}
{{- .Values.image.repository }}
{{- else }}
{{- printf "%s/%s/%s" .Values.image.stream.registry .Values.image.stream.namespace .Values.image.stream.name }}
{{- end }}
{{- end }}

{{/*
host name
*/}}
{{- define "single-page-app.host" -}}
{{- if .Values.route.host }}
{{- .Values.route.host }}
{{- else if .Values.route.domain }}
{{- printf "%s-%s.%s" .Release.Namespace .Release.Name .Values.route.domain }}
{{- end }}
{{- end }}

{{/*
all host names
*/}}
{{- define "single-page-app.hosts" -}}
{{- $hosts := prepend .Values.route.extraHosts (include "single-page-app.host" . ) }}
{{- join "@" $hosts }}
{{- end }}