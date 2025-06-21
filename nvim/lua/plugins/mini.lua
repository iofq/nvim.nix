-- ripped from lazyvim
local function setup_pairs(opts)
  local pairs = require('mini.pairs')
  pairs.setup(opts)
  local open = pairs.open
  pairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= '' then
      return open(pair, neigh_pattern)
    end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])
    if opts.markdown and o == '`' and vim.bo.filetype == 'markdown' and before:match('^%s*``') then
      return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
    end
    if opts.skip_next and next ~= '' and next:match(opts.skip_next) then
      return o
    end
    if opts.skip_ts and #opts.skip_ts > 0 then
      local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
      for _, capture in ipairs(ok and captures or {}) do
        if vim.tbl_contains(opts.skip_ts, capture.capture) then
          return o
        end
      end
    end
    if opts.skip_unbalanced and next == c and c ~= o then
      local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
      local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
      if count_close > count_open then
        return o
      end
    end
    return open(pair, neigh_pattern)
  end
end

return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    keys = {
      {
        '<leader>gp',
        function()
          MiniDiff.toggle_overlay(0)
        end,
        noremap = true,
        desc = 'git diff overlay',
      },
      {
        '<leader>go',
        function()
          return MiniGit.show_at_cursor()
        end,
        noremap = true,
        desc = 'git show at cursor',
      },
      {
        '<leader>gb',
        '<Cmd>Git blame -- %<CR>',
        noremap = true,
        desc = 'git blame',
      },
      {
        '<leader>gg',
        ':Git ',
        noremap = true,
        desc = 'git command',
      },
      {
        '<leader>fs',
        function()
          require('plugins.lib.session_jj').load()
        end,
        noremap = true,
        desc = 'mini session select',
      },
    },
    config = function()
      require('mini.basics').setup { mappings = { windows = true } }
      require('mini.tabline').setup {
        tabpage_section = 'right',
        show_icons = false,
      }
      require('mini.statusline').setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode {}
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              '%<', -- Mark general truncate point
              -- { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineDevinfo', strings = { rec, diagnostics, lsp } },
              { hl = 'MiniStatuslineDevinfo', strings = { search } },
              { hl = mode_hl,                 strings = { mode } },
            }
          end,
          inactive = function()
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            return MiniStatusline.combine_groups {
              { hl = 'MiniStatuslineFilename', strings = { filename } },
            }
          end,
        },
      }
      vim.schedule(function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.bracketed').setup()
        require('mini.icons').setup()
        require('mini.git').setup()
        require('mini.surround').setup()
        require('mini.splitjoin').setup { detect = { separator = '[,;\n]' } }

        local sessions = require('mini.sessions')
        sessions.setup {
          file = '',
          autowrite = true,
          verbose = {
            write = false,
          },
        }
        if #vim.fn.argv() == 0 then
          require('plugins.lib.session_jj').load()
        end

        local jump = require('mini.jump2d')
        jump.setup {
          view = { n_steps_ahead = 1, dim = true },
          spotter = jump.gen_spotter.vimpattern(),
        }

        setup_pairs {
          modes = { insert = true, command = true, terminal = false },
          skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
          skip_ts = { 'string' },
          skip_unbalanced = true,
          markdown = true,
        }

        local jj = require('plugins.lib.minidiff_jj')
        local diff = require('mini.diff')
        diff.setup {
          options = { wrap_goto = true },
          source = {
            jj(),
            diff.gen_source.git(),
          },
        }
        local miniclue = require('mini.clue')
        miniclue.setup {
          triggers = {
            { mode = 'n', keys = '<Leader>' },
            { mode = 'n', keys = 'g' },
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'n', keys = '"' },
            { mode = 'n', keys = '<C-w>' },
            { mode = 'n', keys = 'z' },
            { mode = 'n', keys = ']' },
            { mode = 'n', keys = '[' },
          },
          window = {
            config = { width = 'auto' },
          },
          clues = {
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
          },
        }

        local map = require('mini.map')
        map.setup {
          symbols = {
            scroll_line = '┃',
            scroll_view = '',
          },
          integrations = {
            map.gen_integration.builtin_search(),
            map.gen_integration.diagnostic(),
            map.gen_integration.diff(),
          },
          window = {
            show_integration_count = false,
          },
        }
        vim.keymap.set('n', '<leader>nm', map.toggle, { noremap = true, desc = 'minimap open' })

        local multi = require('mini.keymap').map_multistep
        multi({ 'i' }, '<BS>', { 'minipairs_bs' })
        multi({ 'i', 's' }, '<Tab>', { 'blink_accept', 'vimsnippet_next', 'increase_indent' })
        multi({ 'i', 's' }, '<S-Tab>', { 'vimsnippet_prev', 'decrease_indent' })
      end)
    end,
  },
}
