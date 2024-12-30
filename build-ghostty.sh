#!/bin/sh

ZIG_VERSION="0.13.0"
GHOSTTY_VERSION="1.0.0"

# Install Build Tools
apt-get update && sudo apt-get install -y build-essential debhelper devscripts pandoc libonig-dev libbz2-dev

curl -s "https://ziglang.org/download/$ZIG_VERSION/zig-linux-x86_64-$ZIG_VERSION.tar.xz" -o "zig-linux-x86_64-$ZIG_VERSION.tar.xz"
tar -xf "zig-linux-x86_64-$ZIG_VERSION.tar.xz" -C /opt
rm "zig-linux-x86_64-$ZIG_VERSION.tar.xz"
ln -s "/opt/zig-linux-x86_64-$ZIG_VERSION/zig" /usr/local/bin/zig

# Install Ghostty Dependencies
apt-get install -y libgtk-4-dev libadwaita-1-dev

# Fetch Ghostty Source
wget "https://release.files.ghostty.org/$GHOSTTY_VERSION/ghostty-source.tar.gz"
wget "https://release.files.ghostty.org/$GHOSTTY_VERSION/ghostty-source.tar.gz.minisig"

minisign -Vm "ghostty-source.tar.gz" -P RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV
rm ghostty-source.tar.gz.minisig
mv ghostty-source.tar.gz "ghostty-$GHOSTTY_VERSION.tar.gz"

tar -xzmf "ghostty-$GHOSTTY_VERSION.tar.gz"
mv ghostty-source "ghostty-$GHOSTTY_VERSION"
ln -s "ghostty-$GHOSTTY_VERSION.tar.gz" "ghostty_$GHOSTTY_VERSION.orig.tar.gz"

cp -r debian "ghostty-$GHOSTTY_VERSION/debian"

# Build Ghostty
cd "ghostty-$GHOSTTY_VERSION"
debuild --prepend-path /usr/local/bin
