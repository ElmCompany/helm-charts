# Overview
Envoy proxy for any service, easy to install & easy to configure.
Ability to proxy:
 - https traffic & expose it as http traffic
 - S3 endpoint (Cloud or on-prem like MinIO)


# Values

Check default Values of this chart [here]( 
https://github.com/ElmCompany/helm-charts/blob/master/charts/service-proxy/values.yaml)

# How to install the app 

**Set Elm Repo**

```sh

helm repo add elm https://raw.githubusercontent.com/ElmCompany/helm-charts/gh-pages
helm repo update
```

**Use it** `helm install elm/service-proxy -f values.sample-http-https.yaml`

# Authors

This chart is maintained by: 
- @abdennour

# License

LGPL v3