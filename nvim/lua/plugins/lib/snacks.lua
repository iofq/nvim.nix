M = {}
M.marks = function()
  return {
    finder = 'vim_marks',
    format = 'file',
    ['local'] = false,
    global = true,
    actions = {
      markdel = function(picker)
        for _, item in ipairs(picker:selected()) do
          vim.cmd.delmarks { args = { item.label } }
        end
        vim.cmd('wshada')
        picker.list:set_selected()
        picker.list:set_target()
        picker:find()
      end,
    },
    win = {
      list = {
        keys = { ['dd'] = 'markdel' },
      },
    },
  }
end
return M
