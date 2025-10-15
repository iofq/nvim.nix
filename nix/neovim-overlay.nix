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
    refactoring-nvim
    render-markdown-nvim
    snacks-nvim
  ];

  basePackages = with prev; [
    ripgrep
    fd
  ];
  # Extra packages that should be included on nixos but don't need to be bundled
  extraPackages = with prev; [
    # linters
    yamllint
    jq
    hadolint
    nixfmt
    shellcheck
    golangci-lint

    # LSPs
    gopls
    lua-language-server
    nixd
    basedpyright
  ];
in
{
  nvim-pkg = mkNeovim {
    inherit plugins;
    packages = basePackages ++ extraPackages;
  };

  nvim-min-pkg = mkNeovim {
    inherit plugins;
    packages = basePackages;
  };

  nvim-luarc-json = final.mk-luarc-json {
    inherit plugins;
  };
}
