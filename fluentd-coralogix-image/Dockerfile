# Set FluentD version
ARG FLUENTD_VERSION=v1.10.0-1.0

# Extend official FluentD image
FROM fluent/fluentd:${FLUENTD_VERSION}

# Image version
ARG VERSION=latest

# Image description labels
LABEL Description="Special FluentD image for Coralogix integration" \
      Vendor="Coralogix Inc." \
      Version="${VERSION}"

# Image maintainer label
LABEL maintainer="Coralogix Inc. <info@coralogix.com>"

# Change user
USER root

# Installing dependencies and plugins
RUN apk add --no-cache --update --virtual .build-deps build-base ruby-dev && \
    gem install --no-rdoc --no-ri --no-document \
                fluent-plugin-kubernetes_metadata_filter \
                fluent-plugin-docker_metadata_filter \
                fluent-plugin-input-gelf \
                fluent-plugin-systemd \
                fluent-plugin-multi-format-parser \
                fluent-plugin-rewrite-tag-filter \
                fluent-plugin-concat \
                fluent-plugin-detect-exceptions \
                fluent-plugin-coralogix && \
    gem sources --clear-all && \
    apk del .build-deps && \
    rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem && \
    ulimit -n 65536

# Copy plugins
COPY plugins /fluentd/plugins/

# Copy configuration files into image
COPY fluent.conf /fluentd/etc/
COPY conf /fluentd/etc/conf/

# Expose required ports
EXPOSE 24224 24220 24230 9880 5140/udp 12201/udp
