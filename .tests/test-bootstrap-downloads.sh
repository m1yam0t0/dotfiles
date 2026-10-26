#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT
# shellcheck source=.bootstrap-cli.sh
source "${source_dir}/.bootstrap-cli.sh"
export HOME="${test_dir}/home"
export XDG_STATE_HOME="${test_dir}/state"
unset DOTFILES_CHEZMOI_EXECUTABLE

# Force downloads without changing the machine's real ~/.local/bin.
command() {
	case "$*" in
	'-v op'|'-v gh') return 1 ;;
	esac
	builtin command "$@"
}
main --download-only
for tool in op gh; do
	"${HOME}/.local/bin/${tool}" --version
done
test -f "${XDG_STATE_HOME}/dotfiles/bootstrap/cleanup"
