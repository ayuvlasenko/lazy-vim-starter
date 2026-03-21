return {
  "snacks.nvim",
  opts = {
    scroll = { enabled = false },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          layout = {
            auto_hide = { "input" },
          },
          actions = {
            yank_relative_cwd = function(_, item)
              local path = vim.fn.fnamemodify(item.file, ":.")
              vim.fn.setreg("+", path)
              vim.fn.setreg('"', path)
              vim.notify("Yanked: " .. path)
            end,
            yank_absolute = function(_, item)
              local path = item.file
              vim.fn.setreg("+", path)
              vim.fn.setreg('"', path)
              vim.notify("Yanked: " .. path)
            end,
          },
          win = {
            input = {
              keys = {
                ["<Esc>"] = { "focus_list", mode = "n" },
              },
            },
            list = {
              keys = {
                ["<Esc>"] = { "", mode = "n" },
                ["y"] = { "yank_relative_cwd", mode = "n" },
                ["Y"] = { "yank_absolute", mode = "n" },
              },
            },
          },
        },
      },
    },
  },
}
