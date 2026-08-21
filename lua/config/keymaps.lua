-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll and center screen" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll and center screen" })
vim.keymap.set("n", "<leader>J", "i<CR><Esc>^", { desc = "Split line" })

vim.keymap.set("n", "<leader>ba", function()
  Snacks.bufdelete.all()
end, { desc = "Delete All Buffers" })

vim.keymap.set("n", "<leader>cw", function()
  local word = vim.fn.expand("<cword>")
  local dict = vim.fn.expand("~/.config/cspell/custom-words.txt")
  local file = io.open(dict, "a")
  if file then
    file:write(word .. "\n")
    file:close()
    vim.notify("Added '" .. word .. "' to cspell dictionary", vim.log.levels.INFO)
    require("lint").try_lint("cspell")
  end
end, { desc = "Add word to cspell dictionary" })

local deleted_files_limit = 100

local function git_blob_before_deletion(root, path)
  local sha = vim.fn.systemlist({ "git", "-C", root, "rev-list", "-n", "1", "--all", "--", path })[1]
  if not sha or sha == "" then
    return nil
  end
  local lines = vim.fn.systemlist({ "git", "-C", root, "show", sha .. "^:" .. path })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return sha, lines
end

local function deleted_files(root, search)
  local args = {
    "git",
    "-C",
    root,
    "log",
    "--all",
    "--diff-filter=D",
    "--name-only",
    "--pretty=format:",
  }
  if search ~= "" then
    args[#args + 1] = "--"
    args[#args + 1] = ":(icase)*" .. search .. "*"
  end

  local log = vim.fn.systemlist(args)
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local seen, items = {}, {}
  for _, path in ipairs(log) do
    if path ~= "" and not seen[path] then
      seen[path] = true
      items[#items + 1] = {
        text = path,
        file = path,
        resolve = function(item)
          local sha, lines = git_blob_before_deletion(root, path)
          item.preview = {
            text = lines and table.concat(lines, "\n") or ("Could not read " .. path),
            ft = vim.filetype.match({ filename = path }) or "text",
            loc = false,
          }
          item.sha = sha
        end,
      }
      if #items >= deleted_files_limit then
        break
      end
    end
  end
  return items
end

vim.keymap.set("n", "<leader>gx", function()
  local root = vim.fs.root(0, ".git") or vim.fs.root(assert(vim.uv.cwd()), ".git")
  if not root then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  Snacks.picker.pick({
    title = "Deleted Files",
    live = true,
    supports_live = true,
    limit = deleted_files_limit,
    limit_live = deleted_files_limit,
    format = "filename",
    preview = "preview",
    finder = function(_, ctx)
      return deleted_files(root, ctx.filter.search)
    end,
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      vim.schedule(function()
        local sha, lines = git_blob_before_deletion(root, item.text)
        if not sha then
          vim.notify("Could not read " .. item.text, vim.log.levels.ERROR)
          return
        end
        local name = ("git://%s/%s"):format(sha:sub(1, 7), item.text)
        local buf = vim.fn.bufnr(name)
        if buf == -1 then
          buf = vim.api.nvim_create_buf(true, true)
          vim.api.nvim_buf_set_name(buf, name)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].filetype = vim.filetype.match({ filename = item.text }) or ""
          vim.bo[buf].modifiable = false
          vim.bo[buf].modified = false
        end
        vim.api.nvim_win_set_buf(0, buf)
      end)
    end,
  })
end, { desc = "Deleted files (git)" })
