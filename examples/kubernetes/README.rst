Kubernetes integration
======================

.. image:: https://img.shields.io/badge/Kubernetes-1.7%2C%201.8%2C%201.9%2C%201.10%2C%201.11-blue.svg
    :target: https://github.com/kubernetes/kubernetes/releases

This manual will allow you to integrate *Coralogix* into your ``Kubernetes`` cluster.

Prerequisites
-------------

Before you begin, make sure you:

- Have an installed Kubernetes Cluster
- Enabled RBAC authorization mode

Installation
------------
First, create *Kubernetes namespace*:

.. code-block:: bash

    $ kubectl create namespace fluentd-coralogix

Now, create *Kubernetes secret*:

.. code-block:: bash

    $ kubectl create secret generic fluentd-coralogix-account-secrets \
        -n fluentd-coralogix \
        --from-literal=PRIVATE_KEY=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX \
        --from-literal=ENDPOINT=<Coralogix_API_URL>

You should have something like:

::

    secret "fluentd-coralogix-account-secrets" created

Then you need to apply our ``fluentd-coralogix-logger`` to your Kubernetes cluster:

.. code-block:: bash

    $ kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kubernetes/fluentd-coralogix-rbac.yaml
    $ kubectl create -f https://raw.githubusercontent.com/coralogix/fluentd-coralogix-image/master/examples/kubernetes/fluentd-http-coralogix-cm.yaml
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

Example of usage can be found `here <example-nginx/README.rst>`_.

Update
------

Once installed, the deployment is not automatically updated. In order to update it you need to delete the deployment's pods and wait for it to be recreated. After recreation, it should use the latest image.

Delete all ``fluentd-coralogix-logger`` pods:

.. code-block:: bash

    $ kubectl -n fluentd-coralogix delete $(kubectl -n fluentd-coralogix get pod -o name | grep "fluentd-coralogix-daemonset")

Uninstall
---------

If you want to remove ``fluentd-coralogix-logger`` from your cluster, execute this:

.. code-block:: bash

    $ kubectl -n fluentd-coralogix delete secret fluentd-coralogix-account-secrets
    $ kubectl -n fluentd-coralogix delete svc,ds,cm,clusterrolebinding,clusterrole,sa \
         -l k8s-app=fluentd-coralogix-logger
