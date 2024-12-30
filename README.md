# :ghost: Ghostty Ubuntu

This repository contains build scripts to produce an _unofficial_ Ubuntu package (.deb) for [Ghostty](https://ghostty.org).

This is an unofficial community project to provide a package that's easy to install on Ubuntu. If you're looking for the Ghostty source code, see [ghostty-org/ghostty](https://github.com/ghostty-org/ghostty).

## How To Install Ghostty on Ubuntu

- Download the most recent `.deb` package from the [Releases](https://github.com/mkasberg/ghostty-ubuntu/releases) page.
- Install the downloaded `.deb` package by running `sudo dpkg -i ghostty-*.deb`.

## Contributing

I have little exprience building and maintaining Ubuntu packages, but as a software engineer who spends a lot of time in Ubuntu I have something close to the right skill set for it. I want to have an easy-to-install Ghostty package for Ubuntu, so I'm doing what I can to make it happen. (Ghostty [relies on the community](https://ghostty.org/docs/install/binary) to produce non-macOS packages.) I'm sure the scripts I have so far can be improved, so please open an issue or PR if you notice any problems!

To teach myself how to package this, I read the [Guide for Debian Maintainers](https://www.debian.org/doc/manuals/debmake-doc/index.en.html) and also skimmed the older [Debian New Maintainers' Guide](https://www.debian.org/doc/manuals/maint-guide/index.en.html).

## Roadmap

- [] Produce a .deb package on GitHub Releases
- [] Set up a PPA for easier updates
- [] Ghostty is available in official Ubuntu repos
