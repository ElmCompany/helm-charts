# Overview

Provisioning k8s service which points to external service ( external IP/Host and external port).
Optionally, you can expose that service thru ingress.

# Values

Check default Values of this chart [here]( 
https://github.com/ElmCompany/helm-charts/blob/master/charts/external-service/values.yaml)

# How to install the app 

**Set Elm Repo**

```sh

helm repo add elm https://raw.githubusercontent.com/ElmCompany/helm-charts/gh-pages
helm repo update
```

**Use it** `helm install elm/external-service -f values.sample.yaml`

# Authors

This chart is maintained by: 
- Abdennour Toumi <atoumi@elm.sa>

# License

LGPL v3