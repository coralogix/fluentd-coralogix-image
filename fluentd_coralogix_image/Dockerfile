# Image version
ARG VERSION

# Extend official FluentD image
FROM fluent/fluentd:stable-debian-onbuild

# Image description labels
LABEL Description="Special FluentD image for Coralogix integration" Vendor="Coralogix Ltd" Version="${VERSION:-latest}"

# Change user
USER root

# Installing plugins
RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" && \
    apt-get update && \
    apt-get install -y --no-install-recommends $buildDeps && \
    gem install fluent-plugin-kubernetes_metadata_filter \
                fluent-plugin-multi-format-parser \
                fluent-plugin-rewrite-tag-filter \
                fluent-plugin-concat \
                fluent-plugin-input-gelf \
                coralogix_fluentd_logger && \
    gem sources --clear-all && \
    SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps && \
    rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/*/cache/*.gem

# Insert config files into container
ADD ./conf /fluentd/etc/conf/

# Override parent entrypoint
ENTRYPOINT []

# Expose required ports
EXPOSE 24224 9880 5140 12201

# Start FluentD daemon
CMD exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT