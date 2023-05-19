#!/usr/bin/env bash

script_dir="$(
    cd "$(dirname "$0")" || exit
    pwd
)"

shfmt_cmd="aqua -c ${script_dir}/aqua.yaml exec -- shfmt -w"

find "${script_dir}/../.chezmoiscripts" -name "*.sh*" \
    -exec sh -c 'file="$1"; echo "$file"; '"$shfmt_cmd"' "$file"' -- {} \;
