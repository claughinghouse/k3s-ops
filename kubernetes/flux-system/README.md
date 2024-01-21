## Create the components

`kubectl apply -f gotk-components.yaml`

## Create secrets for decryption

`sops -d flux-system/age-key.sops.yaml | kubectl apply -f -`

## Then flux bootstrap after deploying gotk-components.yaml

`sops -d flux-system/github-deploy-key.sops.yaml | kubectl apply -f -`

## Setup the repo

`kubectl apply -f gotk-sync.yaml`
