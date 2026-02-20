# Nix Packages

Nix flake packages by RogueOneEcho.

## Available Packages

- **caesura** - CLI for transcoding FLAC audio and uploading to Gazelle-based trackers

## Standard Install

1. Install Nix

Refer to the [official installation guide](https://nixos.org/download/#nix-install-linux)

2. Install `caesura`

```bash
nix profile install github:RogueOneEcho/nix#caesura
```

This will install `caesura` in `~/.nix-profile/bin` which should be in your `PATH`.

3. Run `caesura`

```bash
caesura version
```

## Portable Install (without `root` or `sudo`)

1. Install [nix-portable](https://github.com/DavHau/nix-portable)

Refer to the [installation guide](https://github.com/DavHau/nix-portable?tab=readme-ov-file#get-nix-portable)

> [!TIP]
> This script will install nix-portable in `~/.local/bin`:
>
> ```bash
> curl -fsSL https://raw.githubusercontent.com/RogueOneEcho/nix/main/scripts/install-nix-portable.sh | bash
> ```
>
> Uninstall with:
>
> ```bash
> rm ~/.local/bin/nix
> rm -rf ~/.nix-portable
> ```

2. Run `caesura`

> [!NOTE]
> nix-portable doesn't support `nix profile install` so `caesura` will not be in your `PATH`.
> 
> Instead you use it via `nix run` or `nix shell`.

```bash
nix run github:RogueOneEcho/nix#caesura -- version
```

Or, if you prefer entering a shell:

```bash
nix shell github:RogueOneEcho/nix#caesura
caesura version
```
