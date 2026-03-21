return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      -- prevent loading .vscode/launch.json (TypeScript extra sets these mappings)
      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = {}
      vscode.type_to_filetypes["pwa-node"] = {}

      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to 9228",
            port = 9228,
            restart = true,
            skipFiles = { "<node_internals>/**" },
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to 9229",
            port = 9229,
            restart = true,
            skipFiles = { "<node_internals>/**" },
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      expand_lines = false,
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "right",
          size = 50,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    keys = {
      { "<leader>dT", function() require("dapui").toggle({ layout = 2 }) end, desc = "Toggle DAP Tray" },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ layout = 1 })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
