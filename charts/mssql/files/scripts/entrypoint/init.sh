#!/bin/bash
{{- if or .Values.initdbScriptsConfigMap .Values.initdbScripts (and .Values.auth.createDatabase .Values.auth.database) }}
# env var :
### ${SA_PASSWORD}
### ${MSSQL_DATABASE}
### ${MSSQL_DATABASE_COLLATE}
### ${DB_INIT_SCRIPTS_DIR}

set -e
export DB_INIT_SCRIPTS_DIR=/tmp/docker-entrypoint-initdb.d

echo "running the setup script .."
sleep 40

export IS_DB_INITIALIZED={{ .Values.primary.persistence.mount }}/$MSSQL_DATABASE.initialized
export IS_SQLSCRIPTS_INITIALIZED={{ .Values.primary.persistence.mount }}/initsqlscripts.initialized
function db_init() {
  {{- if and .Values.auth.createDatabase .Values.auth.database }}

    if [ ! -f "${IS_DB_INITIALIZED}" ]; then
        /opt/mssql-tools/bin/sqlcmd -U sa -P "$SA_PASSWORD" -Q "CREATE DATABASE ${MSSQL_DATABASE} COLLATE ${MSSQL_DATABASE_COLLATE}"
        if [ "$?" = "0" ]; then
          touch ${IS_DB_INITIALIZED}
        fi
    fi
  {{- end }}
  {{- if or .Values.initdbScriptsConfigMap .Values.initdbScripts }}

    if [ ! -f "${IS_SQLSCRIPTS_INITIALIZED}" ]; then
      for f in $(ls $DB_INIT_SCRIPTS_DIR/*.sql 2> /dev/null); do
      {{- if and .Values.auth.createDatabase .Values.auth.database }}
        sed -i "s/<DB_NAME>/${MSSQL_DATABASE}/g" $f
      {{- end }}
        echo "- running init db script $f .."
        result=$(/opt/mssql-tools/bin/sqlcmd -U sa -P "$SA_PASSWORD" -i "$f")
        echo "- result: $result"
      done
      if [ "$?" = "0" ]; then
        touch ${IS_SQLSCRIPTS_INITIALIZED}
      fi
    fi
  {{- end }}
}

if [ ! -f "${IS_DB_INITIALIZED}" ] || [ ! -f "${IS_SQLSCRIPTS_INITIALIZED}" ]; then
  echo "running init sql scripts .."
  for i in {1..50};
  do
      db_init;
      if [ $? -eq 0 ]
      then
          echo "\nall sql scripts run is completed!"
          break
      else
          printf "..."
          sleep 3
      fi
  done
fi
{{- end }}