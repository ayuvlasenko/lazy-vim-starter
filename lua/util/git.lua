local M = {}

function M.root()
  return vim.fs.root(0, ".git") or vim.fs.root(assert(vim.uv.cwd()), ".git")
end

local function git_lines(root, args)
  local cmd = { "git", "-C", root }
  vim.list_extend(cmd, args)
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return lines
end

function M.deleted_entries(root)
  local seen, entries = {}, {}

  local function add(path, object, label)
    if path ~= "" and not seen[path] then
      seen[path] = true
      entries[#entries + 1] = { path = path, object = object, label = label }
    end
  end

  for _, path in ipairs(git_lines(root, { "diff", "--diff-filter=D", "--name-only" }) or {}) do
    add(path, ":" .. path, "index")
  end
  for _, path in ipairs(git_lines(root, { "diff", "--cached", "--diff-filter=D", "--name-only" }) or {}) do
    add(path, "HEAD:" .. path, "HEAD")
  end
  local log = git_lines(root, { "log", "--all", "--diff-filter=D", "--name-only", "--pretty=format:" })
  for _, path in ipairs(log or {}) do
    add(path)
  end

  return entries
end

function M.resolve_entry(root, entry)
  if entry.object then
    return entry
  end
  local sha = (git_lines(root, { "rev-list", "-n", "1", "--all", "--", entry.path }) or {})[1]
  if not sha or sha == "" then
    return nil
  end
  entry.object = sha .. "^:" .. entry.path
  entry.label = sha:sub(1, 7)
  return entry
end

function M.read_blob(root, object)
  return git_lines(root, { "show", object })
end

function M.open_blob(path, label, lines, ft)
  local name = ("git://%s/%s"):format(label, path)
  local buf = vim.fn.bufnr(name)
  if buf == -1 then
    buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, name)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].filetype = ft or vim.filetype.match({ filename = path }) or ""
    vim.bo[buf].modifiable = false
    vim.bo[buf].modified = false
  end
  vim.api.nvim_win_set_buf(0, buf)
end

return M
