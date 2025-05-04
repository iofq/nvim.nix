# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;
  pkgs-wrapNeovim = prev;

  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  mini-nvim-git = mkNvimPlugin inputs.mini-nvim "mini.nvim";

  all-plugins = with pkgs.vimPlugins; [
    blink-cmp
    blink-copilot
    blink-ripgrep-nvim
    codecompanion-nvim
    conform-nvim
    copilot-lua
    diffview-nvim
    eyeliner-nvim
    friendly-snippets
    lazy-nvim
    mini-nvim-git
    neogit
    nightfox-nvim
    nvim-lint
    nvim-lspconfig
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    oil-nvim
    refactoring-nvim
    render-markdown-nvim
    scope-nvim
    snacks-nvim
    trouble-nvim
    treewalker-nvim
    yanky-nvim
  ];

  basePackages = with pkgs; [
    ripgrep
    fd
  ];
  extraPackages = with pkgs; [
    # linters
    puppet-lint
    yamllint
    jq

    # LSPs
    gopls
    lua-language-server
    nil
    phpactor
    basedpyright

    #other
    jujutsu
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    appName = "nvim";
    extraPackages = basePackages ++ extraPackages;
    withNodeJs = true;
  };

  nvim-min-pkg = mkNeovim {
    plugins = all-plugins;
    appName = "nvim";
    extraPackages = basePackages;
    ignoreConfigRegexes = [
      ".*lsp.lua"
      ".*debug.lua"
      ".*ai.lua"
    ];
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
