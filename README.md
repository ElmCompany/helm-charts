# Overview
  Run Single Page Apps (React, VueJS, AngularJS) on top of Nginx while
  accepting configuration as env vars
  More details about the history of this [architecture here](https://wiki.elm.sa/display/TAKS/SPA+compliance+with+12factors+and+cloud-native)

# Prerequisites

1. Make sure that your SPA app is refactored for 12factor compliance, and namely app configuration are externalized not baked with the final JS bundle file.

- **Angular** check tuto [here](https://wiki.elm.sa/display/TAKS/2021/04/26/Tutorial+-+Refactor+Angular+app+for+CICD+Pipeline+Compliance)

- **React** check tuto [here](https://wiki.elm.sa/display/TAKS/2021/04/26/Tutorial+-+Refactor+React+app+for+CICD+Pipeline+Compliance)

2. Base your runtime image on `nexus.elm.sa/nginxinc/nginx-unprivileged:1.19-alpine`. Example of Dockerfile [here](https://bitbucket.elm.sa/projects/RM/repos/boilerplate-pipeline/browse/img-frontend.Dockerfile) which is a multistage dockerfile.

3. All app env vars are prefixed with a unified prefix: `REACT_APP_*` with React apps, `NG_APP_` with Angular apps,.. so on
# Values

Check default Values of this chart [here](
https://bitbucket.elm.sa/projects/SCL/repos/helm-chart-single-page-app/browse/single-page-app/values.yaml)

# How to install the app

Check instructions at right sidebar in [DevOps Appstore](https://appstore.devops.elm.sa/charts/elm/single-page-app)


# Authors

This chart is maintained by:

- Abdennour Toumi <atoumi@elm.sa>
- Ahmed Alharthi <ahalharthi@elm.sa>

# License

LGPL v3