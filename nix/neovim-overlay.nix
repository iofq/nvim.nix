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
  workspace-diagnostics-nvim = mkNvimPlugin inputs.workspace-diagnostics-nvim "workspace-diagnostics.nvim";

  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    aerial-nvim
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-path
    cmp-treesitter
    cmp_luasnip
    diffview-nvim
    eyeliner-nvim
    friendly-snippets
    gitsigns-nvim
    lazy-nvim
    luasnip
    markview-nvim
    mini-nvim
    neogen
    neogit
    none-ls-nvim
    nightfox-nvim
    nvim-autopairs
    nvim-cmp
    nvim-dap
    nvim-dap-go
    nvim-dap-ui
    nvim-lspconfig
    nvim-nio
    nvim-treesitter-context
    nvim-treesitter-textobjects
    (nvim-treesitter.withPlugins(p: with p; [
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-comment
      tree-sitter-css
      tree-sitter-dockerfile
      tree-sitter-embedded-template
      tree-sitter-go
      tree-sitter-gomod
      tree-sitter-hcl
      tree-sitter-html
      tree-sitter-javascript
      tree-sitter-json
      tree-sitter-lua
      tree-sitter-make
      tree-sitter-markdown
      tree-sitter-markdown-inline
      tree-sitter-nix
      tree-sitter-php
      tree-sitter-python
      tree-sitter-regex
      tree-sitter-ruby
      tree-sitter-sql
      tree-sitter-toml
      tree-sitter-typescript
      tree-sitter-yaml
    ]))
    scope-nvim
    telescope-fzf-native-nvim
    telescope-nvim
    toggleterm-nvim
    trouble-nvim
    undotree
    yanky-nvim
    workspace-diagnostics-nvim
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
    python312Packages.jedi-language-server
    phpactor

    # debuggers
    delve
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    appName = "nvim";
    extraPackages = basePackages ++ extraPackages;
  };

  nvim-min-pkg = mkNeovim {
    plugins = all-plugins;
    appName = "nvim";
    extraPackages = basePackages;
    ignoreConfigRegexes = [
      ".*lsp.lua"
      ".*debug.lua"
    ];
  };

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
