return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview: changed files" },
    { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
    { "<leader>gw", ":DiffviewOpen ", desc = "Diffview: vs branch/rev" },
    -- Prefill `:DiffviewOpen <branch>...HEAD --imply-local`, cursor parked before
    -- `...HEAD` so you just type the branch (native rev completion still works).
    {
      "<leader>gm",
      ":DiffviewOpen ...HEAD --imply-local" .. ("<Left>"):rep(#"...HEAD --imply-local"),
      desc = "Diffview: <branch>...HEAD (merge-base)",
    },
  },
  opts = {
    keymaps = {
      view = { q = "<cmd>DiffviewClose<cr>" },
      file_panel = { q = "<cmd>DiffviewClose<cr>" },
      file_history_panel = { q = "<cmd>DiffviewClose<cr>" },
    },
    -- view = {
    --   default = { layout = "diff2_vertical" },
    --   file_history = { layout = "diff2_vertical" },
    -- },
    file_panel = {
      win_config = {
        width = 40,
      },
    },
  },
}
