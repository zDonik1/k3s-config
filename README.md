# k3s-config

Starting a production cluster:

```sh
just prod up -d
```

## Traefik dashboard

Generate a basic auth user by creating a `secrets.yaml` file:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: traefik-dashboard-auth-secret
  namespace: kube-system
type: kubernetes.io/basic-auth
stringData:
  username: admin
  password: changeme
```

Then apply it to the cluster:

```sh
kubectl apply -f secrets.yaml
```

## Kubernetes dashboard

Create and save the token:

```sh
kubectl -n kubernetes-dashboard create token kubedash-admin
```

## Sleep tracker

Generate a user and password to be used between sleep-track server and PostgreSQL:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgresql-secret
  namespace: sleep-track
type: Opaque
data:
  password: cGFzc3dvcmQ=  # password (base64 encoded)
```

Then apply it to the cluster:

```sh
kubectl apply -f secrets.yaml
```
