# Radius Server Helm Chart

This chart installs Radius app on top of a kubernetes cluster.

# Use Case

We've created this chart in order to simulate the integration between Hashicorp Vault and Radius through the "Radius" auth method.


![](../assets/img/vault-radius-auth-config.png)

# Values
Defaut values are documented in [values.yaml](values.yaml)


Using the default values ( without customization), the default Radius instance allow traffics as following:
  - From any IP (0.0.0.0/0)
  - Secured with a password `bigsecret`
  - For 2 Users (username/password): `user/password` , `bob/test`

# Authors

- @abdennour

# License

[LICENSE](../LICENSE)
