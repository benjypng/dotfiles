local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('typescript', {
  s('cssglobal', {
    t "declare module '*.css?raw' { const content: string; export default content; }",
  }),
})
