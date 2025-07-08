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
