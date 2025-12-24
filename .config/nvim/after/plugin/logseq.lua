local curl = require 'plenary.curl'
local fzf = require 'fzf-lua'
local secrets = require 'secrets'
vim.env.LOGSEQ_API_KEY = secrets.LOGSEQ_API_KEY

local API_URL = 'http://127.0.0.1:12315/api'
local API_TOKEN = vim.env.LOGSEQ_API_KEY

if not API_TOKEN or API_TOKEN == '' then
  vim.notify('Logseq: API Token not found in environment!', vim.log.levels.ERROR)
  return
end

local function tree_to_markdown(blocks, level, lines)
  for _, block in ipairs(blocks) do
    local indent = string.rep('  ', level)
    local content = block.content or ''

    if content ~= '' then
      local block_lines = vim.split(content, '\n', { plain = true })

      for i, line in ipairs(block_lines) do
        if i == 1 then
          table.insert(lines, indent .. line)
        else
          table.insert(lines, indent .. line)
        end
      end
    end

    if block.children and #block.children > 0 then
      tree_to_markdown(block.children, level + 1, lines)
    end
  end
end

local function fetch_and_paste(page_name)
  print('Fetching content for: ' .. page_name)

  local res = curl.post(API_URL, {
    headers = { ['Authorization'] = 'Bearer ' .. API_TOKEN, ['Content-Type'] = 'application/json' },
    body = vim.json.encode {
      method = 'logseq.Editor.getPageBlocksTree',
      args = { page_name },
    },
  })

  if res.status ~= 200 then
    vim.notify('Logseq API Error: ' .. res.status, vim.log.levels.ERROR)
    return
  end

  local success, data = pcall(vim.json.decode, res.body)
  if not success or not data or #data == 0 then
    vim.notify('Page is empty or failed to parse.', vim.log.levels.WARN)
    return
  end

  local lines = {}
  tree_to_markdown(data, 0, lines)

  vim.schedule(function()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    print('Imported ' .. #lines .. ' blocks.')
  end)
end

local function pick_page(pages)
  fzf.fzf_exec(pages, {
    prompt = 'Logseq Pages> ',
    actions = {
      ['default'] = function(selected)
        fetch_and_paste(selected[1])
      end,
    },
  })
end

-- --- STEP 1: Get All Pages ---
local function start_logseq_pull()
  print 'Fetching page list from Logseq...'

  local query = '[:find (pull ?b [*]) :where [?t :block/name "page"] [?b :block/tags ?t]]'

  local res = curl.post(API_URL, {
    headers = { ['Authorization'] = 'Bearer ' .. API_TOKEN, ['Content-Type'] = 'application/json' },
    body = vim.json.encode {
      method = 'logseq.DB.datascriptQuery',
      args = { query },
    },
  })

  if res.status ~= 200 then
    vim.notify('Failed to fetch pages. Is Logseq running?', vim.log.levels.ERROR)
    return
  end

  local success, data = pcall(vim.json.decode, res.body)
  if not success then
    vim.notify(data)
    return
  end

  local page_names = {}
  for _, item in ipairs(data) do
    if item[1] then
      local page_data = item[1]
      if page_data and page_data.title then
        table.insert(page_names, page_data.title)
      elseif page_data and page_data.name then
        table.insert(page_names, page_data.name)
      end
    end
  end

  table.sort(page_names)

  pick_page(page_names)
end

vim.api.nvim_create_user_command('LogseqPull', start_logseq_pull, {})
