Kubernetes FluentD Helm chart for Coralogix
===========================================

You can deploy FluentD based on official Helm `chart <https://github.com/fluent/helm-charts/tree/main/charts/fluentd>`_.

Download `parameter file <https://github.com/coralogix/fluentd-coralogix-image/tree/master/examples/helm/values.yaml>`_, fill ``PRIVATE_KEY`` environment variable and install the chart:

.. code-block:: bash

    $ helm install coralogix fluentd \
        --repo https://fluent.github.io/helm-charts \
        --values values.yaml \
        --namespace coralogix \
        --create-namespace
