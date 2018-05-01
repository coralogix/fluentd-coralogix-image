# Fluentd Coralogix Helm chart for Kubernetes

It's a modificated version of official `FluentD` image with support of integration with *Coralogix*, multiprocessing and K8S.

## Introduction

This chart bootstraps a [FluentD Coralogix](https://github.com/coralogix/fluentd-coralogix-image) daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- `Kubernetes` 1.8+ with Beta APIs and RBAC enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release \
  --set PRIVATE_KEY=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX \
  --set APP_NAME=your-app-name \
  --set SUB_SYSTEM=sub-system-name
    stable/fluentd-coralogix
```

The command deploys *Fluentd-Coralogix* on the `Kubernetes` cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Configuration

The following table lists the configurable parameters of the `Fluentd Coralogix` chart and their default values.

| Parameter                                  | Description                                                                                                    | Default                                     |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `PRIVATE_KEY`                              | Coralogix Private Key                                                                                          | `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`      |
| `APP_NAME`                                 | Coralogix Application Name                                                                                     | `fluentd-coralogix-image`                   |
| `SUB_SYSTEM`                               | Coralogix Subsystem name                                                                                       | `fluentd`                                   |
| `image.registry`                           | Image registry                                                                                                 | `docker.io`                                 |
| `image.repository`                         | Image repository                                                                                               | `coralogixrepo`                             |
| `image.name`                               | Image name                                                                                                     | `fluentd-coralogix-image`                   |
| `image.tag`                                | Image tag                                                                                                      | `latest`                                    |
| `fluentd.ports.fluentd`                    | FluentD port                                                                                                   | `24224`                                     |
| `fluentd.ports.http`                       | HTTP port                                                                                                      | `9880`                                      |
| `fluentd.ports.syslog`                     | Syslog port                                                                                                    | `5140`                                      |

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the `Kubernetes` components associated with the chart and deletes the release.