# :ghost: Ghostty Ubuntu

This repository contains build scripts to produce an _unofficial_ Ubuntu package
(.deb) for [Ghostty](https://ghostty.org).

This is an unofficial community project to provide a package that's easy to
install on Ubuntu. If you're looking for the Ghostty source code, see
[ghostty-org/ghostty](https://github.com/ghostty-org/ghostty).

## How To Install Ghostty on Ubuntu

> [!WARNING]
> A recent GTK is required for Ghostty to work with Nvidia (GL) drivers under
> x11. **Ubuntu 22.04 LTS has GTK 4.6 which is not new enough.** (See the
> [note](https://ghostty.org/docs/install/build#debian-and-ubuntu) in the
> Ghostty docs.)

1. Download the most recent .deb package for your Ubuntu version from the
   [Releases](https://github.com/mkasberg/ghostty-ubuntu/releases) page.
2. Install the downloaded .deb package by running `sudo dpkg -i
   ghostty_*.deb`. (There's only one .deb to install, using the exact filename is
   also fine.)

## Contributing

I want to have an easy-to-install Ghostty package for Ubuntu, so I'm doing what
I can to make it happen. (Ghostty [relies on the
community](https://ghostty.org/docs/install/binary) to produce non-macOS
packages.) I'm sure the scripts I have so far can be improved, so please open an
issue or PR if you notice any problems!

GitHub Actions will run CI on each PR to test that we can produce a build.

If you want to test locally, you should be able to run
[setup-env.sh](https://github.com/mkasberg/ghostty-ubuntu/blob/main/setup-env.sh)
and
[build-ghostty.sh](https://github.com/mkasberg/ghostty-ubuntu/blob/main/build-ghostty.sh)
on your own Ubuntu system or in an Ubuntu Docker container.

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [ ] Set up a PPA (or other apt repo?) for easier updates
- [ ] Ghostty is available in official Ubuntu repos
