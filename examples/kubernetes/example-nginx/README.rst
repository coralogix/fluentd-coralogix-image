Collecting logs from nginx Pod
==============================

For example we create simple ``nginx`` deployment on Kubernetes, which send logs to out ``fluentd-coralogix-logger`` service.

First, we must create **ConfigMap** for ``nginx``:

.. code-block:: yaml

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: nginx-test-configs
      namespace: default
      labels:
        app: nginx-test
    data:
      nginx.conf: |
        user www-data;
        pid /run/nginx.pid;
        events {
            worker_connections 4000;
            multi_accept on;
        }
        http {
            keepalive_timeout 65;
            keepalive_requests 60;
            access_log syslog:server=fluentd-coralogix-service.kube-system:5140,tag=nginx_access;
            error_log syslog:server=fluentd-coralogix-service.kube-system:5140,tag=nginx_error warn;
            include /etc/nginx/conf.d/*.conf;
            include /etc/nginx/sites-enabled/*;
        }

or you can send logs directly to standart ``stdout`` and ``stderr`` output:

::

    http {
        ...
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log warn;
        ...

We have created simple ``nginx`` configuration file.
As logger backend we will use ``syslog`` and point our service name as ``syslog`` server address(*fluentd-coralogix-service.kube-system:5140*).

Next we must create ``nginx`` **Deployment**:

.. code-block:: yaml

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-test
      namespace: default
      labels:
        app: nginx-test
    spec:
      replicas: 1
      strategy:
        type: Recreate
      selector:
        matchLabels:
          app: nginx-test
      template:
        metadata:
          labels:
            app: nginx-test
        spec:
          restartPolicy: Always
          containers:
          - name: nginx
            image: nginx:latest
            ports:
            - containerPort: 80
              protocol: TCP
              name: http
            livenessProbe:
              httpGet:
                scheme: HTTP
                path: /
                port: 80
              initialDelaySeconds: 30
              timeoutSeconds: 30
            volumeMounts:
              - mountPath: /etc/nginx/nginx.conf
                subPath: nginx.conf
                name: nginx-config
          volumes:
          - name: nginx-config
            configMap:
              name: nginx-test-configs

It's a simple exmaple of ``nginx`` **Deployment** which mount our config file and listen on port **80**.

Finally, we create ``nginx`` service which will be listen on port **30897** of out **Node** (*only for example, not for production usage*):

.. code-block:: yaml

    kind: Service
    apiVersion: v1
    metadata:
      name: nginx-test-service
      namespace: default
      labels:
        app: nginx-test
    spec:
      selector:
        app: nginx-test
      ports:
        - port: 80
          targetPort: 80
          protocol: TCP
          name: http
          nodePort: 30897
      type: NodePort

Now we can open browser and type *<cluster_ip>:30897* and see ``nginx`` default start page.

Full source you can watch `here <example-nginx/nginx.yaml>`_.