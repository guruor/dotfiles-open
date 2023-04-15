local utils = require "utils"
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"
local z_utils = require("telescope._extensions.zoxide.utils")

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    layout_strategy = 'vertical',
    layout_config = {
          preview_cutoff = 0,
          prompt_position = "top",
          mirror = true,
          height = 0.8,
          width = 0.8,
          -- other layout configuration here
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ['?p'] = require('telescope.actions.layout').toggle_preview,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
      fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      },                             -- the default case_mode is "smart_case"
      zoxide = {
          prompt_title = "[ Walking on the shoulders of TJ ]",
          mappings = {
            default = {
              after_action = function(selection)
                print("Update to (" .. selection.z_score .. ") " .. selection.path)
              end
            },
            ["<C-s>"] = {
              before_action = function(selection) print("before C-s") end,
              action = function(selection)
                vim.cmd("edit " .. selection.path)
              end
            },
            -- Opens the selected entry in a new split
            ["<C-q>"] = { action = z_utils.create_basic_command("split") },
          },
        },
    },
    preview = {
      hide_on_startup = false -- hide previewer when picker starts
    }
}

telescope.load_extension('fzf')
telescope.load_extension('zoxide')
telescope.load_extension('textcase')
-- Mapping for text-case.nvim
vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
vim.api.nvim_set_keymap("n", "gaa", "<cmd>TextCaseOpenTelescopeQuickChange<CR>", { desc = "Telescope Quick Change" })
vim.api.nvim_set_keymap('n', 'gai', "<cmd>TextCaseOpenTelescopeLSPChange<CR>", { desc = "Telescope LSP Change" })

-- Custom helper functions
local function onComplete(picker)
    local mode = vim.fn.mode()
    local keys = mode ~= "n" and "<ESC>" or ""
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(keys .. [[^v$<C-g>]], true, false, true),
      "n",
      true
    )
    -- should you have more callbacks, just pop the first one
    table.remove(picker._completion_callbacks, 1)
    -- copy mappings s.t. eg <C-n>, <C-p> works etc
    vim.tbl_map(function(mapping)
      vim.api.nvim_buf_set_keymap(0, "s", mapping.lhs, mapping.rhs, {})
    end, vim.api.nvim_buf_get_keymap(0, "i"))
end

local function customGrepString(text, search_dirs)
    if search_dirs == nil then search_dirs = {} end

    local opts = {
        search_dirs = search_dirs,
        search = "",
        word_match = "-w",
        only_sort_text = true,
        default_text = text,
        on_complete = text ~= "" and {
            onComplete
        } or nil,
    }
    require("telescope.builtin").grep_string(opts)
end

function TelescopeSearchInSpecificDirectory()
  vim.ui.input({ prompt = "Directory: ", default = "./", completion = "dir" }, function(dir)
    dir = vim.trim(dir or "")
    if dir == "" then
      return
    end

    vim.ui.input({ prompt = "File pattern: ", default = "*" }, function(pattern)
      pattern = vim.trim(pattern or "")
      if pattern == "" or pattern == "*" then
        pattern = ""
      end

      customGrepString(pattern, { dir })
    end)
  end)
end

-- https://github.com/nvim-telescope/telescope.nvim/issues/1766#issuecomment-1150437074
-- Triggers telescope live_grep with word under the cursor by default in select mode
function TelescopeLiveGrepStringWithSelection()
  local text = utils.GetVisualorCursorText("", false)
  require("telescope.builtin").live_grep({
    default_text = text,
    on_complete = text ~= "" and {
        onComplete
    } or nil,
  })
end

-- Triggers telescope grep_string with word under the cursor by default in select mode
--:lua require'telescope.builtin'.grep_string{only_sort_text = true, search = '' }
function TelescopeGrepStringWithSelection()
  local text = utils.GetVisualorCursorText("", false)
  customGrepString(text)
end

-- Triggers telescope current_buffer_fuzzy_find with word under the cursor by default in select mode
--:lua require('telescope.builtin').current_buffer_fuzzy_find({ default_text = vim.fn.expand('<cword>') })<CR>
function TelescopeCurrentBufferFuzzyFindWithSelection()
  local text = utils.GetVisualorCursorText("", false)
  require("telescope.builtin").current_buffer_fuzzy_find({
    default_text = text,
    on_complete = text ~= "" and {
        onComplete
    } or nil,
  })
end
