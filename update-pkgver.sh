#!/bin/bash -e

last_version() {
    curl -s https://brulhart.me/rss-bridge/\?action\=display\&bridge\=MozillaFirefoxReleasesBridge\&format\=JsonFormat \
    | jq -r '.[0].title'
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
