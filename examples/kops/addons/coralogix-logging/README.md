# Coralogix Addon

This addon integrates your Kubernetes cluster with [Coralogix](https://coralogix.com).

## Quick Deploy using `kops`

You can enable the Coralogix logging addon when creating the Kubernetes cluster through KOPS.

Edit the cluster before creating it

```
kops edit cluster <cluster-name>
```

Now add the addon specification in the cluster manifest in the section - `spec.addons`

```
addons:
  - manifest: s3://coralogix-public/kops/addons/logging-coralogix/addon.yaml
```
For more information on how to enable addon during cluster creation refer [Kops Addon guide](https://github.com/kubernetes/kops/blob/master/docs/operations/addons.md#installing-kubernetes-addons).

## Quick Deploy using `kubectl`

After cluster creation, you can deploy `Coralogix` using the below command:

```
kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kops/addons/logging-coralogix/v1.9.0.yaml
```
