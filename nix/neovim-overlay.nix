# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  mkNeovim = prev.callPackage ./mkNeovim.nix { pkgs-wrapNeovim = prev; };

  plugins = with final.vimPlugins; [
    blink-cmp
    blink-ripgrep-nvim
    conform-nvim
    dart-nvim
    diffview-nvim
    eyeliner-nvim
    friendly-snippets
    lazy-nvim
    mini-nvim
    nvim-autopairs
    nvim-lint
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context
    nvim-treesitter-textobjects
    quicker-nvim
    refactoring-nvim
    render-markdown-nvim
    snacks-nvim
  ];

  basePackages = with final; [
    ripgrep
    fd
  ];
  # Extra packages that should be included on nixos but don't need to be bundled
  extraPackages = with final; [
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
    nil
    basedpyright

    #other
    jujutsu
  ];
in
{
  nvim-pkg = mkNeovim {
    inherit plugins;
    extraPackages = basePackages ++ extraPackages;
  };

  nvim-min-pkg = mkNeovim {
    inherit plugins;
    extraPackages = basePackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    inherit plugins;
    extraPackages = basePackages ++ extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    inherit plugins;
  };
}
