-- vim settings
----------------------------------------
vim.opt.autoindent = true
vim.opt.background = "light"
vim.opt.backspace = "indent,eol,start"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"           -- use system clipboard
vim.opt.completeopt = "menuone"
vim.opt.cursorline = true
vim.opt.expandtab = true                    -- insert tabs as spaces
vim.opt.guicursor = ""                      -- fixes alacritty changing cursor
vim.opt.hidden = true                       -- dont save when switching buffers
vim.opt.hlsearch = true
vim.opt.ignorecase = true                   -- ignore case in searches
vim.opt.inccommand = "split"                -- incremental live completion
vim.opt.incsearch = true
vim.opt.laststatus = 1
vim.opt.list = true
vim.opt.listchars:append("trail:·")
vim.opt.listchars:append("leadmultispace:╎ ")
vim.opt.mouse = "a"
vim.opt.nrformats:append("alpha")           -- let Ctrl-a do letters as well
vim.opt.number = true
vim.opt.pastetoggle = "<F2>"
vim.opt.path:append("**")                   -- enable fuzzy :find ing
vim.opt.relativenumber = true
vim.opt.shadafile = "NONE"                  -- disable shada
vim.opt.shiftwidth = 0                      -- >> shifts by tabstop
vim.opt.showmatch = true                    -- highlight matching brackets
vim.opt.signcolumn= "number"
vim.opt.smartcase = true                    -- unless capital query
vim.opt.smartindent = true                  -- indent according to lang
vim.opt.softtabstop = -1                    -- backspace removes tabstop
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4                         -- 4 space tabs
vim.opt.undofile = true                     -- enable auto save of undos
vim.opt.updatetime = 250                    -- decrease update time
vim.opt.virtualedit = "onemore"
vim.opt.wildmenu = true

vim.g.netrw_banner = 0                      -- disable annoying banner
vim.g.netrw_altv = 1                        -- open splits to the right
vim.g.netrw_liststyle = 3                   -- tree view
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
vim.g.indent_blankline_use_treesitter = true

-- highlight indents
vim.cmd([[ hi Whitespace ctermfg=240 ]])
-- mappings
----------------------------------------

local remap = function(type, key, value)
    vim.api.nvim_set_keymap(type,key,value,{noremap = true, silent = true});
end
remap("i", "wq", "<esc>l")
remap("v", "wq", "<esc>l")
remap("n","gr", "gT")
remap("i", "{<CR>", "{<CR>}<Esc>O")
remap("i", "(<CR>", "(<CR>)<Esc>O")
remap("n", "<C-L>", "<Cmd>nohlsearch<Bar>diffupdate<CR><C-L>")
remap("n","n", "nzz")
remap("n", "N", "Nzz")
remap("n", "Y", "y$")
remap("n","[<space>", ":<c-u>put!=repeat([''],v:count)<bar>']+1<cr>")
remap("n","]<space>", ":<c-u>put =repeat([''],v:count)<bar>'[-1<cr><Esc>")

-- autocmd
----------------------------------------
local undopath = "~/.local/share/nvim/undo"
vim.api.nvim_create_autocmd("VimEnter", {
    command = "silent !mkdir -p " .. undopath,
    group = vim.api.nvim_create_augroup("Init", {}),
})

local toggle_rel_num = vim.api.nvim_create_augroup("ToggleRelNum", {})
vim.api.nvim_create_autocmd("InsertEnter", {
    command = "set norelativenumber",
    group = toggle_rel_num,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    command = "set relativenumber",
    group = toggle_rel_num,
})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual" })
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", {}),
})

