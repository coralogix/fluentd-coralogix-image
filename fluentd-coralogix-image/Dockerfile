# Extend official FluentD image
FROM fluent/fluentd:v1.3.0-debian-onbuild

# Image version
ARG VERSION=latest

# Image description labels
LABEL Description="Special FluentD image for Coralogix integration" \
      maintainer="Coralogix Inc. <info@coralogix.com>" \
      Vendor="Coralogix Inc." \
      Version="${VERSION}"

# Change user
USER root

# Insert config files into container
COPY conf /fluentd/etc/conf/
COPY Gemfile Gemfile.lock /

# Installing dependencies and plugins
RUN BUILD_DEPS="make gcc g++ libc-dev ruby-dev libffi-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPS \
    && gem install --file Gemfile --no-rdoc --no-ri --no-document \
    && gem sources --clear-all \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/*/cache/*.gem \
    && ulimit -n 65536

# Expose required ports
EXPOSE 24224 9880 5140 12201

# Override parent entrypoint
ENTRYPOINT []

# Start FluentD daemon
CMD exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
