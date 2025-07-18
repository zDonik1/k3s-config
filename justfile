help:
    just -l

# pull repo on server
pull:
    ssh serv git -C "~/k3s-config" pull -f

# call local kubectl
[group("develop")]
ctl *ARGS:
    @kubectl --kubeconfig k3s-server-output/kubeconfig.yaml {{ ARGS }}

# apply configuration
[group("develop")]
hf *ARGS:
    @helmfile --kubeconfig k3s-server-output/kubeconfig.yaml -e dev {{ ARGS }}

# clear persitent container data
[group("develop")]
clear:
    @rm -rf k3s-server*
    @docker volume rm k3s-config_k3s-server

# run a compose command in production
[group("production")]
prod *ARGS:
    docker compose -f docker-compose.yaml -f docker-compose.prod.yaml {{ ARGS }}
