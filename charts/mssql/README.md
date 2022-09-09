> WE ARE WELCOMING YOUR CONTRIBUTION

# Microsoft SQL Server Helm Chart

TODO

# Design

- Design it as per Bitnami Helm charts: https://github.com/bitnami/charts/blob/master/bitnami/mssql/values.yaml
- Design for `architecture: replication` using this sample: `https://github.com/microsoft/sql-server-samples/blob/master/samples/containers/replication/docker-compose.yml`

# Implement
- Implement it as per this chart: https://github.com/microsoft/mssql-docker/blob/master/linux/sample-helm-chart/values.yaml
- Customize entrypoint with init scripts and others: https://github.com/twright-msft/mssql-node-docker-demo-app

- Persistence for data/logs/backup: https://gist.github.com/dbafromthecold/3dd0330afce4c7d1c08612bf393f9c99