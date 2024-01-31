local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  -- local totalLines = vim.api.nvim_buf_line_count(0)
  local foldedLines = endLnum - lnum
  -- local suffix = (" 󰦸 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
  local suffix = (" 󰦷 %d"):format(foldedLines)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
  suffix = (" "):rep(rAlignAppndx) .. suffix
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

local ftMap = {
  python = { "lsp", "indent" },
  go = { "lsp", "treesitter" },
  vim = "indent",
  git = "",
}

local function customizeSelector(bufnr)
  local function handleFallbackException(err, providerName)
    if type(err) == "string" and err:match "UfoFallbackException" then
      return require("ufo").getFolds(providerName, bufnr)
    else
      return require("promise").reject(err)
    end
  end

  return require("ufo")
    .getFolds("lsp", bufnr)
    :catch(function(err)
      return handleFallbackException(err, "treesitter")
    end)
    :catch(function(err)
      return handleFallbackException(err, "indent")
    end)
end

local M = {}

M.options = {
  filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
  open_fold_hl_timeout = 400,
  provider_selector = function(bufnr, filetype, buftype)
    -- return { "lsp", "indent" }
    return ftMap[filetype] or customizeSelector
  end,
  preview = {
    win_config = {
      border = { "", "─", "", "", "", "─", "", "" },
      -- winhighlight = "Normal:Folded",
      winblend = 0,
    },
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>",
      jumpTop = "[",
      jumpBot = "]",
    },
  },
  close_fold_kinds = { "imports", "comment" },
  fold_virt_text_handler = handler,
}

M.SetVimOptions = function()
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  -- vim.opt.foldcolumn = "auto:2"
  vim.opt.foldcolumn = "0"
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true

  -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  vim.keymap.set("n", "zR", require("ufo").openAllFolds)
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
  vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
  vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
  vim.keymap.set("n", "K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      -- vim.lsp.buf.hover()
      vim.cmd [[ Lspsaga hover_doc ]]
    end
  end)
end

return M
