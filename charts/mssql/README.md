# MS SQL Packaged By Elm
Microsoft SQL Server is still used by many organizations. And migration to Cloud native can be a blocked by having this technology.
In order to help organization to lift-shift to Cloud Native, they can run also MS SQL in kubernetes via this Helm chart

# TL;DR
```sh
helm repo add elm https://raw.githubusercontent.com/ElmCompany/helm-charts/gh-pages
helm install my-db elm/mssql
```

# Values

Check default Values of this chart [here](https://github.com/ElmCompany/helm-charts/blob/master/charts/mssql/values.yaml) .

Hint:  It's almost identical to values schema of `bitnami/mysql` helm chart.

# Features

1. Applying Bitnami Helm Chart standards [ DONE ✅ ]
   > Same interface (values.yaml schema ) as such bitnami/mysql helm chart values.
   > Ability to specify own registry
   > auto-generate passwords in not given
   > and more...
2. Persisting Data [ DONE ✅ ]
3. Auto Bootstrapping Database 
4. Auto Bootstraping Database Owner User with given password [ DONE ✅ ]
5. Ability to execute initial DB scripts (SQL) [ DONE ✅ ]
6. Performance Monitoring - Integrated with Prometheus Operator [ DONE ✅ ]
7. Persistence for Backup [ TODO ]
8. Replication Architecture [ TODO ]


# Try Sample

Try with [values.sample.yaml](values.sample.yaml)

- `helm -n db upgrade db1 elm/mssql -f values.sample.yaml -i --create-namespace`
- Use MSSQL Client either provided by Visual Code as extension, or by running interactive pod as per the guide when your run: `helm -n db get notes db1`
- Validate in your grafana dashboard
![](../../assets/img/mssql-grafana.jpg)


# Authors

This chart is maintained by: 
- @abdennour 

# License

LGPL v3
