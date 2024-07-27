{
  description = "...";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {self, nixpkgs, flake-utils, ...}:
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
      dependencies = with pkgs; [
        ripgrep
        gopls
        pyright
        nil
        phpactor
      ];
      neovim-with-deps = recursiveMerge [
        pkgs.neovim-unwrapped
        { buildInputs = dependencies; }
      ];
      baseRC = ''
          lua << EOF
          package.path = "${self}/config/?.lua;" .. "${self}/config/lua/?.lua;" .. package.path
          vim.o.runtimepath = "${self}/config," .. vim.o.runtimepath
      '';
    in rec {
      packages.neovim = pkgs.wrapNeovim neovim-with-deps ({
        viAlias = true;
        vimAlias = true;
        withRuby = false;
        withPython3 = true;
        extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath dependencies}"'';
        configure = {
          customRC =
            baseRC
            + pkgs.lib.readFile ./config/init.lua
            + ''EOF'';
          packages.plugins = {
            start = plugins.base;
          };
        };
      });

      apps.neovim = flake-utils.lib.mkApp {
        drv = packages.neovim; name = "neovim"; exePath = "/bin/nvim";
      };
      apps.default = apps.neovim;
      packages.default = packages.neovim;
    });
}
