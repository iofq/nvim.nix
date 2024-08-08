local ls = require "luasnip"

local fmta = require("luasnip.extras.fmt").fmta
ls.add_snippets("go", {
  ls.snippet("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = ls.insert_node(1, "err") })),
})
