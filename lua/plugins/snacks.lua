local function yank_path(path)
  vim.fn.setreg("+", path)
  vim.fn.setreg('"', path)
  vim.notify("Yanked: " .. path)
end

return {
  "snacks.nvim",
  keys = {
    {
      "<leader>fy",
      function()
        Snacks.terminal("yazi", { cwd = LazyVim.root() })
      end,
      desc = "Yazi (Root Dir)",
    },
    {
      "<leader>fY",
      function()
        Snacks.terminal("yazi", { cwd = vim.uv.cwd() })
      end,
      desc = "Yazi (cwd)",
    },
    {
      "<leader>gx",
      function()
        require("util.picker").deleted_files()
      end,
      desc = "Deleted files (git)",
    },
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
              yank_path(vim.fn.fnamemodify(item.file, ":."))
            end,
            yank_absolute = function(_, item)
              yank_path(item.file)
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
