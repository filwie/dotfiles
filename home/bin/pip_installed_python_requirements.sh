#!/bin/bash
set -eu

if [[ "${#}" -ne 1 ]]; then
    echo "USAGE: ${0} PACKAGE"
    exit 1
fi

package="${1}"

reqs="$(pip show "${package}" | grep Requires: | cut -d" " -f 2-)"

IFS=', ' read -a array <<< "${reqs}"

freeze="$(pip freeze)"

{
for req in "${array[@]}"; do
    echo "${freeze}" | grep "${req}"
done
} | sort
