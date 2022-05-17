# Overview
By default, this helm charts deploys docker daemon (DinD) on top of kuberentes with sshd enabled & ready to be integrated with any docker client ( CI workload, .. etc).

Optionally, the helm charts can be used to point to an existing Docker Daemon instead of creating the daemon from scratch. It's done by `existingDockerDaemon.enabled=true`.

Useful also for accessing remote docker daemon thru ssh : `docker context create remote --docker "host=ssh://USER@SERVICENAME.NAMESPACE"`


# Values

Check default Values of this chart [here]( 
https://github.com/ElmCompany/helm-charts/blob/master/charts/docker-daemon-sshd/values.yaml)

# How to install the app 

TODO. In the meantime, Check the output of `helm status` after installing the chart.

# Authors

This chart is maintained by: 
- @abdennour 

# License

LGPL v3