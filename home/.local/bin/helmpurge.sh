#!/usr/bin/env bash

resource_types=(
    crd
    ValidatingWebhookConfiguration
)

helm_releases="$(helm list | grep -v NAME | awk '{print $1}')"

# shellcheck disable=SC2068
for release in ${helm_releases[@]}; do
    helm delete --purge "${release}"
    for rt in "${resource_types[@]}"; do
        kubectl get "${rt}" | grep "${release}" | awk '{print $1}' \
            | xargs kubectl delete "${rt}" 2> /dev/null
    done
done
