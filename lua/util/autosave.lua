local M = {}

local skipped_on_conflict = {}

local function track_disk_mtime(args)
  local name = vim.api.nvim_buf_get_name(args.buf)
  if name ~= "" then
    vim.b[args.buf].disk_mtime_at_last_sync = vim.fn.getftime(name)
  end
end

local function is_autosavable(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].modified
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function conflicts_with_disk(buf)
  local known = vim.b[buf].disk_mtime_at_last_sync
  return known ~= nil and vim.fn.getftime(vim.api.nvim_buf_get_name(buf)) ~= known
end

local function relative_name(buf)
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
end

local function autosave_buffer(buf)
  if not is_autosavable(buf) then
    return
  end
  if conflicts_with_disk(buf) then
    local name = relative_name(buf)
    skipped_on_conflict[buf] = name
    vim.notify("autosave skipped, file changed on disk:\n" .. name, vim.log.levels.WARN, { title = "autosave" })
    return
  end
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("update")
  end)
end

function M.show_disk_diff(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local name = vim.api.nvim_buf_get_name(buf)
  local windows = vim.fn.win_findbuf(buf)
  if #windows > 0 then
    vim.api.nvim_set_current_win(windows[1])
  else
    vim.cmd("tab split")
    vim.api.nvim_set_current_buf(buf)
  end
  vim.cmd("diffthis")
  vim.cmd("vertical new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.cmd("read ++edit " .. vim.fn.fnameescape(name))
  vim.cmd("0delete _")
  pcall(vim.api.nvim_buf_set_name, 0, relative_name(buf) .. " [disk]")
  vim.bo.modified = false
  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.b[buf].disk_diff_shown = true
end

local function report_unresolved_conflicts()
  local unresolved = {}
  for buf, name in pairs(skipped_on_conflict) do
    if is_autosavable(buf) and conflicts_with_disk(buf) then
      table.insert(unresolved, { buf = buf, name = name })
    else
      if vim.api.nvim_buf_is_valid(buf) then
        vim.b[buf].disk_diff_shown = nil
      end
      skipped_on_conflict[buf] = nil
    end
  end
  if #unresolved == 0 then
    return
  end

  local names = vim.tbl_map(function(entry)
    return entry.name
  end, unresolved)
  vim.notify(
    "unsaved buffers conflicting with disk:\n" .. table.concat(names, "\n"),
    vim.log.levels.WARN,
    { title = "autosave" }
  )

  vim.schedule(function()
    if vim.fn.mode() ~= "n" then
      return
    end
    for _, entry in ipairs(unresolved) do
      if is_autosavable(entry.buf) and not vim.b[entry.buf].disk_diff_shown then
        M.show_disk_diff(entry.buf)
        return
      end
    end
  end)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("autosave_on_focus_lost", { clear = true })

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
    group = group,
    callback = track_disk_mtime,
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
      vim.iter(vim.api.nvim_list_bufs()):each(autosave_buffer)
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(args)
      autosave_buffer(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = report_unresolved_conflicts,
  })

  vim.api.nvim_create_user_command("AutosaveDiskDiff", function()
    M.show_disk_diff(vim.api.nvim_get_current_buf())
  end, { desc = "Diff the current buffer against the file on disk" })
end

return M
