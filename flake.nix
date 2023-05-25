{
  description = "...";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ {self, nixpkgs, flake-utils, ...}:
  flake-utils.lib.eachDefaultSystem (system: let
    recursiveMerge = attrList: let
      f = attrPath:
      builtins.zipAttrsWith (n: values:
      if pkgs.lib.tail values == []
      then pkgs.lib.head values
      else if pkgs.lib.all pkgs.lib.isList values
      then pkgs.lib.unique (pkgs.lib.concatLists values)
      else if pkgs.lib.all pkgs.lib.isAttrs values
      then f (attrPath ++ [n]) values
      else pkgs.lib.last values);
    in
    f [] attrList;
    pkgs = import nixpkgs {
      inherit system;
    };
    plugins = import ./plugins.nix {
      inherit pkgs;
    };
    base = {
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;
    };
    dependancies = with pkgs; [
      ripgrep
      lazygit
    ];
    full-dependancies = with pkgs; [
      gopls
    ] ++ dependancies;
    neovim-with-deps = recursiveMerge [
      pkgs.neovim-unwrapped
      { buildInputs = dependancies; }
    ];
    neovim-with-full-deps = recursiveMerge [
      pkgs.neovim-unwrapped
      { buildInputs = full-dependancies; }
    ];
  in rec {
    packages.full = pkgs.wrapNeovim neovim-with-full-deps (base // {
      extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath full-dependancies}"'';
      configure = {
        customRC =
          ''
          lua << EOF
          package.path = "${self}/config/?.lua;" .. "${self}/config/lua/?.lua;" .. package.path
          ''
          + pkgs.lib.readFile ./config/init.lua
          + ''
          EOF
          '';
          packages.plugins = with pkgs.vimPlugins; {
            start = plugins.base ++ plugins.treesitter;
          };
        };
      });
    packages.minimal = pkgs.wrapNeovim neovim-with-deps (base // {
      extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath dependancies}"'';
      configure = {
        customRC =
          ''
          lua << EOF
          package.path = "${self}/config/?.lua;" .. "${self}/config/lua/?.lua;" .. package.path
          ''
          + pkgs.lib.readFile ./config/minimal-init.lua
          + ''
          EOF
          '';
          packages.plugins = with pkgs.vimPlugins; {
            start = plugins.base;
          };
        };
      });
      apps.full = flake-utils.lib.mkApp {
        drv = packages.full; name = "neovim"; exePath = "/bin/nvim";
      };
      apps.default = apps.full;
      packages.default = packages.full;
    });
  }
