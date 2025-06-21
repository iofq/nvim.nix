vim.g.mapleader = ' '
-- If lazy_opts is set, we're running in wrapped neovim via nix
if not LAZY_OPTS then
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
  LAZY_OPTS = {
    spec = { { import = 'plugins' } },
    performance = {
      reset_packpath = false,
      rtp = {
        reset = false,
        disabled_plugins = {
          'netrwPlugin',
          'tutor',
        },
      },
    },
  }
end
vim.cmd('packadd cfilter')
require('lazy').setup(LAZY_OPTS)
require('config')
