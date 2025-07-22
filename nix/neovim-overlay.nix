# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;
  pkgs-wrapNeovim = prev;

  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    blink-cmp
    blink-ripgrep-nvim
    conform-nvim
    diffview-nvim
    eyeliner-nvim
    friendly-snippets
    lazy-nvim
    mini-nvim
    nvim-lint
    nvim-lspconfig
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter-textsubjects
    nvim-treesitter.withAllGrammars
    quicker-nvim
    refactoring-nvim
    render-markdown-nvim
    snacks-nvim
    trouble-nvim
  ];

  basePackages = with pkgs; [
    ripgrep
    fd
  ];
  # Extra packages that should be included on nixos but don't need to be bundled
  extraPackages = with pkgs; [
    # linters
    alejandra
    yamllint
    jq
    hadolint
    nixfmt
    shellcheck

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
    plugins = all-plugins;
    appName = "nvim";
    extraPackages = basePackages ++ extraPackages;
    withNodeJs = false;
  };

  nvim-min-pkg = mkNeovim {
    plugins = all-plugins;
    appName = "nvim";
    extraPackages = basePackages;
    withNodeJs = false;
    withSqlite = false;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    extraPackages = basePackages ++ extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
