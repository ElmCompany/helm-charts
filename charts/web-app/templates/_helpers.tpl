{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "webapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webapp.fullname" -}}
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
{{- define "webapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webapp.labels" -}}
helm.sh/chart: {{ include "webapp.chart" . }}
{{ include "webapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "webapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webapp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



      # {{- if .Values.existingImageStream.name }}
      #   name: {{ .Values.existingImageStream.name }}:latest
      # {{- else }}
      #   name: {{ include "webapp.fullname" . }}:latest
      # {{- end }}


{{/*
image repo
*/}}
{{- define "webapp.imageRepo" -}}
{{- if .Values.image.repository }}
{{- .Values.image.repository }}
{{- else }}
{{- printf "%s/%s/%s" .Values.image.stream.registry .Values.image.stream.namespace .Values.image.stream.name }}
{{- end }}
{{- end }}

{{- define "webapp.imageTag" -}}
{{- if .Values.image.tag }}
{{- .Values.image.tag }}
{{- else }}
{{- .Chart.AppVersion }}
{{- end }}
{{- end }}

{{- define "webapp.cronjobImageTag" -}}
{{- if .Values.cronjob.image.tag }}
{{- .Values.cronjob.image.tag }}
{{- else }}
{{- .Chart.AppVersion }}
{{- end }}
{{- end }}

{{/*
host name
*/}}
{{- define "webapp.host" -}}
{{- if .Values.route.host }}
{{- .Values.route.host }}
{{- else if .Values.route.domain }}
{{- printf "%s-%s.%s" .Release.Namespace .Release.Name .Values.route.domain }}
{{- end }}
{{- end }}

{{/*
all host names
*/}}
{{- define "webapp.hosts" -}}
{{- $hosts := prepend .Values.route.extraHosts (include "webapp.host" . ) }}
{{- join "@" $hosts }}
{{- end }}

{{/*
seal scopes
*/}}
{{- define "webapp.seal-scopes" -}}
{{- list "cluster-wide" "namespace-wide" "strict" }}
{{- end }}