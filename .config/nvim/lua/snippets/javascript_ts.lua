local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Create the snippets
local snippets = {
  -- Try-Catch Block
  s('trycatch', {
    t { 'try {', '  ' },
    i(1, '// Code'),
    t { '', '} catch (' },
    i(2, 'error'),
    t { ') {', '  ' },
    i(3, '// Handle error'),
    t { '', '}' },
  }),

  -- Console Log, Warn, Error
  s('clog', { t 'console.log(', i(1, "'message'"), t ');' }),
  s('warn', { t 'console.warn(', i(1, "'message'"), t ');' }),
  s('error', { t 'console.error(', i(1, "'message'"), t ');' }),

  -- Arrow Function (No Params)
  s('afn', {
    t 'const ',
    i(1, 'funcName'),
    t ' = () => {',
    t { '', '  ' },
    i(2, '// Code'),
    t { '', '};' },
  }),

  -- Arrow Function with Params
  s('afnexp', {
    t 'const ',
    i(1, 'funcName'),
    t ' = (',
    i(2, 'param'),
    t ') => {',
    t { '', '  ' },
    i(3, '// Code'),
    t { '', '};' },
  }),

  -- Traditional Function
  s('func', {
    t 'function ',
    i(1, 'functionName'),
    t '(',
    i(2, 'params'),
    t { ') {', '  ' },
    i(3, '// Code'),
    t { '', '}' },
  }),

  -- Async Function
  s('asyncfunc', {
    t 'async function ',
    i(1, 'functionName'),
    t '(',
    i(2, 'params'),
    t { ') {', '  ' },
    i(3, '// Code'),
    t { '', '}' },
  }),

  -- Class Definition
  s('class', {
    t 'class ',
    i(1, 'ClassName'),
    t ' {',
    t { '', '  constructor(' },
    i(2, 'params'),
    t { ') {', '    ' },
    i(3, '// Initialization'),
    t { '', '  }', '}' },
  }),

  -- Constructor
  s('constructor', {
    t 'constructor(',
    i(1, 'params'),
    t { ') {', '  ' },
    i(2, '// Initialization'),
    t { '', '}' },
  }),

  -- For Loop (Classic)
  s('for', {
    t 'for (let ',
    i(1, 'i'),
    t ' = 0; ',
    i(1),
    t ' < ',
    i(2, 'length'),
    t '; ',
    i(1),
    t { '++) {', '  ' },
    i(3, '// Code'),
    t { '', '}' },
  }),

  -- Foreach Loop
  s('foreach', {
    i(1, 'array'),
    t '.forEach((',
    i(2, 'item'),
    t { ') => {', '  ' },
    i(3, '// Code'),
    t { '', '});' },
  }),

  -- For-of Loop
  s('forof', {
    t 'for (const ',
    i(1, 'item'),
    t ' of ',
    i(2, 'array'),
    t { ') {', '  ' },
    i(3, '// Code'),
    t { '', '}' },
  }),

  -- For-in Loop
  s('forin', {
    t 'for (const ',
    i(1, 'key'),
    t ' in ',
    i(2, 'object'),
    t { ') {', '  ' },
    i(3, '// Code'),
    t { '', '}' },
  }),

  -- If Statement
  s('if', { t 'if (', i(1, 'condition'), t { ') {', '  ' }, i(2, '// Code'), t { '', '}' } }),

  -- If-Else Statement
  s('ifelse', {
    t 'if (',
    i(1, 'condition'),
    t { ') {', '  ' },
    i(2, '// Code'),
    t { '', '} else {', '  ' },
    i(3, '// Else code'),
    t { '', '}' },
  }),

  -- Import Statement
  s('imp', { t 'import ', i(1, 'name'), t " from '", i(2, 'module'), t "';" }),

  -- Export Statement
  s('exp', { t 'export const ', i(1, 'name'), t ' = ', i(2, 'value'), t ';' }),

  -- Export Default
  s('expdef', { t 'export default ', i(1, 'name'), t ';' }),
}

local filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }
for _, ft in ipairs(filetypes) do
  ls.add_snippets(ft, snippets, { key = ft .. '_snippets' })
  print('Added snippets for filetype: ' .. ft)
end

return snippets
