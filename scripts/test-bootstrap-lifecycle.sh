#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT
chezmoi_command="${CHEZMOI_TEST_COMMAND:-$(command -v chezmoi)}"
fixture_home="${test_dir}/home"
fixture_source="${test_dir}/source with spaces"
fixture_home_source="${fixture_source}/home"
mkdir -p "${fixture_home}/.local/bin" "${fixture_home_source}/.chezmoiscripts" \
	"${fixture_source}/scripts" "${test_dir}/tools"
cp "${chezmoi_command}" "${fixture_home}/.local/bin/chezmoi"
cp "${source_dir}/.chezmoiroot" "${fixture_source}/"
cp "${source_dir}/home/.chezmoi.toml.tmpl" "${fixture_home_source}/"
cp "${source_dir}/home/.chezmoiscripts/run_after_zz_cleanup-bootstrap.sh" "${fixture_home_source}/.chezmoiscripts/"
printf '{{ onepasswordRead "op://test/item/field" }}\n' >"${fixture_home_source}/dot_secret.tmpl"
printf 'Repository-only documentation.\n' >"${fixture_source}/README.md"

cat >"${fixture_source}/scripts/bootstrap-cli.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/bootstrap-cli.sh
source "${BOOTSTRAP_TEST_LIBRARY}"
install_op() {
	if [ -x "${HOME}/.nix-profile/bin/op" ]; then return; fi
	cp "${BOOTSTRAP_TEST_TOOLS}/op" "${bootstrap_bin}/op"
	chmod +x "${bootstrap_bin}/op"
	record_bootstrap_binary op
}
install_gh() {
	if [ -x "${HOME}/.nix-profile/bin/gh" ]; then return; fi
	cp "${BOOTSTRAP_TEST_TOOLS}/gh" "${bootstrap_bin}/gh"
	chmod +x "${bootstrap_bin}/gh"
	record_bootstrap_binary gh
}
main "$@"
EOF
cat >"${test_dir}/tools/op" <<'EOF'
#!/bin/sh
set -eu
if [ "${1:-}" = --session ]; then
	test "$2" = mock-session
	shift 2
fi
printf 'op %s\n' "$*" >>"${BOOTSTRAP_TEST_LOG}"
case "$*" in
'account list --format=json')
	if [ -e "${HOME}/account-registered" ]; then echo '[{"account_uuid":"test"}]'; else echo '[]'; fi ;;
'account add') : >"${HOME}/account-registered" ;;
'signin --raw') printf 'mock-session\n' ;;
read*) test -e "${HOME}/account-registered"; printf mock-secret ;;
*) exit 44 ;;
esac
EOF
cat >"${test_dir}/tools/gh" <<'EOF'
#!/bin/sh
set -eu
printf 'gh %s\n' "$*" >>"${BOOTSTRAP_TEST_LOG}"
case "$*" in
'auth status --hostname github.com --active') test -e "${HOME}/github-authenticated" ;;
'auth login --hostname github.com --git-protocol https --web') : >"${HOME}/github-authenticated" ;;
*) exit 45 ;;
esac
EOF
cat >"${fixture_home_source}/.chezmoiscripts/run_before_verify-bootstrap.sh" <<'EOF'
#!/bin/sh
set -eu
test -e "${HOME}/account-registered"
test -e "${HOME}/github-authenticated"
echo before >>"${BOOTSTRAP_TEST_LOG}"
EOF
cat >"${fixture_home_source}/.chezmoiscripts/run_after_apply-nix-home-manager.sh" <<'EOF'
#!/bin/sh
set -eu
if [ -x "${HOME}/.nix-profile/bin/chezmoi" ]; then exit 0; fi
mkdir -p "${HOME}/.nix-profile/bin"
for tool in chezmoi op gh; do
	cp "${HOME}/.local/bin/${tool}" "${HOME}/.nix-profile/bin/${tool}"
	chmod +x "${HOME}/.nix-profile/bin/${tool}"
done
EOF
cat >"${fixture_home_source}/.chezmoiscripts/run_after_update-packages.sh" <<'EOF'
#!/bin/sh
set -eu
echo update >>"${BOOTSTRAP_TEST_LOG}"
EOF

run_chezmoi() {
	env -u GITHUB_ACTION -u GITHUB_ACTIONS -u OP_SESSION -u OP_SERVICE_ACCOUNT_TOKEN \
		-u OP_CONNECT_HOST -u OP_CONNECT_TOKEN -u GH_TOKEN -u GITHUB_TOKEN \
		HOME="${fixture_home}" XDG_CONFIG_HOME="${fixture_home}/.config" \
		XDG_STATE_HOME="${fixture_home}/.local/state" PATH=/usr/bin:/bin:/usr/sbin:/sbin \
		BOOTSTRAP_TEST_LIBRARY="${source_dir}/scripts/bootstrap-cli.sh" \
		BOOTSTRAP_TEST_TOOLS="${test_dir}/tools" BOOTSTRAP_TEST_LOG="${test_dir}/calls" \
		"$1" --config "${test_dir}/config.toml" --persistent-state "${test_dir}/state.boltdb" \
		--source "${fixture_source}" --override-data '{"chezmoi":{"username":"m1yam0t0"}}' "${@:2}"
}
run_chezmoi "${fixture_home}/.local/bin/chezmoi" init --apply
test "$(cat "${fixture_home}/.secret")" = mock-secret
test ! -e "${fixture_home}/scripts"
test ! -e "${fixture_home}/home"
test ! -e "${fixture_home}/README.md"
for tool in chezmoi op gh; do
	test ! -e "${fixture_home}/.local/bin/${tool}"
	test -x "${fixture_home}/.nix-profile/bin/${tool}"
done
test ! -e "${fixture_home}/.local/state/dotfiles/bootstrap/cleanup"
test -x "${fixture_home}/.local/state/dotfiles/bootstrap/op"
calls="$(cat "${test_dir}/calls")"
[[ "${calls}" == *'op account add'*'gh auth login'*before*update* ]]
[[ "${calls}" == *'op account add'*'op read'*update* ]]

# The generated configuration must still work after the binaries are removed.
run_chezmoi "${fixture_home}/.nix-profile/bin/chezmoi" apply
test "$(run_chezmoi "${fixture_home}/.nix-profile/bin/chezmoi" managed --include files)" = .secret
for tool in chezmoi op gh; do
	test ! -e "${fixture_home}/.local/bin/${tool}"
done

# A later apply must not claim an unrelated new ~/.local/bin/chezmoi.
printf unrelated >"${fixture_home}/.local/bin/chezmoi"
run_chezmoi "${fixture_home}/.nix-profile/bin/chezmoi" apply
test "$(cat "${fixture_home}/.local/bin/chezmoi")" = unrelated

# Preserve a file replaced by the user after bootstrap.
manifest="${fixture_home}/.local/state/dotfiles/bootstrap/cleanup"
printf changed >"${fixture_home}/.local/bin/op"
printf 'different-checksum op\n' >"${manifest}"
env HOME="${fixture_home}" XDG_STATE_HOME="${fixture_home}/.local/state" \
	bash "${source_dir}/home/.chezmoiscripts/run_after_zz_cleanup-bootstrap.sh"
test "$(cat "${fixture_home}/.local/bin/op")" = changed

# An incomplete Home Manager activation must leave bootstrap files intact.
rm "${fixture_home}/.nix-profile/bin/gh"
printf 'different-checksum op\n' >"${manifest}"
status=0
env HOME="${fixture_home}" XDG_STATE_HOME="${fixture_home}/.local/state" \
	bash "${source_dir}/home/.chezmoiscripts/run_after_zz_cleanup-bootstrap.sh" || status=$?
test "${status}" = 1
test -f "${fixture_home}/.local/bin/op"
test -f "${manifest}"
echo 'chezmoi bootstrap lifecycle tests passed.'
