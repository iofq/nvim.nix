if vim.g.did_load_luasnip_plugin then
  return
end
vim.g.did_load_luasnip_plugin = true

local ls = require("luasnip")
ls.config.set_config {
  history = true,
  updateevents = "TextChanged, TextChangedI",
}
require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({"i", "s"}, "<C-K>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-J>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-L>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

--------------------
-- Snippets --
--------------------
local fmta = require("luasnip.extras.fmt").fmta
ls.add_snippets("go", {
  ls.snippet("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = ls.insert_node(1, "err") })),
})
