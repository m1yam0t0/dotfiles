#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT
# shellcheck source=.bootstrap-cli.sh
source "${source_dir}/.bootstrap-cli.sh"
export HOME="${test_dir}/home"
export XDG_STATE_HOME="${test_dir}/state"
export BOOTSTRAP_TEST_LOG="${test_dir}/calls"

install_op() { echo download-op >>"${BOOTSTRAP_TEST_LOG}"; }
install_gh() { echo download-gh >>"${BOOTSTRAP_TEST_LOG}"; }
op() {
	printf 'op %s\n' "$*" >>"${BOOTSTRAP_TEST_LOG}"
	case "$*" in
	'account list --format=json')
		if [ "${BOOTSTRAP_TEST_AUTHENTICATED:-0}" = 1 ]; then
			printf '[{"account_uuid":"test-account"}]\n'
		else
			printf '[]\n'
		fi
		;;
	'account add') return "${BOOTSTRAP_TEST_OP_FAILURE:-0}" ;;
	--version) echo mock-op ;;
	*) return 44 ;;
	esac
}
gh() {
	printf 'gh %s\n' "$*" >>"${BOOTSTRAP_TEST_LOG}"
	case "$*" in
	'auth status --hostname github.com --active') [ "${BOOTSTRAP_TEST_AUTHENTICATED:-0}" = 1 ] ;;
	'auth login --hostname github.com --git-protocol https --web') return "${BOOTSTRAP_TEST_GH_FAILURE:-0}" ;;
	--version) echo mock-gh ;;
	*) return 45 ;;
	esac
}

main --setup-private
test "$(cat "${BOOTSTRAP_TEST_LOG}")" = \
	$'download-op\ndownload-gh\nop account list --format=json\nop account add\ngh auth status --hostname github.com --active\ngh auth login --hostname github.com --git-protocol https --web'

export BOOTSTRAP_TEST_AUTHENTICATED=1
: >"${BOOTSTRAP_TEST_LOG}"
main --setup-private
test "$(cat "${BOOTSTRAP_TEST_LOG}")" = \
	$'download-op\ndownload-gh\nop account list --format=json\ngh auth status --hostname github.com --active'
: >"${BOOTSTRAP_TEST_LOG}"
main --setup
test "$(cat "${BOOTSTRAP_TEST_LOG}")" = \
	$'download-op\ndownload-gh\ngh auth status --hostname github.com --active'
unset BOOTSTRAP_TEST_AUTHENTICATED

: >"${BOOTSTRAP_TEST_LOG}"
main --download-only
test "$(cat "${BOOTSTRAP_TEST_LOG}")" = \
	$'download-op\ndownload-gh\nop --version\ngh --version'

export -f detect_platform install_op install_gh authenticate op gh main
export BOOTSTRAP_TEST_OP_FAILURE=42
: >"${BOOTSTRAP_TEST_LOG}"
status=0
bash -c 'set -euo pipefail; main --setup-private' || status=$?
test "${status}" = 42
test "$(tail -n 1 "${BOOTSTRAP_TEST_LOG}")" = 'op account add'
unset BOOTSTRAP_TEST_OP_FAILURE

export BOOTSTRAP_TEST_GH_FAILURE=43
: >"${BOOTSTRAP_TEST_LOG}"
status=0
bash -c 'set -euo pipefail; main --setup-private' || status=$?
test "${status}" = 43
test "$(tail -n 1 "${BOOTSTRAP_TEST_LOG}")" = \
	'gh auth login --hostname github.com --git-protocol https --web'

printf test >"${test_dir}/checksum-input"
verify_sha256 "${test_dir}/checksum-input" 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
if verify_sha256 "${test_dir}/checksum-input" invalid 2>/dev/null; then
	echo 'An invalid checksum was accepted.' >&2
	exit 1
fi
echo 'CLI bootstrap tests passed.'
