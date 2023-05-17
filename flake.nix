{
  description = "...";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ {self, nixpkgs, flake-utils, ...}:
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
    };
    dependancies = with pkgs; [
      bash fd fzf gopls ripgrep
    ];
    neovim-with-deps = recursiveMerge [
      pkgs.neovim-unwrapped
      {buildInputs = dependancies;}
    ];
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
  in rec {
    packages.iofqvim = pkgs.wrapNeovim neovim-with-deps {
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;
      extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath dependancies}"'';
      configure = {
        customRC =
          ''
          lua << EOF
          package.path = "${self}/config/lua/?.lua;" .. package.path
          ''
          + pkgs.lib.readFile ./config/init.lua
          + ''
          EOF
          '';
          packages.plugins = with pkgs.vimPlugins; {
            start = with pkgs.vimPlugins; [
              telescope-nvim
              toggleterm-nvim
              mini-nvim
              vim-go
              vim-nix
              (nvim-treesitter.withPlugins
              (
                plugins: with plugins; [
                  tree-sitter-bash
                  tree-sitter-c
                  tree-sitter-dockerfile
                  tree-sitter-go
                  tree-sitter-javascript
                  tree-sitter-json
                  tree-sitter-lua
                  tree-sitter-markdown
                  tree-sitter-nix
                  tree-sitter-php
                  tree-sitter-python
                  tree-sitter-yaml
                ]
                )
                )
                nvim-treesitter-textobjects
                leap-nvim
              ];
            };
          };
        };
        apps.iofqvim = flake-utils.lib.mkApp {
          drv = packages.iofqvim; name = "iofqvim"; exePath = "/bin/nvim";
        };
        apps.default = apps.iofqvim;
        packages.default = packages.iofqvim;
      });
    }
