local utils = require('go.utils')

local gorename = 'gorename'
local vfn = vim.fn

local lsprename = function()
  local input = vim.ui.input

  vim.ui.input = _GO_NVIM_CFG.go_input()
  vim.lsp.buf.rename()
  return vim.defer_fn(function()
    vim.ui.input = input
  end, 1000)
end

local run = function(to_identifier, ...)
  require('go.install').install(gorename)
  local fname = vfn.expand('%:p') -- %:p:h ? %:p

  local old_identifier = vfn.expand('<cword>')

  local prompt = vfn.printf("GoRename '%s' to (may take a while) :", old_identifier)
  to_identifier = to_identifier or vfn.input(prompt, old_identifier)
  local byte_offset = vfn.wordcount().cursor_bytes

  local client = require('go.lsp').client()
  if client then
    -- TODO check gopls?
    return lsprename()
  end
end
return { run = run, lsprename = lsprename }
