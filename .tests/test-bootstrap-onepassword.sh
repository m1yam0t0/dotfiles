#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "${test_dir}"' EXIT

export HOME="${test_dir}/home"
export BOOTSTRAP_TEST_LOG="${test_dir}/calls"
mkdir -p "${HOME}/.nix-profile/etc/profile.d" "${test_dir}/bin" \
	"${test_dir}/source with spaces/.chezmoiscripts"
cp "${source_dir}/.bootstrap-onepassword.sh" \
	"${test_dir}/source with spaces/"

# Simulate Nix being installed but absent from the parent's PATH.
cat >"${test_dir}/source with spaces/.chezmoiscripts/run_before_install-nix.sh" <<'EOF'
#!/usr/bin/env bash
echo installer >>"${BOOTSTRAP_TEST_LOG}"
EOF
# Read the source with real chezmoi to catch invalid helper placement.
: >"${test_dir}/empty.toml"
"${CHEZMOI_TEST_COMMAND:-chezmoi}" \
	--config "${test_dir}/empty.toml" \
	--persistent-state "${test_dir}/state.boltdb" \
	--source "${test_dir}/source with spaces" \
	--destination "${HOME}" managed >/dev/null

printf 'export PATH="%s/bin:${PATH}"\n' "${test_dir}" \
	>"${HOME}/.nix-profile/etc/profile.d/nix.sh"
cat >"${test_dir}/bin/nix" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
test "$1" = profile
test "$2" = install
test "$3" = --profile
test "$4" = "${HOME}/.local/state/nix/profiles/onepassword-bootstrap"
[[ "$5" == "path:"*"/source with spaces/dot_config/home-manager#onepassword-cli" ]]
echo nix >>"${BOOTSTRAP_TEST_LOG}"
if [ "${BOOTSTRAP_TEST_FAIL:-0}" = 1 ]; then
	exit 42
fi
mkdir -p "$4/bin"
printf '#!/usr/bin/env bash\necho mock-op\n' >"$4/bin/op"
chmod +x "$4/bin/op"
EOF
chmod +x "${test_dir}/bin/nix"

hook="${test_dir}/source with spaces/.bootstrap-onepassword.sh"
bash "${hook}"
op="${HOME}/.local/state/nix/profiles/onepassword-bootstrap/bin/op"
test "$("${op}" --version)" = mock-op
test "$(cat "${BOOTSTRAP_TEST_LOG}")" = $'installer\nnix'

# An existing bootstrap profile must avoid installing anything again.
bash "${hook}"
test "$(cat "${BOOTSTRAP_TEST_LOG}")" = $'installer\nnix'

# The setup hook registers an account only when none are configured.
cat >"${op}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >>"${BOOTSTRAP_TEST_LOG}.accounts"
case "$*" in
'account list --format=json')
	if [ -e "${BOOTSTRAP_TEST_LOG}.registered" ]; then
		printf '[{"account_uuid":"test-account"}]\n'
	else
		printf '[\n  \n]\n'
	fi
	;;
'account add')
	if [ "${BOOTSTRAP_TEST_FAIL_ACCOUNT:-0}" = 1 ]; then
		exit 43
	fi
	: >"${BOOTSTRAP_TEST_LOG}.registered"
	;;
*) exit 44 ;;
esac
EOF
bash "${hook}" --setup-account
test "$(cat "${BOOTSTRAP_TEST_LOG}.accounts")" = $'account list --format=json\naccount add'
: >"${BOOTSTRAP_TEST_LOG}.accounts"
bash "${hook}" --setup-account
test "$(cat "${BOOTSTRAP_TEST_LOG}.accounts")" = 'account list --format=json'

# Do not continue after a canceled account registration.
rm "${BOOTSTRAP_TEST_LOG}.registered"
export BOOTSTRAP_TEST_FAIL_ACCOUNT=1
status=0
bash "${hook}" --setup-account || status=$?
test "${status}" = 43
test ! -e "${BOOTSTRAP_TEST_LOG}.registered"

rm "${op}"
export BOOTSTRAP_TEST_FAIL=1
status=0
bash "${hook}" || status=$?
test "${status}" = 42
test ! -e "${op}"
echo '1Password bootstrap tests passed.'
