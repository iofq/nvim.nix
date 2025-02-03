# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    aerial-nvim
    avante-nvim
    inputs.nixpkgs-master.legacyPackages.${pkgs.system}.vimPlugins.blink-cmp
    blink-cmp-copilot
    blink-compat
    blink-ripgrep-nvim
    copilot-lua
    diffview-nvim
    eyeliner-nvim
    friendly-snippets
    gitsigns-nvim
    lazy-nvim
    luasnip
    mini-nvim
    neogen
    neogit
    none-ls-nvim
    nightfox-nvim
    nvim-autopairs
    # nvim-dap
    # nvim-dap-go
    # nvim-dap-ui
    nvim-lspconfig
    # nvim-nio
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    render-markdown-nvim
    scope-nvim
    snacks-nvim
    trouble-nvim
    undotree
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

    # LSPs
    gopls
    lua-language-server
    nil
    phpactor
    python312Packages.jedi-language-server
    ruby-lsp

    # debuggers
    delve

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

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
