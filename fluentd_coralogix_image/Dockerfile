# Image version
ARG VERSION

# Extend official FluentD image
FROM fluent/fluentd:stable-debian-onbuild

# Image description labels
LABEL Description="Special FluentD image for Coralogix integration" Vendor="Coralogix Ltd" Version="${VERSION:-latest}"

# Installing plugins
RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" && \
    apt-get update && \
    apt-get install -y --no-install-recommends $buildDeps && \
    sudo gem install fluent-plugin-multiprocess \
                     coralogix_fluentd_logger && \
    sudo gem sources --clear-all && \
    SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps && \
    rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/*/cache/*.gem

ADD ./conf /fluentd/etc/conf/

# Expose required ports
EXPOSE 24224 9880 5140