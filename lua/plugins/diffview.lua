return {
  {
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
    opts = function()
      local cfg = require("diffview.config")

      -- Conflict keys default to <leader>c*, which collides with LazyVim's LSP
      -- code-action group on the same buffers. Rehome them under <leader>gc by
      -- disabling each default and re-adding it with a <leader>gc prefix.
      local function rehome_conflict_keys(group)
        local maps = { q = "<cmd>DiffviewClose<cr>" }
        for _, m in ipairs(cfg.defaults.keymaps[group]) do
          local lhs = m[2]
          if type(lhs) == "string" and lhs:find("^<leader>c") then
            maps[#maps + 1] = { m[1], lhs, false }
            maps[#maps + 1] = { m[1], lhs:gsub("^<leader>c", "<leader>gc"), m[3], m[4] }
          end
        end
        return maps
      end

      return {
        keymaps = {
          view = rehome_conflict_keys("view"),
          file_panel = rehome_conflict_keys("file_panel"),
          file_history_panel = { q = "<cmd>DiffviewClose<cr>" },
        },
        file_panel = {
          win_config = {
            width = 40,
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>gc", group = "conflict", mode = "n" })
    end,
  },
}
