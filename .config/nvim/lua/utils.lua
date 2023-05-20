local M = {}

M.merge = function(t1, t2)
    for k, v in pairs(t2) do t1[k] = v end
    return t1
end

M._if = function(bool, a, b)
    if bool then
        return a
    else
        return b
    end
end

M.map = function(modes, key, result, options)
    options = M.merge({noremap = true, silent = false, expr = false, nowait = false}, options or {})
    local buffer = options.buffer
    options.buffer = nil

    if type(modes) ~= "table" then modes = {modes} end

    for i = 1, #modes do
        if buffer then
            vim.api.nvim_buf_set_keymap(0, modes[i], key, result, options)
        else
            vim.api.nvim_set_keymap(modes[i], key, result, options)
        end
    end
end

function _G.copy(obj, seen)
    if type(obj) ~= "table" then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in next, obj do res[copy(k, s)] = copy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

function _G.P(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.R(package)
    package.loaded[package] = nil
    return require(package)
end

function _G.T()
    print(require("nvim-treesitter.ts_utils").get_node_at_cursor():type())
end

M.ansi_codes = {
    _clear = "[0m",
    _red = "[0;31m",
    _green = "[0;32m",
    _yellow = "[0;33m",
    _blue = "[0;34m",
    _magenta = "[0;35m",
    _cyan = "[0;36m",
    _grey = "[0;90m",
    _dark_grey = "[0;97m",
    _white = "[0;98m",
    red = function(self, string)
        return self._red .. string .. self._clear
    end,
    green = function(self, string)
        return self._green .. string .. self._clear
    end,
    yellow = function(self, string)
        return self._yellow .. string .. self._clear
    end,
    blue = function(self, string)
        return self._blue .. string .. self._clear
    end,
    magent = function(self, string)
        return self._magenta .. string .. self._clear
    end,
    cyan = function(self, string)
        return self._cyan .. string .. self._clear
    end,
    grey = function(self, string)
        return self._grey .. string .. self._clear
    end,
    dark_grey = function(self, string)
        return self._dark_grey .. string .. self._clear
    end,
    white = function(self, string)
        return self._white .. string .. self._clear
    end
}

M.shorten_string = function(string, length)
    if #string < length then return string end
    local start = string:sub(1, (length / 2) - 2)
    local _end = string:sub(#string - (length / 2) + 1, #string)
    return start .. "..." .. _end
end

M.wrap_lines = function(input, width)
    local output = {}
    for _, line in ipairs(input) do
        line = line:gsub("\r", "")
        while #line > width + 2 do
            local trimmed_line = string.sub(line, 1, width)
            local index = trimmed_line:reverse():find(" ")
            if index == nil or index > #trimmed_line / 2 then break end
            table.insert(output, string.sub(line, 1, width - index))
            line = vim.o.showbreak .. string.sub(line, width - index + 2, #line)
        end
        table.insert(output, line)
    end

    return output
end

-- see if the file exists
M.file_exists = function(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

M.split = function(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

M.tbl_length = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

M.get_visual_selection = function(delimeter, use_last_position)
    delimeter = delimeter or "\n"
    if use_last_position == nil then use_last_position = true end
    -- this will exit visual mode
    -- use 'gv' to reselect the text
    local _, csrow, cscol, cerow, cecol
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '' then
      -- if we are in visual mode use the live position
      _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
      _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
      if mode == 'V' then
        -- visual line doesn't provide columns
        cscol, cecol = 0, 999
      end
      -- exit visual mode
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>",
          true, false, true), 'n', true)
    else
        if use_last_position then
            -- otherwise, use the last known visual position
            _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
            _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
        end
    end
    -- swap vars if needed
    if csrow ~= nil and cerow ~= nil and cscol ~= nil and cecol ~=nil then
        if cerow < csrow then csrow, cerow = cerow, csrow end
        if cecol < cscol then cscol, cecol = cecol, cscol end
    end
    local lines = vim.fn.getline(csrow, cerow)
    local n = M.tbl_length(lines)
    if n <= 0 then return '' end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)

    return table.concat(lines, delimeter)
end

M.GetVisualorCursorText = function(delimeter, visual, cword)
    delimeter = delimeter or "\n"
    if visual == nil then visual = true end
    if cword == nil then cword = true end

    local text = ""
    if visual == nil then
        text = M.get_visual_selection(delimeter, true)
    end

	if text ~="" and #text > 0 then
		return text
	else
        if cword then
            text = vim.fn.expand("<cword>")
            return text
        end
	end
end

return M
