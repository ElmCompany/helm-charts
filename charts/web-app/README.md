# Overview
This chart installs any application on top of kubernetes cluster.
For the time being, it's compatible with Openshift 3.11.

This is a very generic chart that installs any web app as per the given values. If your app requires:
-  a single deployment(pod), 
- with a single container
- with a single service port
And optionally:
- or/and exposing a hostname thru route or ingress
- or/and creating/attaching persistence volume claim
- or/and populating environment variables thur secret.
- or/and mounting a single config file

If so, this chart should answer your needs.

# Values

Check default Values of this chart [here](https://github.com/ElmCompany/helm-charts/blob/master/charts/webapp/values.yaml)

# How to install the app 

**Set Elm Repo**
```sh
helm repo add elm https://raw.githubusercontent.com/ElmCompany/helm-charts/gh-pages
helm repo update
```

**Use it** `helm install elm/webapp`

# Authors

This chart is maintained by: 
- @abdennour 

# License

LGPL v3