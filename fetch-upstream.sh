#!/bin/bash

VERSION="1.0.0"

curl "https://release.files.ghostty.org/$VERSION/ghostty-source.tar.gz" -o "ghostty-$VERSION.tar.gz"
#curl "https://release.files.ghostty.org/VERSION/ghostty-source.tar.gz.minisig" -o "ghostty-$VERSION.tar.gz.minisig"

#minisign -Vm "ghostty-$VERSION.tar.gz" -P RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV

tar -xzmf "ghostty-$VERSION.tar.gz"
mv ghostty-source "ghostty-$VERSION"
ln -s "ghostty-$VERSION.tar.gz" "ghostty_$VERSION.orig.tar.gz"

