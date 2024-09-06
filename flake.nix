{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    workspace-diagnostics-nvim = {
      url = "github:artemave/workspace-diagnostics.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    gen-luarc,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim-overlay
          gen-luarc.overlays.default
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          lua-language-server
          nil
          stylua
          luajitPackages.luacheck
        ];
        shellHook = ''
          ln -fs ${pkgs.nvim-luarc-json} .luarc.json
        '';
      };
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.nvim-pkg;
        nvim-min = pkgs.nvim-min-pkg;
      };
      devShells = {
        default = shell;
      };
    })
    // {
      overlays.default = neovim-overlay;
    };
}
