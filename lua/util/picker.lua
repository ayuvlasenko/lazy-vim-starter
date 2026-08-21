local git = require("util.git")

local M = {}

local function deleted_file_items(root)
  local function resolve(item)
    local entry = git.resolve_entry(root, item.entry)
    item.ft = vim.filetype.match({ filename = item.text })
    local lines = entry and git.read_blob(root, entry.object)
    item.lines = lines
    item.preview = {
      text = lines and table.concat(lines, "\n") or ("Could not read " .. item.text),
      ft = item.ft or "text",
      loc = false,
    }
  end

  local items = {}
  for _, entry in ipairs(git.deleted_entries(root)) do
    items[#items + 1] = { text = entry.path, entry = entry, resolve = resolve }
  end
  return items
end

function M.deleted_files()
  local root = git.root()
  if not root then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  Snacks.picker.pick({
    title = "Deleted Files",
    items = deleted_file_items(root),
    preview = "preview",
    format = function(item, picker)
      local icon, hl = Snacks.util.icon(item.text, "file", { fallback = picker.opts.icons.files })
      local parts = {
        { Snacks.picker.util.align(icon, 2), hl, virtual = true },
        { item.text, "SnacksPickerFile" },
      }
      if item.entry.label then
        parts[#parts + 1] = { " " .. item.entry.label, "SnacksPickerComment" }
      end
      return parts
    end,
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      vim.schedule(function()
        local entry = git.resolve_entry(root, item.entry)
        local lines = item.lines or (entry and git.read_blob(root, entry.object))
        if not entry or not lines then
          vim.notify("Could not read " .. item.text, vim.log.levels.ERROR)
          return
        end
        git.open_blob(item.text, entry.label, lines, item.ft)
      end)
    end,
  })
end

return M
