{{- define "web-app.pod" -}}
{{- if eq .Values.deployment.kind "Job" }}
restartPolicy: {{ .Values.job.restartPolicy }}
{{- end }}
{{- if .Values.image.pullSecret }}
imagePullSecrets:
  - name: {{ .Values.image.pullSecret }}
{{- end }}
{{ if .Values.serviceAccount.create }}
serviceAccount: {{ include "web-app.serviceAccountName" . }}
serviceAccountName: {{ include "web-app.serviceAccountName" . }}
{{ end }}
{{- with .Values.podSecurityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if or .Values.initContainers .Values.apm.enabled }}
initContainers:
{{- end }}
{{- if .Values.apm.enabled }}
  {{- (include "web-app.apmRuntimeDefined" .) }}
  {{- include "web-app.apmInitContainers" . | nindent 2 -}}
{{- end }}
{{- with .Values.initContainers }}
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- with .Values.hostAliases  }}
hostAliases:
  {{- toYaml . | nindent 2 }}
{{- end }}
containers:
{{- with .Values.containers }}
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
  - name: {{ include "web-app.fullname" . }}
    {{- with .Values.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    image: "{{ include "web-app.imageRepo" . }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- with .Values.command }}
    command:
      {{- tpl (toYaml .) $ | nindent 6 }}
    {{- end }}
    {{- with .Values.args }}
    args:
      {{- tpl (toYaml .) $ | nindent 6 }}
    {{- end }}
    {{- with .Values.lifecycle  }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    ports:
    {{- range $index,$port := ( splitList "@" (include "web-app.ports" . )) }}
      - name: {{ printf "%s" (ternary "http" (printf "tcp-%s" $port) (eq $index 0)) }}
        containerPort: {{  $port | int }}
        protocol: TCP
    {{- end }}
  {{- with .Values.env }}
    env:
    {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- if .Values.deployment.mountEnvVars }}
    {{- if or .Values.envVars .Values.envVarsSealed .Values.envFrom .Values.apm.enabled }}
    envFrom:
    {{- end }}
    {{- with .Values.envVars }}
      - secretRef:
          name: {{ include "web-app.fullname" $ }}-env-vars
    {{- end }}
    {{- with .Values.envVarsSealed }}
      - secretRef:
          name: {{ include "web-app.fullname" $ }}-env-vars-sealed
    {{- end }}
    {{- if .Values.apm.enabled }}
      {{- include "web-app.apmEnvFrom" . | nindent 6 -}}
    {{- end }}
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- end }}
    {{- with .Values.startupProbe }}
    startupProbe:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.livenessProbe }}
    livenessProbe:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.readinessProbe }}
    readinessProbe:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if or .Values.volumeMounts .Values.configFile.mount .Values.persistence.enabled .Values.extraPersistence.enabled .Values.apm.enabled }}
    volumeMounts:
    {{- end }}
    {{- with .Values.volumeMounts }}
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if .Values.configFile.mount }}
      - mountPath: {{ .Values.configFile.mount }}
        name: config-file
        readOnly: true
    {{- end }}
    {{- if .Values.persistence.enabled }}
      - name: pvc-1
        mountPath: {{ .Values.persistence.mount }}
    {{- end }}
    {{- if .Values.extraPersistence.enabled }}
      - name: pvc-2
        mountPath: {{ .Values.extraPersistence.mount }}
        readOnly: {{ .Values.extraPersistence.readOnly }}
    {{- end }}
    {{- if .Values.apm.enabled }}
      {{- include "web-app.apmVolumeMounts" . | nindent 6 -}}
    {{- end}}
    {{- with .Values.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
{{- if or .Values.volumes .Values.configFile.mount .Values.apm.enabled (eq (include "web-app.hasVolumesFromPersistence" .) "true") }}
volumes:
{{- end }}
{{- with .Values.volumes }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.configFile.mount }}
  - name: config-file
    configMap:
      defaultMode: 420
      name: {{ include "web-app.fullname" . }}-file
      # items:
      #   - key: {{ .Values.configFile.name }}
      #     path: {{ .Values.configFile.name }}
{{- end }}
# Volumes From Persistence
  {{- if eq (include "web-app.hasVolumesFromPersistence" .) "true" }}
  {{- include "web-app.volumesFromPersistence" . | indent 2 -}}
  {{- end }}
{{- if .Values.apm.enabled }}
  {{- include "web-app.apmVolumes" . | nindent 2 -}}
{{- end}}

{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if and (or .Values.autoscaling.enabled (gt (int .Values.replicaCount) 1)) (not .Values.affinity)}}
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/instance
            operator: In
            values:
            - {{ .Release.Name }}
          - key: app.kubernetes.io/name
            operator: In
            values:
            - {{ include "web-app.name" . }}
        topologyKey: kubernetes.io/hostname
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}