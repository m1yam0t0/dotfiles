#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT
parent_path="${PATH}"
# shellcheck source=.install.sh
source "${source_dir}/.install.sh"
export XDG_STATE_HOME="${test_dir}/state"

# Force every download, even if the runner already has these tools.
command() {
	case "$*" in
	'-v chezmoi'|'-v op'|'-v gh') return 1 ;;
	esac
	builtin command "$@"
}
main --download-only
for tool in chezmoi op gh; do
	"${XDG_STATE_HOME}/dotfiles/bootstrap/bin/${tool}" --version
done

# Exercise the README's bash -c entry point using the downloaded binaries.
PATH="${XDG_STATE_HOME}/dotfiles/bootstrap/bin:${parent_path}" \
	bash -c "$(cat "${source_dir}/.install.sh")" -- --download-only
