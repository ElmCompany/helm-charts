#!/bin/bash

# env var :
### ${SA_PASSWORD}
### ${MSSQL_DATABASE}
### ${MSSQL_DATABASE_COLLATE}
### ${DB_INIT_SCRIPTS_DIR} /docker-entrypoint-initdb.d

set -e
export DB_INIT_SCRIPTS_DIR=/docker-entrypoint-initdb.d

{{- if or .Values.initdbScriptsConfigMap .Values.initdbScripts (and .Values.auth.createDatabase .Values.auth.database) }}
echo "running the setup script .."
sleep 40
{{- end }}

function db_init() {
  {{- if and .Values.auth.createDatabase .Values.auth.database }}
    if [ ! -z "${MSSQL_DATABASE}" ]; then
        /opt/mssql-tools/bin/sqlcmd -U sa -P "$SA_PASSWORD" -Q "CREATE DATABASE ${MSSQL_DATABASE} ${MSSQL_DATABASE_COLLATE}"
    fi
  {{- end }}
  {{- if or .Values.initdbScriptsConfigMap .Values.initdbScripts }}
    if [ -d "${DB_INIT_SCRIPTS_DIR}" ]; then
      for f in $(ls /docker-entrypoint-initdb.d/*.sql 2> /dev/null); do
        {{- if and .Values.auth.createDatabase .Values.auth.database }}
        sed -i "s/<DB_NAME>/${MSSQL_DATABASE}/g" $f
        {{- end }}
        echo "- running init db script $f .."
        result=$(/opt/mssql-tools/bin/sqlcmd -U sa -P "$SA_PASSWORD" -i "$f")
        echo "- result: $result"
      done
    fi
  {{- end }}
}

echo "running the sql scripts .."
for i in {1..50};
do
    db_init;
    if [ $? -eq 0 ]
    then
        echo "all sql scripts run is completed!"
        break
    else
        echo "not ready yet..."
        sleep 3
    fi
done