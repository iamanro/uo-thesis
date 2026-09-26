#!/usr/bin/env bash
# Linux x86_64 CI installer. Update the checksum alongside package.compiler.
set -euo pipefail
root="$(dirname "$(dirname "$(realpath "$0")")")"
version="$(python3 -c 'import sys,tomllib; print(tomllib.load(open(sys.argv[1], "rb"))["package"]["compiler"])' "$root/typst.toml")"
case "$version" in
  0.15.1) sha256=a6d077d0a95eed5a2eba715b2dae06be954f624ccbf85758a03f389ded33118c ;;
  *) echo "No verified Typst archive checksum for $version" >&2; exit 1 ;;
esac
destination="${1:?Usage: install-typst.sh DESTINATION}"
mkdir -p "$destination"
destination="$(realpath "$destination")"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
archive=typst-x86_64-unknown-linux-musl.tar.xz
curl --fail --location --silent --show-error \
  "https://github.com/typst/typst/releases/download/v${version}/${archive}" \
  --output "$work/$archive"
printf '%s  %s\n' "$sha256" "$work/$archive" | sha256sum --check --strict
tar -xJf "$work/$archive" -C "$work"
install -m 755 "$work/typst-x86_64-unknown-linux-musl/typst" "$destination/typst"
"$destination/typst" --version
if [[ -n "${GITHUB_PATH:-}" ]]; then
  printf '%s\n' "$destination" >> "$GITHUB_PATH"
fi
