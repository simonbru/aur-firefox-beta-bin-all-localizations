#!/bin/bash -e

last_version() {
    curl -s https://brulhart.me/rss-bridge/\?action\=display\&bridge\=MozillaFirefoxReleasesBridge\&format\=JsonFormat \
    | jq -r '.[0].title'
}

retrieve_hashes() {
    version="$1"
    if [[ "$version" =~ .*rc.* ]]; then
        base_version="${version%rc*}"
        rc_num="${version#*rc}"
        hashes_path="pub/firefox/candidates/${base_version}-candidates/build${rc_num}/SHA256SUMS"
    else
        hashes_path="pub/firefox/releases/${version}/SHA256SUMS"
    fi
    full_url="https://releases.mozilla.org/${hashes_path}"
    curl -- "$full_url" | egrep 'linux-.*/.*/firefox-.*\.tar\.bz2'
}

cd "$(dirname "$0")/.."
git pull
echo Last Revisions:
git log --format=oneline | head -n3
echo
preselection="$(last_version)"
echo 'Next version number:'
read -e -i "$preselection" version
sed -i "s/pkgver=.*/pkgver=${version}/"  PKGBUILD
sed -i "s/pkgrel=.*/pkgrel=1/"  PKGBUILD
makepkg --printsrcinfo > .SRCINFO
git commit PKGBUILD .SRCINFO -m "update to ${version}"
