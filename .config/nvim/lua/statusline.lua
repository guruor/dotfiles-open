require ('galaxyline').short_line_list = {
  'Mundo',
  'MundoDiff',
  'NvimTree',
  'fugitive',
  'fugitiveblame',
  'help',
  'minimap',
  'qf',
  'tabman',
  'tagbar',
  'toggleterm'
}

local vi_mode_mapping = {
  ['']   = {'Empty',        '-'},
  ['!']  = {'Shell',        '-'},
  ['^V'] = {'CommonVisual', 'B'}, -- NOTE: You'll have to remove '^V' and input a 'real' '^V' sequence. You can do that with the following key sequence: <SHIFT-i> + <CTRL-v> + <CTRL-v> (don't be slow with the double <CTRL-v>)
  ['R']  = {'Replace',      'R'},
  ['Rv'] = {'Normal',       '-'},
  ['S']  = {'Normal',       '-'},
  ['V']  = {'CommonVisual', 'L'},
  ['c']  = {'Command',      'C'},
  ['ce'] = {'Normal',       '-'},
  ['cv'] = {'Normal',       '-'},
  ['i']  = {'Insert',       'I'},
  ['ic'] = {'Normal',       '-'},
  ['n']  = {'Normal',       'N'},
  ['no'] = {'Normal',       '-'},
  ['r']  = {'Normal',       '-'},
  ['r?'] = {'Normal',       '-'},
  ['rm'] = {'Normal',       '-'},
  ['s']  = {'Normal',       '-'},
  ['t']  = {'Terminal',     'T'},
  ['v']  = {'CommonVisual', 'V'}
}

require ('galaxyline').section.left = {
  {
    LeftViModeColourSet = {
      provider = function()
        if vi_mode_mapping[vim.fn.mode()] == nil then
          vim.api.nvim_command("highlight link GalaxyViModeColourUnturned GalaxyViModeEmptyUnturned")
          vim.api.nvim_command("highlight link GalaxyViModeColourInverted GalaxyViModeEmptyInverted")
        else
          vim.api.nvim_command("highlight link GalaxyViModeColourUnturned GalaxyViMode" .. vi_mode_mapping[vim.fn.mode()][1] .. "Unturned")
          vim.api.nvim_command("highlight link GalaxyViModeColourInverted GalaxyViMode" .. vi_mode_mapping[vim.fn.mode()][1] .. "Inverted")
        end
      end
    }
  },
  {
    LeftViModeSeparator = {
      highlight = 'GalaxyViModeColourUnturned',
      provider = function()
        return ' '
      end
    }
  },
  {
    LeftViMode = {
      highlight = 'GalaxyViModeColourUnturned',
      provider = function()
        if vi_mode_mapping[vim.fn.mode()] == nil then
          return ' -'
        else
          return ' ' .. string.format('%s', vi_mode_mapping[vim.fn.mode()][2])
        end
      end,
      separator = ' ',
      separator_highlight = 'GalaxyViModeColourUnturned'
    }
  },
  {
    LeftWindowNumberSeparator = {
      highlight = 'GalaxyViModeColourUnturned',
      provider = function()
        return ''
      end,
      separator = ' ',
      separator_highlight = 'GalaxyViModeColourUnturned'
    }
  },
  {
    LeftWindowNumber = {
      highlight = 'GalaxyViModeColourUnturned',
      provider = function()
        return '  ' .. vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
      end,
      separator = ' ',
      separator_highlight = 'GalaxyViModeColourUnturned'
    }
  },
  {
    LeftStatusSeparator = {
      highlight = 'GalaxyViModeColourInverted',
      provider = function()
        return ''
      end,
      separator = ' ',
      separator_highlight = 'GalaxyViModeColourInverted'
    }
  },
  {
    LeftStatusPaste = {
      highlight = 'GalaxyMapperCommon6',
      provider = function()
        if vim.o.paste then
          return ''
        else
          return ''
        end
      end,
      separator = '  ',
      separator_highlight = 'GalaxyMapperCommon6',
    }
  },
  {
    LeftStatusSpell = {
      highlight = 'GalaxyMapperCommon6',
      provider = function()
        if vim.wo.spell then
          return '暈'
        else
          return ' '
        end
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon6'
    }
  },
  -- {
  --   -- Commenting due to slow performance in large files
  --   LeftStatusMixedIndentWhiteSpace = {
  --     provider = function()
  --       vim.cmd('match none /\t/')

  --       if vim.fn.search([[\v(^\t+)]], 'nw') ~= 0 and vim.fn.search([[\v(^ +)]], 'nw') ~= 0 then
  --         vim.cmd('highlight link GalaxyLeftStatusMixedIndentWhiteSpace GalaxyMapperCommon6')
  --         vim.cmd('match ErrorMsg /\t/')
  --         return ' '
  --       end

  --       if vim.fn.search('\\s$', 'nw') ~= 0 then
  --         vim.cmd('highlight link GalaxyLeftStatusMixedIndentWhiteSpace GalaxyMapperCommon6')
  --         return 'ﲕ '
  --       end

  --       if vim.fn.search([[\v(^\t+)]], 'nw') ~= 0 then
  --         vim.cmd('highlight link GalaxyLeftStatusMixedIndentWhiteSpace GalaxyMapperCommon8')
  --       else
  --         vim.cmd('highlight link GalaxyLeftStatusMixedIndentWhiteSpace GalaxyMapperCommon6')
  --       end

  --       return ' '
  --     end,
  --     separator = ' ',
  --     separator_highlight = 'GalaxyMapperCommon6'
  --   }
  -- },
  {
    LeftGitSeparator = {
      highlight = 'GalaxyMapperCommon6',
      provider = function()
        return ''
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon6'
    }
  },
  {
    LeftGitBranch = {
      highlight = 'GalaxyMapperCommon6',
      provider = function()
        if require('galaxyline.condition').check_git_workspace() then
            branch_name = require('galaxyline.provider_vcs').get_git_branch()
            if branch_name == nil or branch_name == '' then
              return ' '
            end
          return ' ' .. branch_name
        else
          return ' '
        end
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon6'
    }
  },
  {
    LeftGitDiffSeparator = {
      highlight = 'GalaxyMapperCommon1',
      provider = function()
        return ''
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon1',
    }
  },
  {
    LeftGitDiffAdd = {
      condition = require("galaxyline.condition").check_git_workspace,
      provider = function()
        if require('galaxyline.provider_vcs').diff_add() then
          vim.cmd('highlight link GalaxyLeftGitDiffAdd GalaxyLeftGitDiffAddActive')
          return '+' .. require('galaxyline.provider_vcs').diff_add()
        else
          vim.cmd('highlight link GalaxyLeftGitDiffAdd GalaxyLeftGitDiffInactive')
          return '+0 '
        end
      end
    }
  },
  {
    LeftGitDiffModified= {
      condition = require("galaxyline.condition").check_git_workspace,
      provider = function()
        if require('galaxyline.provider_vcs').diff_modified() then
          vim.cmd('highlight link GalaxyLeftGitDiffModified GalaxyLeftGitDiffModifiedActive')
          return '~' .. require('galaxyline.provider_vcs').diff_modified()
        else
          vim.cmd('highlight link GalaxyLeftGitDiffModified GalaxyLeftGitDiffInactive')
          return '~0 '
        end
      end
    }
  },
  {
    LeftGitDiffRemove = {
      condition = require("galaxyline.condition").check_git_workspace,
      provider = function()
        if require('galaxyline.provider_vcs').diff_remove() then
          vim.cmd('highlight link GalaxyLeftGitDiffRemove GalaxyLeftGitDiffRemoveActive')
          return '-' .. require('galaxyline.provider_vcs').diff_remove()
        else
          vim.cmd('highlight link GalaxyLeftGitDiffRemove GalaxyLeftGitDiffInactive')
          return '-0 '
        end
      end
    }
  },
}

require ('galaxyline').section.mid = {
  {
    MidFileStatus = {
      provider = function()
        if vim.bo.modified then
          vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusModified')
        elseif not vim.bo.modifiable then
          vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusRestricted')
        elseif vim.bo.readonly then
          vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusReadonly')
        elseif not vim.bo.modified then
          vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusUnmodified')
        end

        if require('nvim-web-devicons').get_icon(vim.fn.expand('%:e')) then
          return require('nvim-web-devicons').get_icon(vim.fn.expand('%:e')) .. ' '
        elseif not vim.bo.modified then
          return ' '
        end
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon5'
    }
  },
  {
    MidFileName = {
      highlight = 'GalaxyMapperCommon5',
      provider = function()
        if #vim.fn.expand '%:p' == 0 then
          return '-'
        end
        if vim.fn.winwidth(0) > 150 then
          return vim.fn.expand '%:~'
        else
          return vim.fn.expand '%:t'
        end
      end
    }
  }
}

require ('galaxyline').section.right = {
  {
    RightLspError = {
      provider = function()
        if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
           return
        end
        local error_count = #vim.diagnostic.get(0, {severity=vim.diagnostic.severity.Error})
        if error_count == 0 then
          vim.cmd('highlight link GalaxyRightLspError GalaxyLeftLspInactive')
        else
          vim.cmd('highlight link GalaxyRightLspError GalaxyRightLspErrorActive')
        end

        return '!' .. error_count .. ' '
      end
    }
  },
  {
    RightLspWarning = {
      provider = function()
        if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
           return
        end
        local warning_count = #vim.diagnostic.get(0, {severity=vim.diagnostic.severity.WARN})
        if warning_count == 0 then
          vim.cmd('highlight link GalaxyRightLspWarning GalaxyLeftLspInactive')
        else
          vim.cmd('highlight link GalaxyRightLspWarning GalaxyRightLspWarningActive')
        end

        return '?' .. warning_count .. ' '
      end
    }
  },
  {
    RightLspInformation = {
      provider = function()
        if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
           return
        end

        local info_count = #vim.diagnostic.get(0, {severity=vim.diagnostic.severity.INFO})
        if info_count == 0 then
          vim.cmd('highlight link GalaxyRightLspInformation GalaxyLeftLspInactive')
        else
          vim.cmd('highlight link GalaxyRightLspInformation GalaxyRightLspInformationActive')
        end

        return '+' .. info_count .. ' '
      end
    }
  },
  {
    RightLspHint = {
      provider = function()
        if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
           return
        end

        local hint_count = #vim.diagnostic.get(0, {severity=vim.diagnostic.severity.HINT})
        if hint_count == 0 then
          vim.cmd('highlight link GalaxyRightLspHint GalaxyLeftLspInactive')
        else
          vim.cmd('highlight link GalaxyRightLspHint GalaxyRightLspHintActive')
        end

        return '-' .. hint_count .. ' '
      end
    }
  },
  {
    RightLspHintSeparator = {
      highlight = 'GalaxyMapperCommon1',
      provider = function()
        return ''
      end,
    }
  },
  {
    RightLspClient = {
      highlight = 'GalaxyMapperCommon4',
      provider = function()
        if #vim.tbl_keys(vim.lsp.buf_get_clients()) >= 1 then
          local lsp_client_name_first = vim.lsp.get_client_by_id(tonumber(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients())):match('%d+'))).name:match('%l+')

          if lsp_client_name_first == nil then
            return #vim.tbl_keys(vim.lsp.buf_get_clients()) .. ': '
          else
            return #vim.tbl_keys(vim.lsp.buf_get_clients()) .. ':' .. lsp_client_name_first .. ' '
          end
        else
          return ' '
        end
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon4'
    }
  },
  {
    RightLspClientSeparator = {
      highlight = 'GalaxyMapperCommon4',
      provider = function()
        return ''
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon4'
    }
  },
  {
    RightFileSize = {
      highlight = 'GalaxyMapperCommon4',
      provider = 'FileSize',
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon4'
    }
  },
  {
    RightTabStop = {
      highlight = 'GalaxyMapperCommon4',
      provider = function()
        return string.format('%s', vim.bo.tabstop) .. ':'
      end,
    }
  },
  {
    RightFileType = {
      provider = function()
        if vim.bo.fileencoding == 'utf-8' then
          vim.cmd('highlight link GalaxyRightFileType GalaxyMapperCommon4')
        else
          vim.cmd('highlight link GalaxyRightFileType GalaxyMapperCommon8')
        end

        return string.format('%s', vim.bo.filetype)
      end,
    }
  },
  {
    RightFileEncoding = {
      highlight = 'GalaxyMapperCommon4',
      provider = function()
        local icons = {
          dos = '',
          mac  = '',
          unix = ''
        }
        if icons[vim.bo.fileformat] then
          return icons[vim.bo.fileformat]
        else
          return ''
        end
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon4'
    }
  },
  {
    RightFileEncodingSeparator = {
      highlight = 'GalaxyMapperCommon7',
      provider = function()
        return ''
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon7'
    }
  },
  {
    RightPositionNumerical = {
      highlight = 'GalaxyMapperCommon2',
      provider = function()
        return string.format('%s:%s  ', vim.fn.line('.'), vim.fn.col('.'))
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon2'
    }
  },
  {
    RightPositionPercentage = {
      highlight = 'GalaxyMapperCommon2',
      provider = function ()
        local percent = math.floor(100 * vim.fn.line('.') / vim.fn.line('$'))
        return string.format('%s%s ☰', percent, '%')
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon2'
    }
  },
  {
    RightPositionSeparator = {
      highlight = 'GalaxyMapperCommon2',
      provider = function()
        return '  '
      end
    }
  }
}

require ('galaxyline').section.short_line_left = {
  {
    ShortLineLeftBufferType = {
      highlight = 'GalaxyMapperCommon2',
      provider = function ()
        local BufferTypeMap = {
          ['Mundo'] = 'Mundo History',
          ['MundoDiff'] = 'Mundo Diff',
          ['NvimTree'] = 'Nvim Tree',
          ['fugitive'] = 'Fugitive',
          ['fugitiveblame'] = 'Fugitive Blame',
          ['help'] = 'Help',
          ['minimap'] = 'Minimap',
          ['qf'] = 'Quick Fix',
          ['tabman'] = 'Tab Manager',
          ['tagbar'] = 'Tagbar',
          ['toggleterm'] = 'Terminal'
        }
        local name = BufferTypeMap[vim.bo.filetype] or 'Editor'
        return string.format('  %s ', name)
      end,
      separator = ' ',
      separator_highlight = 'GalaxyMapperCommon7'
    }
  },
  {
    ShortLineLeftWindowNumber = {
      highlight = 'GalaxyMapperCommon6',
      provider = function()
        return '  ' .. vim.api.nvim_win_get_number(vim.api.nvim_get_current_win()) .. ' '
      end,
      separator = '',
      separator_highlight = 'GalaxyMapperCommon1'
    }
  }
}

require ('galaxyline').section.short_line_right = {
  {
    ShortLineRightBlank = {
      highlight = 'GalaxyMapperCommon6',
      provider = function()
        if vim.bo.filetype == 'toggleterm' then
          return ' ' .. vim.api.nvim_buf_get_var(0, 'toggle_number') .. ' '
        else
          return '  '
        end
      end,
      separator = '',
      separator_highlight = 'GalaxyMapperCommon1'
    }
  },
  {
    ShortLineRightInformational = {
      highlight = 'GalaxyMapperCommon2',
      provider = function()
        return ' Neovim '
      end,
      separator = '',
      separator_highlight = 'GalaxyMapperCommon7'
    }
  }
}
