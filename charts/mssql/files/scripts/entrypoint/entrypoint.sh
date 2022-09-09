#!/bin/bash
# tail --pid $$ -F /var/opt/mssql/log/*.log & \
bash /tmp/entrypoint-scripts/init.sh & \
  /opt/mssql/bin/sqlservr
# in case of mssql 2017 : /opt/mssql/bin/sqlserver
