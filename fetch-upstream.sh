#!/bin/sh

VERSION="1.0.0"

wget "https://release.files.ghostty.org/$VERSION/ghostty-source.tar.gz"
wget "https://release.files.ghostty.org/$VERSION/ghostty-source.tar.gz.minisig"

minisign -Vm "ghostty-source.tar.gz" -P RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV
rm ghostty-source.tar.gz.minisig
mv ghostty-source.tar.gz "ghostty-$VERSION.tar.gz"

tar -xzmf "ghostty-$VERSION.tar.gz"
mv ghostty-source "ghostty-$VERSION"
ln -s "ghostty-$VERSION.tar.gz" "ghostty_$VERSION.orig.tar.gz"

cp -r debian "ghostty-$VERSION/debian"
