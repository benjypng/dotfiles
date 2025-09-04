-- plugins/init.lua
return {
  '3rd/image.nvim',
  dependencies = { 'vhyrro/luarocks.nvim' },
  opts = {
    backend = 'kitty', -- works with Ghostty because it implements the Kitty Graphics Protocol
    integrations = {
      markdown = { enabled = true }, -- show images in Markdown buffers
      neorg = { enabled = true },
    },
  },
}
