{{- if .Values.existingDockerDaemon.enabled }}
#!/bin/bash
adduser {{ .Values.existingDockerDaemon.sshUser }} -g docker
su docker -s /bin/mkdir -p /home/{{ .Values.existingDockerDaemon.sshUser }}/.ssh
chmod 700 /home/{{ .Values.existingDockerDaemon.sshUser }}/.ssh

su {{ .Values.existingDockerDaemon.sshUser }} -s /bin/touch /home/{{ .Values.existingDockerDaemon.sshUser }}/.ssh/authorized_keys
chmod 600 /home/{{ .Values.existingDockerDaemon.sshUser }}/.ssh/authorized_keys
echo "{{ .Values.sshKeys.public }}" >> /home/{{ .Values.existingDockerDaemon.sshUser }}/.ssh/authorized_keys

sed -i 's/MaxSessions.*/MaxSessions {{ .Values.existingDockerDaemon.sshMaxSessions }}/g; s/#MaxSessions/MaxSessions/g' /etc/ssh/sshd_config

systemctl restart sshd
{{- else }}
echo "There will be a script only if you specify existingDockerDaemon.enabled=true"
{{- end }}