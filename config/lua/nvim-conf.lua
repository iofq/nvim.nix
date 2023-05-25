-- vim settings ++ mini.nvim.basics
----------------------------------------
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"           -- use system clipboard
vim.opt.completeopt = "menuone"
vim.opt.expandtab = true                    -- insert tabs as spaces
vim.opt.inccommand = "split"                -- incremental live completion
vim.opt.laststatus = 1
vim.opt.list = true
vim.opt.listchars:append("trail:·")
vim.opt.listchars:append("leadmultispace:╎ ")
vim.opt.nrformats:append("alpha")           -- let Ctrl-a do letters as well
vim.opt.path:append("**")                   -- enable fuzzy :find ing
vim.opt.relativenumber = true
vim.opt.shadafile = "NONE"                  -- disable shada
vim.opt.shiftwidth = 0                      -- >> shifts by tabstop
vim.opt.showmatch = true                    -- highlight matching brackets
vim.opt.showmode = true
vim.opt.softtabstop = -1                    -- backspace removes tabstop
vim.opt.swapfile = false
vim.opt.tabstop = 4                         -- 4 space tabs
vim.opt.updatetime = 250                    -- decrease update time
vim.opt.virtualedit = "onemore"

vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
vim.g.indent_blankline_use_treesitter = true

-- no highlight floats
vim.cmd([[ hi NormalFloat ctermbg=none ]])

-- mappings
----------------------------------------

local remap = function(type, key, value)
    vim.api.nvim_set_keymap(type,key,value,{noremap = true, silent = true});
end

remap("i", "wq", "<esc>l")
remap("v", "wq", "<esc>l")
remap("n","gr", "gT")
remap("n","n", "nzz")
remap("n", "N", "Nzz")
remap("n", "Y", "y$")
remap("n","[<space>", ":<c-u>put!=repeat([''],v:count)<bar>']+1<cr>")
remap("n","]<space>", ":<c-u>put =repeat([''],v:count)<bar>'[-1<cr><Esc>")
remap("n","M", "m0i<cr><Esc>`0")

-- autocmd
----------------------------------------
local undopath = "~/.local/share/nvim/undo"
vim.api.nvim_create_autocmd("VimEnter", {
    command = "silent !mkdir -p " .. undopath,
    group = vim.api.nvim_create_augroup("Init", {}),
})
