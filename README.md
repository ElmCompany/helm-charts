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

Check default Values of this chart [here]( 
https://bitbucket.elm.sa/projects/SCL/repos/helm-chart-generic-app/browse/rabbitmq/values.yaml)

# How to install the app 

Check instructions at right sidebar in [DevOps Appstore](https://appstore.devops.elm.sa/charts/elm/generic-app)


# Authors

This chart is maintained by: 
- Abdennour Toumi <atoumi@elm.sa>

# License

LGPL v3