## nvim.nix - personal Neovim config. First-class nix support, but doesn't sacrifice portability

![neovim](./img.png?raw=true)

## Usage
Try it out!
```bash
nix run "github:iofq/nvim.nix" #nvim-min
```

Or use in a flake:
```nix
nvim = {
  url = "github:iofq/nvim.nix";
};
...
pkgs = import nixpkgs {
    overlays = [inputs.nvim.overlays.default]
}
... in configuration.nix
environment.systemPackages = with pkgs; [nvim];
```

Or, grab an AppImage from the Releases page.

## What the hell?

This is a flake to build a Neovim package that includes my custom Lua config and dependencies. It then is bundled via Github Actions CI into an AppImage.

## Why the hell though?

I use these AppImages because I develop in a number of airgapped environments that make traditional dotfile management a nightmare. Downloading a single AppImage and copying it around is a more suckless way of managing this, especially because the non `-min` AppImage on the releases page includes runtime tooling like linters, LSPs, debuggers, etc, that can't be installed using `meson.nvim` without internet. A single ~200mb AppImage contains my entire IDE!

The config uses `lazy.nvim` for loading lua modules, meaning we still get its awesome dependency ordering and lazy loading, and the entire config in the `nvim/` dir can actually be slapped into `~/.config/nvim` and work out of the box in a non-nix setting, using Lazy to download plugins.

For best performance, extract the AppImage using `./nvim.AppImage --appimage-extract`, then run the resulting AppRun binary inside the folder. This prevents you from having to extract the whole AppImage on startup each time which HEAVILY speeds up launch times, at the cost of more disk space usage.

## kickstart-nix-nvim
This repo is based off https://github.com/nix-community/kickstart-nix.nvim, with some changes to enable `lazy.nvim` instead of neovim's native plugin loading.

The trick for enabling both nix and non-nix usage: in `mkNeovim.nix`, we prepend a `lazy_opts` variable to `init.lua` with some nix-specific Lazy configuration (we make Lazy treat each neovim plugin installed via nix as a local "dev" plugin, and show it where to find the lua files in the nix path via `packpath`). Later in the init file, we check for the existence of this variable. If it already is set, we know we're running from a nix config and can setup Lazy accordingly. If not, we can bootstrap Lazy for non-nix usage.
