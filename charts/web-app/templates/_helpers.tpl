{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "web-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "web-app.fullname" -}}
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
{{- define "web-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "web-app.labels" -}}
helm.sh/chart: {{ include "web-app.chart" . }}
{{ include "web-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "web-app.corporateLabels" .  }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "web-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "web-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "web-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "web-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



      # {{- if .Values.existingImageStream.name }}
      #   name: {{ .Values.existingImageStream.name }}:latest
      # {{- else }}
      #   name: {{ include "web-app.fullname" . }}:latest
      # {{- end }}


{{/*
image repo
*/}}
{{- define "web-app.imageRepo" -}}
{{- if and .Values.image.stream .Values.image.stream.name}}
  {{- if .Values.image.registry }}
{{- printf "%s/%s/%s" .Values.image.registry (default .Release.Namespace .Values.image.stream.namespace) .Values.image.stream.name }}
  {{- else }}
{{- printf "\nimage.registry must be specified since .Values.image.stream.name is specified (%s)" .Values.image.stream.name | fail -}}
  {{- end}}
{{- else if .Values.image.repository }}
  {{- if contains "." .Values.image.repository }}
    {{- printf "\n Seems like your image.repositroy includes registry host. Use image.registry for registry host" | fail -}}
  {{- else }}
{{- printf "%s/%s" (default "docker.io" .Values.image.registry) .Values.image.repository }}
  {{- end}}
{{- else }}
{{- printf "\n One of the following must be specified: Either image.repository Or image.stream(name+namespace)" | fail -}}
{{- end }}
{{- end }}

{{/*
host name
*/}}
{{- define "web-app.host" -}}
{{- if .Values.route.host }}
{{- .Values.route.host }}
{{- else if .Values.route.domain }}
{{- printf "%s-%s.%s" .Release.Namespace .Release.Name .Values.route.domain }}
{{- end }}
{{- end }}

{{/*
all host names
*/}}
{{- define "web-app.hosts" -}}
{{- $hosts := prepend .Values.route.extraHosts (include "web-app.host" . ) }}
{{- join "@" $hosts }}
{{- end }}


{{/*
all ports
*/}}
{{- define "web-app.ports" -}}
{{- $ports := prepend .Values.extraPorts .Values.port }}
{{- join "@" $ports }}
{{- end }}

{{- define "web-app.is-statefulset" -}}
{{- ternary "true" "false" (eq .Values.deployment.kind "Statefulset") }}
{{- end -}}


{{- define "web-app.is-job" -}}
{{- ternary "true" "false" (eq .Values.deployment.kind "Job") }}
{{- end -}}

{{/*
volumeClaimTemplates from Persistence(s)
*/}}
{{- define "web-app.hasVolumeclaimtemplatesFromPersistence" -}}
{{- ternary "true" "false" (and (eq (include "web-app.is-statefulset" . ) "true") (or .Values.persistence.enabled .Values.extraPersistence.enabled)) -}}
{{- end -}}

{{- define "web-app.volumeclaimtemplatesFromPersistence" -}}
{{- if .Values.persistence.enabled -}}
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-1
    labels:
      storage.{{ .Values.companyDomain }}/class: '{{ default "default" (ternary "default" .Values.persistence.storageClass (eq .Values.persistence.storageClass "-")) }}'
      {{- include "web-app.selectorLabels" . | nindent 6 }}
  spec:
    accessModes:
      - {{ .Values.persistence.accessMode }}
    resources:
      requests:
        storage:  {{ .Values.persistence.size }}
  {{- if .Values.persistence.storageClass }}
  {{- if (eq "-" .Values.persistence.storageClass) }}
    storageClassName: ""
  {{- else }}
    storageClassName: "{{ .Values.persistence.storageClass }}"
  {{- end }}
  {{- end }}
{{- end -}}
{{- if .Values.extraPersistence.enabled }}
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-2
    labels:
      storage.{{ .Values.companyDomain }}/class: '{{ default "default" (ternary "default" .Values.extraPersistence.storageClass (eq .Values.extraPersistence.storageClass "-")) }}'
      {{- include "web-app.selectorLabels" . | nindent 6 }}
  spec:
    accessModes:
      - {{ .Values.extraPersistence.accessMode }}
    resources:
      requests:
        storage: {{ .Values.extraPersistence.size }}
  {{- if .Values.extraPersistence.storageClass }}
  {{- if (eq "-" .Values.extraPersistence.storageClass) }}
    storageClassName: ""
  {{- else }}
    storageClassName: "{{ .Values.extraPersistence.storageClass }}"
  {{- end }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/* Volumes from persistence*/}}
{{- define "web-app.hasVolumesFromPersistence" -}}
{{- ternary "true" "false" (and (not (eq (include "web-app.is-statefulset" . ) "true")) (or .Values.persistence.enabled .Values.extraPersistence.enabled)) }}
{{- end -}}

{{- define "web-app.volumesFromPersistence" -}}
{{- if .Values.persistence.enabled }}
- name: pvc-1
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.existingClaim | default (include "web-app.fullname" .) }}
{{- end -}}
{{- if .Values.extraPersistence.enabled }}
- name: pvc-2
  persistentVolumeClaim:
    claimName: {{ include "web-app.fullname" . }}-extra
{{- end -}}
{{- end -}}

{{/*
seal scopes
*/}}
{{- define "web-app.seal-scopes" -}}
{{- list "cluster-wide" "namespace-wide" "strict" }}
{{- end }}
{{/*
Helm Release Parts : {proj}-{app}-{env}
*/}}
{{- define "web-app.releaseNameMatch" }}
{{- if not (mustRegexMatch "^[a-z0-9]+-+[a-z0-9-]+-+[a-z]{2,}$" .Release.Name) }}
{{- fail "Helm Release Name does not match the pattern : {proj}-{app}-{env}." }}
{{- else }}
  {{- if not (mustRegexMatch "^[a-z0-9]+-+[a-z0-9-]+-+(dev|ci|qa|staging|prod)$" .Release.Name) }}
  {{- fail "Helm Release Name does not match the pattern : {proj}-{app}-{env}. And {env} must be either: dev, qa, staging or prod" }}
  {{- else }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "web-app.env" }}
{{- include "web-app.releaseNameMatch" . }}
{{- regexFind "[^-]+$" .Release.Name }}
{{- end }}

{{- define "web-app.project" }}
{{- include "web-app.releaseNameMatch" . }}
{{- regexFind "^[^-]*[^-]" .Release.Name }}
{{- end }}

{{- define "web-app.app" }}
{{- include "web-app.releaseNameMatch" . }}
{{- trimAll "-" (trimSuffix (include "web-app.env" .) (trimPrefix (include "web-app.project" .) .Release.Name)) }}
{{- end }}

{{- define "web-app.appUniq" }}
{{- include "web-app.releaseNameMatch" . }}
{{- regexReplaceAll "-[^-]*$" .Release.Name "" }}
{{- end }}

{{/*
 Corporate Labels
*/}}
{{- define "web-app.corporateLabels" -}}
{{ .Values.companyDomain }}/project: {{ include "web-app.project" . }}
{{ .Values.companyDomain }}/app: {{ include "web-app.app" . }}
{{ .Values.companyDomain }}/environment: {{ include "web-app.env" . }}
{{- end }}