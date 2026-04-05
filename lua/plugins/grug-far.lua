return {
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      windowCreationCommand = "tab split",
    },
    init = function()
      -- Workaround: which-key reads buffer mappings before grug-far registers them,
      -- so localleader menu doesn't appear until leader is pressed first.
      -- See https://github.com/folke/which-key.nvim/issues/1029
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "grug-far",
        callback = function(ev)
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({ buffer = ev.buf })
            end
          end, 0)
        end,
      })
    end,
  },
}
