{pkgs, ...}:
{
  base = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim
    toggleterm-nvim
    mini-nvim
    gitsigns-nvim
    oil-nvim
    rose-pine
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
  ];
  extra = with pkgs.vimPlugins; [
    vim-nix
  ];
}
