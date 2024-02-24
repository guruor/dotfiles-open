local utils = require "utils"

local commonHeadlineConfig = {
  fat_headlines = true,
  fat_headline_upper_string = "",
  fat_headline_lower_string = "",
  codeblock_highlight = "CodeBlock",
  quote_highlight = "Quote",
  quote_string = "┃",
  dash_highlight = "Dash",
  dash_string = "_",
  doubledash_highlight = "DoubleDash",
  doubledash_string = "=",
  headline_highlights = {
    "Headline1",
    "Headline2",
    "Headline3",
    "Headline4",
    "Headline5",
    "Headline6",
    "Headline7",
  },
  bullet_highlights = {
    "@text.title.1.marker.markdown",
    "@text.title.2.marker.markdown",
    "@text.title.3.marker.markdown",
    "@text.title.4.marker.markdown",
    "@text.title.5.marker.markdown",
    "@text.title.6.marker.markdown",
  },
  bullets = { "◉", "○", "✸", "✿" },
}

local markdownHeadlineConfig = {
  treesitter_language = "markdown",
  query = vim.treesitter.query.parse(
    "markdown",
    [[
        (atx_heading [
            (atx_h1_marker)
            (atx_h2_marker)
            (atx_h3_marker)
            (atx_h4_marker)
            (atx_h5_marker)
            (atx_h6_marker)
        ] @headline)

        (thematic_break) @dash

        (fenced_code_block) @codeblock

        (block_quote_marker) @quote
        (block_quote (paragraph (inline (block_continuation) @quote)))
    ]]
  )
}

markdownHeadlineConfig = utils.merge(markdownHeadlineConfig, commonHeadlineConfig)

local norgHeadlineConfig = {
  query = vim.treesitter.query.parse(
      "norg",
      [[
          [
              (heading1_prefix)
              (heading2_prefix)
              (heading3_prefix)
              (heading4_prefix)
              (heading5_prefix)
              (heading6_prefix)
          ] @headline

          (weak_paragraph_delimiter) @dash
          (strong_paragraph_delimiter) @doubledash

          ([(ranged_tag
              name: (tag_name) @_name
              (#eq? @_name "code")
          )
          (ranged_verbatim_tag
              name: (tag_name) @_name
              (#eq? @_name "code")
          )] @codeblock (#offset! @codeblock 0 0 1 0))

          (quote1_prefix) @quote
      ]]
  ),
  headline_highlights = { "Headline" },
    bullet_highlights = {
        "@neorg.headings.1.prefix",
        "@neorg.headings.2.prefix",
        "@neorg.headings.3.prefix",
        "@neorg.headings.4.prefix",
        "@neorg.headings.5.prefix",
        "@neorg.headings.6.prefix",
    },
    bullets = { "◉", "○", "✸", "✿" },
}

norgHeadlineConfig = utils.merge(norgHeadlineConfig, commonHeadlineConfig)

-- Refer this dotfile, it has config to support for multiple filetypes
-- https://github.com/lukas-reineke/headlines.nvim/issues/57#issuecomment-1614458077
local M = {}

M.options = {
  markdown = markdownHeadlineConfig,
  vimwiki = markdownHeadlineConfig,
  norg = norgHeadlineConfig,
}

M.SetHighlights = function()
  -- Vimwiki or markdown highlight using headlines.nvim
  -- vim.api.nvim_set_hl(0, 'Headline1', { bg = 'NONE', fg = "#50fa7b", italic = false})
  -- vim.api.nvim_set_hl(0, 'Headline2', { bg = 'NONE', fg = "#8be9fd", italic = false})
  -- vim.api.nvim_set_hl(0, 'Headline3', { bg = 'NONE', fg = "#ff79c6", italic = false})
  -- vim.api.nvim_set_hl(0, 'Headline4', { bg = 'NONE', fg = "#ff79c6", italic = false})
  -- vim.api.nvim_set_hl(0, 'Headline5', { bg = 'NONE', fg = "#f1fa8c", italic = false})
  -- vim.api.nvim_set_hl(0, 'Headline6', { bg = 'NONE', fg = "#50fa7b", italic = false})
  -- vim.api.nvim_set_hl(0, 'Headline7', { bg = 'NONE', fg = "#50fa7b", italic = false})

  -- vim.api.nvim_set_hl(0, 'Quote', { bg = 'NONE', fg = '#0099EC' })
  -- vim.api.nvim_set_hl(0, 'Dash', { bg = '#58DB01', fg = 'NONE', bold = true })

  vim.api.nvim_set_hl(0, 'Headline1', { link = 'Purple' })
  vim.api.nvim_set_hl(0, 'Headline2', { link = 'Orange' })
  vim.api.nvim_set_hl(0, 'Headline3', { link = 'Fg' })
  vim.api.nvim_set_hl(0, 'Headline4', { link = 'Aqua' })
  vim.api.nvim_set_hl(0, 'Headline5', { link = 'Orange' })
  vim.api.nvim_set_hl(0, 'Headline6', { link = 'GreenBold' })
  vim.api.nvim_set_hl(0, 'Headline7', { link = 'GreenBold' })

  vim.api.nvim_set_hl(0, 'CodeBlock', { bg = '#252525', fg = 'NONE' })
  -- vim.api.nvim_set_hl(0, 'Quote', { link = 'Grey' })
  vim.api.nvim_set_hl(0, 'Quote', { link = 'Blue' })
  vim.api.nvim_set_hl(0, 'Dash', { link = 'Grey' })
end

return M
