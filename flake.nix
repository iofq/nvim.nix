{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dart = {
      url = "github:iofq/dart.nvim";
    };
    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      systems = builtins.attrNames nixpkgs.legacyPackages;

      # This is where the Neovim derivation is built.
      neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
      finalOverlays = [
        inputs.neovim-nightly-overlay.overlays.default
        inputs.nvim-treesitter-main.overlays.default
        (final: prev: {
          vimPlugins = prev.vimPlugins.extend (
            f: p: {
              nvim-treesitter = p.nvim-treesitter.withAllGrammars;
              nvim-treesitter-textobjects = p.nvim-treesitter-textobjects.overrideAttrs {
                dependencies = [ f.nvim-treesitter ];
              };
            }
          );
        })
        neovim-overlay
      ];
    in
    flake-utils.lib.eachSystem systems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = finalOverlays ++ [
            inputs.gen-luarc.overlays.default
          ];
        };
        shell = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            lua-language-server
            nixd
            stylua
            luajitPackages.luacheck
          ];
          shellHook = ''
            # symlink the .luarc.json generated in the overlay
            ln -fs ${pkgs.nvim-luarc-json} .luarc.json
          '';
        };
      in
      {
        packages = rec {
          default = nvim;
          nvim = pkgs.nvim-pkg;
        };
        devShells = {
          default = shell;
        };
      }
    )
    // {
      overlays.default = nixpkgs.lib.composeManyExtensions finalOverlays;
    };
}
