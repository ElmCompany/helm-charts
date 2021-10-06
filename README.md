# Overview
Deploy docker daemon on top of kuberentes with sshd enabled.

Useful for accessing remote docker daemon thru ssh : `docker context create remote --docker "host=ssh://root@SERVICENAME.NAMESPACE"`


# Values

Check default Values of this chart [here]( 
https://bitbucket.elm.sa/projects/SCL/repos/helm-chart-docker-dind-sshd/browse/docker-dind-sshd/values.yaml)

# How to install the app 

Check instructions at right sidebar in [DevOps Appstore](https://appstore.devops.elm.sa/charts/elm/docker-dind-sshd)


# Authors

This chart is maintained by: 
- Abdennour Toumi <atoumi@elm.sa>

# License

LGPL v3