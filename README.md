# k3s-config

Starting a production cluster:

```sh
just prod up -d
```

## Applying configurations
## Kubernetes dashboard

Create and save the token:

```sh
kubectl -n kubernetes-dashboard create token kubedash-admin
```

## Traefik dashboard

Generate the username and password using

```sh
htpasswd -n <username> | openssl base64
```

Put the generated credentials as a `adminCredentials` value for cluster-config chart.
