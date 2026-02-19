# Nix Packages

Nix flake packages by RogueOneEcho.

## Available Packages

- **caesura** - CLI for transcoding FLAC audio and uploading to Gazelle-based trackers

## Install Nix

### With `root` or `sudo`

Refer to the official installation guide: https://nixos.org/download/#nix-install-linux

### Without `root` or `sudo`

You may be able to use [nix-portable](https://github.com/DavHau/nix-portable)

```bash
curl -fsSL https://raw.githubusercontent.com/RogueOneEcho/nix/main/scripts/install-nix-portable.sh | bash
```

## Install `caesura`

```bash
nix profile install github:RogueOneEcho/nix#caesura
```

## Run `caesura`

```bash
nix run github:RogueOneEcho/nix#caesura -- --help
```
