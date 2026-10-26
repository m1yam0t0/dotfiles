#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT
# shellcheck source=.install.sh
source "${source_dir}/.install.sh"
export XDG_STATE_HOME="${test_dir}/state"
export INSTALL_TEST_LOG="${test_dir}/calls"

# Use real platform detection and checksum verification with mocked CLI calls.
install_chezmoi() { echo download-chezmoi >>"${INSTALL_TEST_LOG}"; }
install_op() { echo download-op >>"${INSTALL_TEST_LOG}"; }
install_gh() { echo download-gh >>"${INSTALL_TEST_LOG}"; }
op() {
	printf 'op %s\n' "$*" >>"${INSTALL_TEST_LOG}"
	case "$*" in
	whoami)
		[ "${INSTALL_TEST_AUTHENTICATED:-0}" = 1 ] || [ "${OP_SESSION:-}" = mock-session ]
		;;
	'account list --format=json') printf '[]\n' ;;
	'account add') return "${INSTALL_TEST_OP_FAILURE:-0}" ;;
	'signin --raw') printf 'mock-session\n' ;;
	--version) echo mock-op ;;
	*) return 44 ;;
	esac
}
gh() {
	printf 'gh %s\n' "$*" >>"${INSTALL_TEST_LOG}"
	case "$*" in
	'auth status --hostname github.com --active') [ "${INSTALL_TEST_AUTHENTICATED:-0}" = 1 ] ;;
	'auth login --hostname github.com --git-protocol https --web') return "${INSTALL_TEST_GH_FAILURE:-0}" ;;
	--version) echo mock-gh ;;
	*) return 45 ;;
	esac
}
chezmoi() {
	if [ "${1}" = init ] && [ "${INSTALL_TEST_AUTHENTICATED:-0}" != 1 ]; then
		test "${OP_SESSION:-}" = mock-session
	fi
	printf 'chezmoi %s\n' "$*" >>"${INSTALL_TEST_LOG}"
}

main --branch feature/test
test "$(cat "${INSTALL_TEST_LOG}")" = \
	$'download-chezmoi\ndownload-op\ndownload-gh\nop whoami\nop account list --format=json\nop account add\nop signin --raw\nop whoami\ngh auth status --hostname github.com --active\ngh auth login --hostname github.com --git-protocol https --web\nchezmoi init m1yam0t0 --apply --branch feature/test'

export INSTALL_TEST_AUTHENTICATED=1
: >"${INSTALL_TEST_LOG}"
main
test "$(cat "${INSTALL_TEST_LOG}")" = \
	$'download-chezmoi\ndownload-op\ndownload-gh\nop whoami\ngh auth status --hostname github.com --active\nchezmoi init m1yam0t0 --apply'
unset INSTALL_TEST_AUTHENTICATED

: >"${INSTALL_TEST_LOG}"
main --download-only
test "$(cat "${INSTALL_TEST_LOG}")" = \
	$'download-chezmoi\ndownload-op\ndownload-gh\nchezmoi --version\nop --version\ngh --version'

# Keep errexit active inside main by running failures in a separate shell.
export -f detect_platform install_chezmoi install_op install_gh authenticate op gh chezmoi main
export INSTALL_TEST_OP_FAILURE=42
: >"${INSTALL_TEST_LOG}"
status=0
bash -c 'set -euo pipefail; main' || status=$?
test "${status}" = 42
test "$(cat "${INSTALL_TEST_LOG}")" = \
	$'download-chezmoi\ndownload-op\ndownload-gh\nop whoami\nop account list --format=json\nop account add'
unset INSTALL_TEST_OP_FAILURE

export INSTALL_TEST_GH_FAILURE=43
: >"${INSTALL_TEST_LOG}"
status=0
bash -c 'set -euo pipefail; main' || status=$?
test "${status}" = 43
test "$(tail -n 1 "${INSTALL_TEST_LOG}")" = \
	'gh auth login --hostname github.com --git-protocol https --web'

printf test >"${test_dir}/checksum-input"
verify_sha256 "${test_dir}/checksum-input" 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
if verify_sha256 "${test_dir}/checksum-input" invalid 2>/dev/null; then
	echo 'An invalid checksum was accepted.' >&2
	exit 1
fi
echo 'Initial setup tests passed.'
