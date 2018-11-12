Kubernetes integration
======================

.. image:: https://img.shields.io/badge/Kubernetes-1.7%2C%201.8%2C%201.9%2C%201.10-blue.svg
    :target: https://github.com/kubernetes/kubernetes/releases

This manual show how to integrate support of *Coralogix* logging in your ``Kubernetes`` cluster.

Prerequisites
-------------

Before begin you must have:

- Installed Kubernetes Cluster
- Enabled RBAC authorization mode
- Pull image ``coralogixrepo/fluentd-coralogix-image:latest``

Installation
------------

First, you must create *Kubernetes secret*:

.. code-block:: bash

    $ kubectl -n kube-system create secret generic fluentd-coralogix-account-secrets \
        --from-literal=PRIVATE_KEY=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX \
        --from-literal=APP_NAME=fluentd-coralogix-image \
        --from-literal=SUB_SYSTEM=fluentd

You must have something like:

::

    secret "fluentd-coralogix-account-secrets" created

Then you need to apply our ``fluentd-coralogix-logger`` to your Kubernetes cluster:

.. code-block:: bash

    $ kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kubernetes/fluentd-coralogix-rbac.yaml
    $ kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kubernetes/fluentd-coralogix-cm.yaml
    $ kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kubernetes/fluentd-coralogix-ds.yaml
    $ kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kubernetes/fluentd-coralogix-svc.yaml

Output:

::

    serviceaccount "fluentd-coralogix-service-account" created
    clusterrole "fluentd-coralogix-service-account-role" created
    clusterrolebinding "fluentd-coralogix-service-account" created
    configmap "fluentd-coralogix-configs" created
    daemonset "fluentd-coralogix-daemonset" created
    service "fluentd-coralogix-service" created

Now ``fluentd-coralogix-logger`` collects logs from your Kubernetes cluster.

Usage
-----

Example of usage you can watch `here <example-nginx/README.rst>`_.

Update
------

Once installed, the deployment is not automatically updated. In order to update it you need to delete the deployment's pods and wait for it to be recreated. After recreation, it should use the latest image.

Delete all ``fluentd-coralogix-logger`` pods:

.. code-block:: bash

    $ kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep "fluentd-coralogix-daemonset")

Uninstall
---------

If you want to remove ``fluentd-coralogix-logger`` from your cluster, execute this:

.. code-block:: bash

    $ kubectl -n kube-system delete secret fluentd-coralogix-account-secrets
    $ kubectl -n kube-system delete svc,ds,cm,clusterrolebindings,clusterroles,sa \
         -l k8s-app=fluentd-coralogix-logger
