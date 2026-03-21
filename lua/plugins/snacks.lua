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
          win = {
            input = {
              keys = {
                ["<Esc>"] = { "focus_list", mode = "n" },
              },
            },
            list = {
              keys = {
                ["<Esc>"] = { "", mode = "n" },
              },
            },
          },
        },
      },
    },
  },
}
