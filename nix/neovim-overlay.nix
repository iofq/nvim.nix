# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  # mkNvimPlugin = src: pname:
  #   pkgs.vimUtils.buildVimPlugin {
  #     inherit pname src;
  #     version = src.lastModifiedDate;
  #   };

  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

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
    friendly-snippets
    gitsigns-nvim
    lualine-nvim
    luasnip
    mini-nvim
    neogen
    neogit
    nightfox-nvim
    nvim-cmp
    nvim-lspconfig
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
    nvim-web-devicons
    oil-nvim
    rose-pine
    telescope-fzf-native-nvim
    telescope-nvim
    toggleterm-nvim
    undotree
    which-key-nvim
  ];

  extraPackages = with pkgs; [
    ripgrep
    gopls
    pyright
    nil
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
