## nvim.nix - personal Neovim config that runs on nixOS but doesn't sacrifice portability

## Usage
```bash
nix run "github:iofq/nvim.nix" #full
```

Or, grab an AppImage from the Releases page.

## What the hell?

This is a flake to build a Neovim package that includes my custom Lua config and dependencies. It then is bundled via CI into an AppImage.

## Why the hell though?

I use these AppImages because I develop in a number of airgapped environments that make traditional dotfile management a nightmare. Downloading a single AppImage and copying it around is a more suckless way of managing this.
