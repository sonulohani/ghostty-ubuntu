#!/bin/sh

set -e

DEFAULT_RELEASE="1.2.0"
TARGET_RELEASE="${1:-$DEFAULT_RELEASE}"

case "$TARGET_RELEASE" in
  tip)
    TARBALL="ghostty-source.tar.gz"
    SOURCE_URL="https://github.com/ghostty-org/ghostty/releases/download/tip/$TARBALL"
    MINISIG_URL="$SOURCE_URL.minisig"
    ;;
  *)
    TARBALL="ghostty-$TARGET_RELEASE.tar.gz"
    SOURCE_URL="https://release.files.ghostty.org/$TARGET_RELEASE/$TARBALL"
    MINISIG_URL="$SOURCE_URL.minisig"
    ;;
esac

PACKAGE_REVISION="${PACKAGE_REVISION:-0~ppa1}"

echo "Fetch Ghostty Source ($TARGET_RELEASE)"
wget -q "$SOURCE_URL"
wget -q "$MINISIG_URL"

minisign -Vm "$TARBALL" -P RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV
rm "$(basename "$MINISIG_URL")"

SOURCE_DIR=$(tar -tzf "$TARBALL" | head -1 | cut -d/ -f1)
tar -xzmf "$TARBALL"
rm "$TARBALL"

cd "$SOURCE_DIR"

GHOSTTY_VERSION="${SOURCE_DIR#ghostty-}"

# Use 25.04 format for ubuntu versions, "bookwork" format for Debian
if [ $(lsb_release -si) = "Debian" ]; then
  DISTRO_VERSION=$(lsb_release -sc)
else
  DISTRO_VERSION=$(lsb_release -sr)
fi
DISTRO=$(lsb_release -sc)

FULL_VERSION="$GHOSTTY_VERSION-$PACKAGE_REVISION"
OUTPUT_VERSION=$(printf '%s' "$FULL_VERSION" | sed 's/~/./g')

# On Ubuntu it's libbz2, not libbzip2
sed -i 's/linkSystemLibrary2("bzip2", dynamic_link_opts)/linkSystemLibrary2("bz2", dynamic_link_opts)/' src/build/SharedDeps.zig

if [ $(lsb_release -sr) = "22.04" ]; then
  # Patch for older versions of some libs on ubuntu 22.04
  # Generated like this (from ghostty git source):
  # git diff -u > ../ghostty-ubuntu/ubuntu_22.04.patch
  echo "Patch for Ubuntu 22.04"
  patch -p1 < ../ubuntu_22.04.patch
fi

echo "Fetch Zig Cache"
ZIG_GLOBAL_CACHE_DIR=/tmp/offline-cache ./nix/build-support/fetch-zig-cache.sh

echo "Build Ghostty with zig"
zig build \
  --summary all \
  --prefix ./zig-out/usr \
  --system /tmp/offline-cache/p \
  -Doptimize=ReleaseFast \
  -Dcpu=baseline \
  -Dpie=true \
  -Demit-docs \
  -Dversion-string=$GHOSTTY_VERSION

echo "Setup Debian Package"
UNAME_M="$(uname -m)"
if [ "${UNAME_M}" = "x86_64" ]; then
    DEBIAN_ARCH="amd64"
elif [ "${UNAME_M}" = "aarch64" ]; then \
    DEBIAN_ARCH="arm64"
fi

# Debian control files
cp -r ../DEBIAN/ ./zig-out/DEBIAN/
sed -i "s/amd64/$DEBIAN_ARCH/g" ./zig-out/DEBIAN/control
sed -i "s/^Version: .*/Version: $FULL_VERSION/" ./zig-out/DEBIAN/control

# Changelog and copyright
mkdir -p ./zig-out/usr/share/doc/ghostty/
cp ../copyright ./zig-out/usr/share/doc/ghostty/
cp ../changelog.Debian ./zig-out/usr/share/doc/ghostty/
sed -i "s/DIST/$DISTRO/" zig-out/usr/share/doc/ghostty/changelog.Debian
sed -i "0,/ghostty (/s/ghostty ([^)]*) DIST/ghostty ($FULL_VERSION) DIST/" zig-out/usr/share/doc/ghostty/changelog.Debian
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

echo "Build Debian Package"
dpkg-deb --build zig-out "ghostty_${FULL_VERSION}_${DEBIAN_ARCH}.deb"
mv "ghostty_${FULL_VERSION}_${DEBIAN_ARCH}.deb" "../ghostty_${OUTPUT_VERSION}_${DEBIAN_ARCH}_${DISTRO_VERSION}.deb"
