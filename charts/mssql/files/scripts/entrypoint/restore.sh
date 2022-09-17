#!/bin/bash

{{- if .Values.backup.enabled }}
export database=$1;
export now=$2;

if [ -z "$database" ]; then
  echo ERROR Database name is not specified at the 1st argument
  exit 1
fi
if [ -z "$now" ]; then
  echo "ERROR Backup time is not specified as 2nd argument"
  exit 1
fi

backuppath={{ .Values.backup.persistence.mount }}/$database-$now.bak

if [ -f "${backuppath}" ];then
  echo INFO - DB $database Snapshot found! Restoring...
else
  echo ERROR - No Snapshot Found under $backuppath
  exit 1;
fi

/opt/mssql-tools/bin/sqlcmd \
  -S {{ include "mssql.primary.fullname" . }}.{{ include "common.names.namespace" $ }}.svc.{{ .Values.clusterDomain }} \
  -U sa -P "$SA_PASSWORD" \
  -e -Q "RESTORE DATABASE $database FROM DISK = '$backuppath'"
{{- else }}
printf "WARN No restore script available because"
echo " .Values.backup.enabled is falsy when you deployed this helm chart"
{{- end }}