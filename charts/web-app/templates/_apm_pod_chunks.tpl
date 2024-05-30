{{- define "web-app.apmRuntimeDefined" }}
{{- if and .Values.apm.enabled (not (has .Values.apm.runtime .Values.apmProvider.supportedRuntimes)) }}
{{- fail (printf ".Values.apm.runtime must be set . Choose Value from the following: %s" (.Values.apmProvider.supportedRuntimes | join "|")) }}
{{- end }}
{{- end }}

{{- define "web-app.apmEnvFrom" -}}
- configMapRef:
    name: apm-{{ include "web-app.fullname" . }}
- secretRef:
    name: apm-{{ include "web-app.fullname" . }}
{{- end -}}

{{- define "web-app.apmInitContainers" -}}
- name: apm-init
  image: {{printf "%s/cloudnative/sidecar-elastic-apm-agent:%s" .Values.image.registry .Values.apm.imageTag }}
  command:
    - sh
    - -c
    - >-
      cp -r /agents/* /tmp/apm-agents/;
  volumeMounts:
    - name: apm-agents
      # /elastic-apm-agent.jar
      mountPath: /tmp/apm-agents
{{- end -}}

{{- define "web-app.apmVolumeMounts" -}}
- name: apm-agents
  mountPath: "{{ include "web-app.apmAgentMountPath" . }}"
{{- end -}}

{{- define "web-app.apmVolumes" -}}
- name: apm-agents
  emptyDir: {}
{{- end -}}

{{- define "web-app.apmAgentMountPath" }}
{{- printf "/tmp/apm-agents" }}
{{- end }}

{{- define "web-app.apmJavaOpts" }}
{{- if .Values.envVars.JAVA_OPTS }}
{{- printf "-javaagent:%s/elastic-apm-agent.jar %s" (include "web-app.apmAgentMountPath" . ) (.Values.envVars.JAVA_OPTS | trim) }}
{{- else }}
{{- printf "-javaagent:%s/elastic-apm-agent.jar" (include "web-app.apmAgentMountPath" . ) }}
{{- end }}
{{- end }}