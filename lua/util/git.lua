local M = {}

function M.root()
  return vim.fs.root(0, ".git") or vim.fs.root(assert(vim.uv.cwd()), ".git")
end

function M.deleted_paths(root)
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
  local log = vim.fn.systemlist(args)
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local seen, paths = {}, {}
  for _, path in ipairs(log) do
    if path ~= "" and not seen[path] then
      seen[path] = true
      paths[#paths + 1] = path
    end
  end
  return paths
end

function M.blob_before_deletion(root, path)
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

function M.open_blob(sha, path, lines, ft)
  local name = ("git://%s/%s"):format(sha:sub(1, 7), path)
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
