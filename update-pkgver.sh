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
echo 'Next version number:'
read -e -i "$(last_version)" version
sed -i "s/pkgver=.*/pkgver=${version}/"  PKGBUILD
sed -i "s/pkgrel=.*/pkgrel=1/"  PKGBUILD
mksrcinfo
git commit PKGBUILD .SRCINFO -m "update to ${version}"
