{pkgs, ...}:
{
  base = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim
    toggleterm-nvim
    mini-nvim
  ];
  extra = with pkgs.vimPlugins; [
    rose-pine
    gitsigns-nvim
    oil-nvim
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    vim-nix
    neogit
  ];
}
