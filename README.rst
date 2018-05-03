FluentD-Coralogix-Docker-Image
==============================

.. image:: https://travis-ci.org/coralogix/fluentd-coralogix-image.svg
    :target: https://travis-ci.org/coralogix/fluentd-coralogix-image

.. image:: https://img.shields.io/docker/pulls/coralogixrepo/fluentd-coralogix-image.svg
    :target: https://hub.docker.com/r/coralogixrepo/fluentd-coralogix-image/

.. image:: https://img.shields.io/microbadger/layers/coralogixrepo/fluentd-coralogix-image.svg
    :target: https://hub.docker.com/r/coralogixrepo/fluentd-coralogix-image/

.. image:: https://img.shields.io/github/repo-size/coralogix/fluentd-coralogix-image.svg
    :target: https://github.com/coralogix/fluentd-coralogix-image

.. image:: https://img.shields.io/github/issues/coralogix/fluentd-coralogix-image.svg
    :target: https://github.com/coralogix/fluentd-coralogix-image

.. image:: https://img.shields.io/github/issues-pr/coralogix/fluentd-coralogix-image.svg
    :target: https://github.com/coralogix/fluentd-coralogix-image

It's a modificated version of official FluentD image with support of integration with *Coralogix*, multiprocessing and K8S.

Installation
------------

You can build image manually with **cmake** utility

.. code-block:: bash

    $ make build

or pull ready image from our repository:

.. code-block:: bash

    $ docker pull coralogixrepo/fluentd-coralogix-image:latest

Also you can deploy this image with ``docker-compose``.
For details watch `Docker-compose example <examples/docker-compose/README.rst>`_.

Features
--------

This image provides collecting logs from:

Syslog
~~~~~~

For example you can setup sending logs from nginx:

::

    http {
    ...
    access_log    syslog:server=<FLUENTD_HOST>:5140,tag=nginx_access;
    error_log     syslog:server=<FLUENTD_HOST>:5140,tag=nginx_error info;
    ...

HTTP
~~~~

It received logs in JSON format:

.. code-block:: bash

    $ curl -X POST -d 'json={"action":"login","user":2}' \
    $ http://<FLUENTD_HOST>:9880/applications.tag_name;

also data includes sender hostname information(*hostname*).

FluentD
~~~~~~~

Used to receive event logs from other Fluentd instances, the fluent-cat command, or client libraries.

For example can be provided for ``Docker``.

If you run container manualy

.. code-block:: bash

    $ docker run -dit \
    $ --log-driver=fluentd \
    $ --log-opt fluentd-address=<FLUENTD_HOST>:24224 \
    $ alpine echo "Hello world!"

or with ``docker-compose``:

.. code-block:: yaml

    version: "3"
    services:
      web:
        restart: always
        image: nginx
        container_name: nginx
        environment:
          - NGINX_HOST=example.com
        logging:
          driver: fluentd
          options:
            fluentd-address: <FLUENTD_HOST>:24224
        ports:
          - "80:80"
          - "443:443"


Kubernetes (K8S)
~~~~~~~~~~~~~~~~

This image have ``K8S`` support.
For details watch `Kubernetes example <examples/kubernetes/README.rst>`_.
Also you can install it with `Helm package manager <examples/helm/README.md>`_.

Development
-----------

This image build automatically with *Travis CI*.
To provide image version add tag to your commit and it will be grabbed with CI worker.

.. attention:: Image will be builded only if commit was made in *master* branch. If you want to change this condition see **.travis.yml**.