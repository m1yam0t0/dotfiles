#!/usr/bin/env bash

script_dir="$(
    cd "$(dirname "$0")" || exit
    pwd
)"

shchk_cmd="aqua -c ${script_dir}/aqua.yaml exec -- shellcheck"

find "${script_dir}/../.chezmoiscripts" -name "*.sh*" \
    -exec sh -c 'file="$1"; echo "$file"; '"$shchk_cmd"' "$file"' -- {} \;
