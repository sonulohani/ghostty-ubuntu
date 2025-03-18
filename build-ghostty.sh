#!/bin/sh

set -e

GHOSTTY_VERSION="tip"

DISTRO_VERSION=$(lsb_release -sr)
DISTRO=$(lsb_release -sc)

#FULL_VERSION="$GHOSTTY_VERSION-0~${DISTRO}1"
FULL_VERSION="$GHOSTTY_VERSION-0~ppa1"

# Fetch Ghostty Source
wget -q "https://github.com/ghostty-org/ghostty/archive/refs/tags/tip.tar.gz"

tar -xzmf "tip.tar.gz"

cd "ghostty-$GHOSTTY_VERSION"

# On Ubuntu it's libbz2, not libbzip2
sed -i 's/linkSystemLibrary2("bzip2", dynamic_link_opts)/linkSystemLibrary2("bz2", dynamic_link_opts)/' src/build/SharedDeps.zig

# Fetch Zig Cache
ZIG_GLOBAL_CACHE_DIR=/tmp/offline-cache ./nix/build-support/fetch-zig-cache.sh

# Build Ghostty with zig
zig build \
  --summary all \
  --prefix ./zig-out/usr \
  --system /tmp/offline-cache/p \
  -Doptimize=ReleaseFast \
  -Dcpu=baseline \
  -Dpie=true \
  -Demit-docs

UNAME_M="$(uname -m)"
if [ "${UNAME_M}" = "x86_64" ]; then
    DEBIAN_ARCH="amd64"
elif [ "${UNAME_M}" = "aarch64" ]; then \
    DEBIAN_ARCH="arm64"
fi

# Debian control files
cp -r ../DEBIAN/ ./zig-out/DEBIAN/
sed -i "s/amd64/$DEBIAN_ARCH/g" ./zig-out/DEBIAN/control

# Changelog and copyright
mkdir -p ./zig-out/usr/share/doc/ghostty/
cp ../copyright ./zig-out/usr/share/doc/ghostty/
cp ../changelog.Debian ./zig-out/usr/share/doc/ghostty/
sed -i "s/DIST/$DISTRO/" zig-out/usr/share/doc/ghostty/changelog.Debian
gzip -n -9 zig-out/usr/share/doc/ghostty/changelog.Debian

# Compress manpages
gzip -n -9 zig-out/usr/share/man/man1/ghostty.1
gzip -n -9 zig-out/usr/share/man/man5/ghostty.5

## postinst, preinst and prerm are used by dpkg-deb; ensure they are executable
chmod +x zig-out/DEBIAN/postinst
chmod +x zig-out/DEBIAN/preinst
chmod +x zig-out/DEBIAN/prerm

# Zsh looks for /usr/local/share/zsh/site-functions/
# but looks for /usr/share/zsh/vendor-completions/
# (note the difference when we're not in /usr/local).
mv zig-out/usr/share/zsh/site-functions zig-out/usr/share/zsh/vendor-completions

dpkg-deb --build zig-out "ghostty_${FULL_VERSION}_${DEBIAN_ARCH}.deb"
mv "ghostty_${FULL_VERSION}_${DEBIAN_ARCH}.deb" "../ghostty_${FULL_VERSION}_${DEBIAN_ARCH}_${DISTRO_VERSION}.deb"
