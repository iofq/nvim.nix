vim.g.mapleader = ' '
-- If lazy_opts is set, we're running in wrapped neovim via nix
if not lazy_opts then
  -- Bootstrapping lazy.nvim
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
  lazy_opts = {
    spec = { { import = 'plugins' } },
    disabled_plugins = {
      'netrwPlugin',
      'tutor',
      'zipPlugin',
    },
  }
end
require('lazy').setup(lazy_opts)
require('config')
