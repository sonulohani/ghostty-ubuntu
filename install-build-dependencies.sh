#!/bin/sh

ZIG_VERSION="0.13.0"

# Build Tools
apt-get install -y build-essential debhelper pandoc

curl "https://ziglang.org/download/$ZIG_VERSION/zig-linux-x86_64-$ZIG_VERSION.tar.xz" -o "zig-linux-x86_64-$ZIG_VERSION.tar.xz"
tar -xf "zig-linux-x86_64-$ZIG_VERSION.tar.xz" -C /opt
ln -s "/opt/zig-linux-x86_64-$ZIG_VERSION/zig" /usr/local/bin/zig

# Ghostty Dependencies
apt-get install -y libgtk-4-dev libadwaita-1-dev
