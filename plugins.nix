{pkgs, ...}:
{
  base = with pkgs.vimPlugins; [
    diffview-nvim
    gitsigns-nvim
    mini-nvim
    neogit
    nvim-lspconfig
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    oil-nvim
    refactoring-nvim
    rose-pine
    telescope-fzf-native-nvim
    telescope-nvim
    toggleterm-nvim
    undotree
    vim-nix
  ];
}
