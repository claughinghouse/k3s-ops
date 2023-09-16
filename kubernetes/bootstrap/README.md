# Bootstrap

## Flux

### Install Flux

```sh
sops --decrypt -i kubernetes/bootstrap/flux/gotk-components.yaml
kubectl apply --server-side --kustomize ./kubernetes/bootstrap/flux
sops --encrypt -i kubernetes/bootstrap/flux/gotk-components.yaml
```

### Apply Cluster Configuration

_These cannot be applied with `kubectl` in the regular fashion due to be encrypted with sops_

```sh
sops --decrypt kubernetes/flux/config/age-key.sops.yaml | kubectl apply -f -
sops --decrypt kubernetes/flux/config/github-deploy-key.sops.yaml | kubectl apply -f -
sops --decrypt kubernetes/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
```

### Kick off Flux applying this repository

```sh
kubectl apply --server-side --kustomize ./kubernetes/flux/config
```

### Reset Talos

```sh
talosctl reset --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --reboot --nodes $NODE_IP
```
