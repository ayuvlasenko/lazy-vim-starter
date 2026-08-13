-- disable LazyVim's spell+wrap for markdown
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  command = "setlocal tabstop=4 shiftwidth=4",
})
local autosave = vim.api.nvim_create_augroup("autosave_on_focus_lost", { clear = true })
local skipped_on_conflict = {}

local function track_disk_mtime(args)
  if vim.api.nvim_buf_get_name(args.buf) ~= "" then
    vim.b[args.buf].disk_mtime_at_last_sync = vim.fn.getftime(vim.api.nvim_buf_get_name(args.buf))
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
    skipped_on_conflict[buf] = relative_name(buf)
    vim.notify(
      "autosave skipped, file changed on disk:\n" .. relative_name(buf),
      vim.log.levels.WARN,
      { title = "autosave" }
    )
    return
  end
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("update")
  end)
end

local function show_disk_diff(buf)
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

vim.api.nvim_create_user_command("AutosaveDiskDiff", function()
  show_disk_diff(vim.api.nvim_get_current_buf())
end, { desc = "Diff the current buffer against the file on disk" })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  group = autosave,
  callback = track_disk_mtime,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = autosave,
  callback = function()
    vim.iter(vim.api.nvim_list_bufs()):each(autosave_buffer)
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = autosave,
  callback = function(args)
    autosave_buffer(args.buf)
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = autosave,
  callback = function()
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
    vim.notify("unsaved buffers conflicting with disk:\n" .. table.concat(
      vim.tbl_map(function(entry)
        return entry.name
      end, unresolved),
      "\n"
    ), vim.log.levels.WARN, { title = "autosave" })
    vim.schedule(function()
      if vim.fn.mode() ~= "n" then
        return
      end
      for _, entry in ipairs(unresolved) do
        if is_autosavable(entry.buf) and not vim.b[entry.buf].disk_diff_shown then
          show_disk_diff(entry.buf)
          return
        end
      end
    end)
  end,
})

vim.treesitter.language.register("bash", "dotenv")
vim.filetype.add({
  -- extension = {
  --   foo = "fooscript",
  -- },
  -- filename = {
  --   ["Foofile"] = "fooscript",
  -- },
  -- pattern = {
  --   ["~/%.config/foo/.*"] = "fooscript",
  -- },
  filename = {
    -- [".env"] = "dotenv",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  -- pattern = {
  --   ["%.env%.[%w_.-]+"] = "dotenv",
  -- },
})
