{pkgs, ...}:
{
  base = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim
    toggleterm-nvim
    mini-nvim
    gitsigns-nvim
    oil-nvim
    neogit
    rose-pine
  ];
  extra = with pkgs.vimPlugins; [
    vim-nix

    #lsp
    nvim-lspconfig

    #treesitter
    (nvim-treesitter.withPlugins
    (
      plugins: with plugins; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-dockerfile
        tree-sitter-go
        tree-sitter-javascript
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-markdown
        tree-sitter-markdown-inline
        tree-sitter-nix
        tree-sitter-php
        tree-sitter-python
        tree-sitter-yaml
      ]
      )
      )
      nvim-treesitter-textobjects
    ];
  }
