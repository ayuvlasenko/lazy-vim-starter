return {
  "snacks.nvim",
  keys = {
    { "<leader>fy", function() Snacks.terminal("yazi", { cwd = LazyVim.root() }) end, desc = "Yazi (Root Dir)" },
    { "<leader>fY", function() Snacks.terminal("yazi", { cwd = vim.uv.cwd() }) end, desc = "Yazi (cwd)" },
  },
  opts = {
    styles = {
      zen = {
        backdrop = { transparent = false, blend = 75 },
      },
    },
    scroll = { enabled = false },
    zen = {
      toggles = {
        dim = false,
      },
      show = {
        statusline = true,
        tabline = true,
      },
    },
    picker = {
      sources = {
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
        explorer = {
          hidden = true,
          ignored = true,
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
                ["gy"] = { "yank_relative_cwd", mode = "n" },
                ["gY"] = { "yank_absolute", mode = "n" },
              },
            },
          },
        },
      },
    },
  },
}
