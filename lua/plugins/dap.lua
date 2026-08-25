-- Debugging (DAP = Debug Adapter Protocol)
--
-- Adapter kommen aus Mason. NvChad setzt mason auf PATH = "skip", d.h. die
-- Binaries liegen NICHT im $PATH -> hier immer absolute Pfade benutzen.
--   :MasonInstall codelldb debugpy
local mason_pkg = vim.fn.stdpath "data" .. "/mason/packages/"

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup()
      require("nvim-dap-virtual-text").setup {
        -- Werte inline hinter der Zeile statt am Zeilenende des Blocks
        virt_text_pos = "eol",
      }

      -- UI automatisch auf/zu
      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end

      -- Zeichen in der Signcolumn
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      sign("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      sign("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
      sign("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

      ----------------------------------------------------------------------
      -- codelldb: C, C++ und (via rustaceanvim) Rust
      ----------------------------------------------------------------------
      dap.adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = mason_pkg .. "codelldb/extension/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Executable suchen: erst ./build (CMake), sonst manuell eintippen.
      local function pick_executable()
        local build = vim.fn.getcwd() .. "/build"
        local start = vim.fn.isdirectory(build) == 1 and build .. "/" or vim.fn.getcwd() .. "/"
        return vim.fn.input("Pfad zur Executable: ", start, "file")
      end

      dap.configurations.cpp = {
        {
          name = "Launch (codelldb)",
          type = "codelldb",
          request = "launch",
          program = pick_executable,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local input = vim.fn.input "Programm-Argumente: "
            return vim.split(input, " ", { trimempty = true })
          end,
          -- stdin/stdout des Debuggees in ein eigenes Terminal
          console = "integratedTerminal",
        },
        {
          name = "Attach an laufenden Prozess",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Rust-Configs erzeugt rustaceanvim selbst (:RustLsp debuggables),
      -- deshalb hier bewusst kein dap.configurations.rust.
    end,
  },

  ----------------------------------------------------------------------
  -- Python
  ----------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Mason legt debugpy in ein eigenes venv; dieser Interpreter startet den
      -- Adapter. Das Programm selbst laeuft trotzdem mit dem venv des Projekts,
      -- solange eines aktiv ist (nvim-dap-python erkennt $VIRTUAL_ENV).
      require("dap-python").setup(mason_pkg .. "debugpy/venv/bin/python")
    end,
  },
}
