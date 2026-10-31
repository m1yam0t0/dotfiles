#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT
bash_command="$(command -v bash)"
script="${source_dir}/home/.chezmoiscripts/run_after_update-packages.sh"
export HOME="${test_dir}/home"
export UPDATE_TEST_LOG="${test_dir}/calls"
profile_bin="${HOME}/.nix-profile/bin"
mkdir -p "${profile_bin}" "${HOME}/.nix-profile/etc/profile.d" \
	"${HOME}/.krew" "${test_dir}/empty-path"
printf 'export UPDATE_TEST_NIX_LOADED=1\n' \
	>"${HOME}/.nix-profile/etc/profile.d/nix.sh"
: >"${HOME}/.zshenv"
printf 'ctx\n' >"${HOME}/.krew/plugins.txt"

printf '#!%s\n' "${bash_command}" >"${test_dir}/mock-command"
cat >>"${test_dir}/mock-command" <<'EOF'
set -euo pipefail
test "${UPDATE_TEST_NIX_LOADED}" = 1
name="${0##*/}"
printf '%s %s\n' "${name}" "$*" >>"${UPDATE_TEST_LOG}"
if [ "${name}" = gh ]; then
	case "$1 $2" in
	'auth status')
		if [ "${UPDATE_TEST_NEEDS_LOGIN:-0}" = 1 ] && [ ! -e "${UPDATE_TEST_LOG}.authenticated" ]; then
			exit 1
		fi
		;;
	'extension upgrade')
		if [ "${UPDATE_TEST_FAIL_GH:-0}" = 1 ]; then
			exit 42
		fi
		;;
	esac
fi
EOF
for name in gh krew nvim; do
	cp "${test_dir}/mock-command" "${profile_bin}/${name}"
	chmod +x "${profile_bin}/${name}"
done

# Only Home Manager's profile contains the tools; the parent PATH is empty.
PATH="${test_dir}/empty-path" "${bash_command}" "${script}"
test "$(cat "${UPDATE_TEST_LOG}")" = \
	$'gh auth status --hostname github.com --active\ngh extension upgrade --all\nkrew install\nkrew upgrade\nnvim --headless +Lazy! sync +qa'

# Non-private machines do not install krew.
rm "${profile_bin}/krew"
: >"${UPDATE_TEST_LOG}"
PATH="${test_dir}/empty-path" "${bash_command}" "${script}"
test "$(cat "${UPDATE_TEST_LOG}")" = \
	$'gh auth status --hostname github.com --active\ngh extension upgrade --all\nnvim --headless +Lazy! sync +qa'

# Authentication is completed by the source-state hook before plugin updates.
export UPDATE_TEST_NEEDS_LOGIN=1
: >"${UPDATE_TEST_LOG}"
status=0
PATH="${test_dir}/empty-path" "${bash_command}" "${script}" || status=$?
test "${status}" = 1
test "$(cat "${UPDATE_TEST_LOG}")" = 'gh auth status --hostname github.com --active'
unset UPDATE_TEST_NEEDS_LOGIN

# Do not hide a failed update by continuing to later tools.
: >"${UPDATE_TEST_LOG}"
export UPDATE_TEST_FAIL_GH=1
status=0
PATH="${test_dir}/empty-path" "${bash_command}" "${script}" || status=$?
test "${status}" = 42
test "$(cat "${UPDATE_TEST_LOG}")" = $'gh auth status --hostname github.com --active\ngh extension upgrade --all'
echo 'Package update tests passed.'
