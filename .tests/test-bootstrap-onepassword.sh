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

rm "${op}"
export BOOTSTRAP_TEST_FAIL=1
status=0
bash "${hook}" || status=$?
test "${status}" = 42
test ! -e "${op}"
echo '1Password bootstrap tests passed.'
