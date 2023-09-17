local ls = require("luasnip")
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local extras = require("luasnip.extras")
-- local l = extras.lambda
-- local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
-- local parse = require("luasnip.util.parser").parse_snippet
local ts_utils = require("nvim-treesitter.ts_utils")

-- getting raw html as string from LSP at cursor position
local function get_parent_el_html()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return nil
  end
  local node_type = current_node:type()
  if node_type == "self_closing_tag" or node_type == "attribute_name" then
    local parent = current_node:parent()
    if parent == nil then
      return nil
    end
    if parent:type() == "element" then
      -- html code string
      return tostring(vim.treesitter.get_node_text(parent, 0))
    end
  end
  return nil
end

-- retrieve console command output
local function system(cmd)
  local handle = assert(io.popen(cmd, "r"))
  local output = assert(handle:read("*a"))
  handle:close()
  return string.gsub(output, "%s+$", "")
end

-- check if current tag is IMG and
-- it has SRC attribute without WIDTH
local last_img_html = nil
local function match_img_tag_without_size()
  local tag_str = get_parent_el_html()
  if tag_str == nil then
    -- fallback: current line
    -- if LSP is not available
    tag_str = vim.fn.getline(".")
  end
  -- cache result
  last_img_html = tag_str
  if string.find(tag_str, "<img ") == nil then
    return false
  end
  local found_width = string.find(tag_str, "width=")
  local found_src = string.find(tag_str, "src=")
  return found_width == nil and found_src
end

local function normalize_path(file)
  -- if file starts with / or ~, return
  if string.find(file, "^/") or string.find(file, "^~") then
    return vim.fn.expand(file)
  end
  -- get current vim buffer directory
  local buf_dir = vim.fn.expand("%:p:h")
  return buf_dir .. "/" .. vim.fn.expand(file)
end

-- Snippets for HTML
return {
  ls.s(
    {
      trig = "w",
      name = "Insert Img Size",
      dscr = "Append width & height",
      priority = 2000,
    },
    f(function()
      local src = string.match(tostring(last_img_html), "%ssrc=[\"']([^'\"]+)")
      local cmd = 'identify -format \'width="%w" height="%h"\' "' .. normalize_path(src) .. '"'
      local output = system(cmd)
      if not output or not string.match(output, "height") then
        return 'width="" height=""'
      end
      return output
    end),
    {
      show_condition = match_img_tag_without_size,
      condition = match_img_tag_without_size,
    }
  ),
}
