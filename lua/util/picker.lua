local git = require("util.git")

local M = {}

local function deleted_file_items(root)
  local function resolve(item)
    item.ft = vim.filetype.match({ filename = item.text })
    local sha, lines = git.blob_before_deletion(root, item.text)
    item.sha, item.lines = sha, lines
    item.preview = {
      text = lines and table.concat(lines, "\n") or ("Could not read " .. item.text),
      ft = item.ft or "text",
      loc = false,
    }
  end

  local items = {}
  for _, path in ipairs(git.deleted_paths(root)) do
    items[#items + 1] = { text = path, resolve = resolve }
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
      return {
        { Snacks.picker.util.align(icon, 2), hl, virtual = true },
        { item.text, "SnacksPickerFile" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      vim.schedule(function()
        local sha, lines = item.sha, item.lines
        if not sha then
          sha, lines = git.blob_before_deletion(root, item.text)
        end
        if not sha then
          vim.notify("Could not read " .. item.text, vim.log.levels.ERROR)
          return
        end
        git.open_blob(sha, item.text, lines, item.ft)
      end)
    end,
  })
end

return M
