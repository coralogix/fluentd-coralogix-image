#!/bin/bash

# Assumes being run from project root
helm package ./examples/helm

# Assumes a python based environment
helm_chart_file=$(python -c 'import yaml; from pathlib import Path; data = yaml.load(Path("./examples/helm/Chart.yaml").read_text(), Loader=yaml.SafeLoader); print("{name}-{version}.tgz".format(**data))')
curl -X POST --user "${BITBUCKET_AUTH_STRING}" \
  "https://api.bitbucket.org/2.0/repositories/zencitytech/fluentd-coralogix-image/downloads" \
  --form files=@"${helm_chart_file}"
