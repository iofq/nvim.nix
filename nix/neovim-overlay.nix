# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
let
  mkNeovim = prev.callPackage ./mkNeovim.nix { pkgs = final; };
  dart-nvim = inputs.dart.packages.x86_64-linux.default;

  plugins = with prev.vimPlugins; [
    blink-cmp
    blink-ripgrep-nvim
    conform-nvim
    dart-nvim
    mini-nvim
    nvim-autopairs
    nvim-lint
    nvim-lspconfig
    nvim-treesitter
    nvim-treesitter-textobjects
    quicker-nvim
    render-markdown-nvim
    snacks-nvim
  ];

  packages = with prev; [
    ripgrep
    fd
  ];
in
{
  nvim-pkg = mkNeovim {
    inherit plugins packages;
  };

  nvim-luarc-json = final.mk-luarc-json {
    inherit plugins;
  };
}
