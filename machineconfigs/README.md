# Bootstrap Talos

## Apply configs

```sh
sops -d -i machineconfigs/rendered/k8s2.yaml
sops -d -i machineconfigs/rendered/k8s3.yaml
sops -d -i machineconfigs/rendered/k8s4.yaml
talosctl --nodes $PRIVATE_IP apply-config --file machineconfigs/rendered/k8s4.yaml --insecure
talosctl --nodes $PRIVATE_IP apply-config --file machineconfigs/rendered/k8s3.yaml --insecure
talosctl --nodes $PRIVATE_IP apply-config --file machineconfigs/rendered/k8s2.yaml --insecure
```

## Wait for bootstrap

```sh
talosctl bootstrap --nodes $PUBLIC_IP_K8S2
talosctl dashboard --nodes $PUBLIC_IP_K8S3
talosctl dashboard --nodes $PUBLIC_IP_K8S4
```

## Reboot

```sh
talosctl -n $PUBLIC_IP_K8S4 reboot
talosctl -n $PUBLIC_IP_K8S3 reboot
talosctl -n $PUBLIC_IP_K8S2 reboot
```

## Apply CNI

```sh
export CLUSTER_DOMAIN=local.k8s.$TLD
export KUBERNETES_API_SERVER_ADDRESS=api.k8s.$TLD
export KUBERNETES_API_SERVER_PORT=6443
helm install                                         \
    cilium                                                      \
    cilium/cilium                                               \
    --version 1.14.2                                            \
    --namespace kube-system                                     \
    --set ipam.mode=kubernetes                                  \
    --set hostFirewall.enabled=true                             \
    --set hubble.relay.enabled=true                             \
    --set hubble.ui.enabled=true                                \
    --set hubble.peerService.clusterDomain=${CLUSTER_DOMAIN}    \
    --set etcd.clusterDomain=${CLUSTER_DOMAIN}                  \
    --set kubeProxyReplacement=strict                           \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false                        \
    --set cgroup.hostRoot=/sys/fs/cgroup                        \
    --set k8sServiceHost="${KUBERNETES_API_SERVER_ADDRESS}"     \
    --set k8sServicePort="${KUBERNETES_API_SERVER_PORT}"        \
    --set installCRDS=true
```
