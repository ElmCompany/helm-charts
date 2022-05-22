# Overview
  Run Single Page Apps (React, VueJS, AngularJS) on top of Nginx while accepting configuration as env vars
  This helm chart implements [this architecture reference](https://www.jeffgeerling.com/blog/2018/deploying-react-single-page-web-app-kubernetes) and specifically, the "Method 3 - Rearchitect the way your React app loads config"

# Prerequisites

1. Make sure that your SPA app is refactored for 12factor compliance, and namely app configuration are externalized not baked with the final JS bundle file.

- **React** sample [here](https://github.com/abdennour/cloudnative-implementation/commit/d1413130cccbecde87dc7bf70f32d1e08d647bc2)

- **Angular** TODO

- **Vuejs** TODO

2. Base your runtime image on `docker.io/nginxinc/nginx-unprivileged:1.21-alpine`. Example of Dockerfile below

      <details><summary>show</summary>
      <p>

      ```Dockerfile
      ARG REGISTRY=docker.io
      #### STAGES BUILD ###
      FROM ${REGISTRY}/node:15-alpine3.13 as dependencies
      WORKDIR /code
      COPY package.json package-lock.json ./
      RUN npm install

      FROM dependencies as build
      COPY . .
      RUN npm run build

      #### STAGE RUNTIME ###
      FROM ${REGISTRY}/nginxinc/nginx-unprivileged:1.21-alpine as runtime
      COPY --from=build --chown=1001:0 /code/build /usr/share/nginx/html
      EXPOSE 8080
      ```

      </p>
      </details>

3. All app env vars are prefixed with a unified prefix: `REACT_APP_*` with React apps, `NG_APP_` with Angular apps,.. so on

# Values
`image.repository` or `image.stream` is the required value. Otherwise, Check the other default Values of this chart [here](https://github.com/ElmCompany/helm-charts/blob/master/charts/single-page-app/values.yaml)

# How to install the app 

**Set Elm Repo**
```sh
helm repo add elm https://raw.githubusercontent.com/ElmCompany/helm-charts/gh-pages
helm repo update
```

**Use it** `helm install elm/single-page-app`

# Authors

This chart is maintained by:

- Abdennour Toumi <atoumi@elm.sa>
- Ahmed Alharthi <ahalharthi@elm.sa>

# License

LGPL v3