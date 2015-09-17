#!/bin/bash -e

cd "$(dirname "$0")/.."
git pull
echo Last Revisions:
git log --format=oneline | head -n3
echo
echo -n Next version number: 
read version
sed -i "s/pkgver=.*/pkgver=${version}/"  PKGBUILD
mksrcinfo
git commit PKGBUILD .SRCINFO -m "update to ${version}"
