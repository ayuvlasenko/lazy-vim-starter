return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")

    opts.defaults.file_ignore_patterns = { ".git" }
    opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings, {
      i = vim.tbl_deep_extend("force", opts.defaults.mappings.i, {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }),
    })
  end,
}
