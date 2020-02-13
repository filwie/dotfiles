#!/usr/bin/env bash

function purge() {
    if [[ -z "${REGEX}" ]] && [[ -z "${1}" ]]; then
        tput setaf 1
        echo "Either set REGEX env var or add argument to function call." > /dev/stderr
        tput sgr0
        return 1
    fi
    local purge_regex="${REGEX:-"${1}"}"

    read -p "Purge regex: ${purge_regex}. Continue purging? [y/N]: " continue_choice
    if ! [[ "${continue_choice}" =~ (y|Y|yes|Yes|YES) ]]; then
        echo "Aborting."
        return 0
    fi

    helm list \
        | grep -E "${purge_regex}" \
        | awk '{print $1}' \
        | xargs helm delete --purge

    kubectl get all \
        | grep -E "${purge_regex}" \
        | awk '{print $1}' \
        | xargs kubectl delete --force --grace-period=0

    kubectl get secrets \
        | grep -E "${purge_regex}" \
        | awk '{print $1}' \
        | xargs kubectl delete --force --grace-period=0 secrets

    kubectl get pvc \
        | grep -E ${purge_regex} \
        | awk '{print $1}' \
        | xargs kubectl delete --force --grace-period=0 pvc

    kubectl get pv \
        | grep -E ${purge_regex} \
        | awk '{print $1}' \
        | xargs kubectl delete --force --grace-period=0 pv
}

purge "${@}"
