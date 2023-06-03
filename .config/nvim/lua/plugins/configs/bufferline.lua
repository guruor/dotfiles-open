-- Set bufferline's options
-- :h bufferline.nvim
local bufferline = require "bufferline"
bufferline.setup {
  options = {
    style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
    custom_filter = function(buf_number, buf_numbers)
      -- filter out filetypes you don't want to see
      if vim.bo[buf_number].filetype ~= "dbout" then
        return true
      end
    end,
    truncate_names = false,
    -- numbers = "ordinal", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    numbers = function(opts)
      if vim.api.nvim_get_current_buf() == opts.id then
        -- return string.format("%s|%s", opts.id, opts.raise(opts.ordinal))
        return string.format("%s", opts.ordinal)
      end
    end,
    separator_style = "slope", -- | "slant" | "slope" | "thick" | "thin" | { '<focused>', '<unfocused>' },
    show_buffer_close_icons = true,
    show_close_icon = true,
  },
}
