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

  all-plugins = with pkgs.vimPlugins; [
    blink-cmp
    blink-copilot
    blink-ripgrep-nvim
    codecompanion-nvim
    conform-nvim
    copilot-lua
    diffview-nvim
    eyeliner-nvim
    gitsigns-nvim
    lazy-nvim
    mini-nvim
    neogit
    nightfox-nvim
    nvim-autopairs
    # nvim-dap
    # nvim-dap-go
    # nvim-dap-ui
    nvim-lint
    nvim-lspconfig
    # nvim-nio
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
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
    python312Packages.jedi-language-server

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
