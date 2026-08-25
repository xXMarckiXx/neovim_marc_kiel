require("nvchad.configs.lspconfig").defaults()

-- Python: Arbeitsteilung
--   pyright -> Typen, Completion, Hover, Go-to-Definition
--   ruff    -> Linting (pyflakes/pycodestyle/isort/... in einem Binary)
vim.lsp.config("pyright", {
  settings = {
    pyright = {
      -- Imports sortiert ruff
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        -- openFilesOnly, workspace
        diagnosticMode = "workspace",
        -- off, basic, strict
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("ruff", {
  init_options = {
    settings = {
      -- Projektweite pyproject.toml / ruff.toml gewinnt immer ueber diese Defaults.
      lineLength = 88,
      lint = {
        select = {
          "E", -- pycodestyle Fehler
          "F", -- pyflakes (ungenutzte Imports/Variablen, echte Bugs)
          "I", -- isort (Import-Reihenfolge)
          "UP", -- pyupgrade (veraltete Syntax)
          "B", -- flake8-bugbear (haeufige Fallstricke)
        },
      },
    },
  },
})

-- ruff kann kein Hover; sonst gewinnt es gegen pyright und man sieht nichts.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--compile-commands-dir=build",
    "--query-driver=/usr/bin/g++",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },

      -- wenn du StyLua nutzt, lass LSP-format aus:
      format = { enable = false },
    },
  },
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
})

-- Dockerfile LSP
vim.lsp.config("dockerls", {
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    },
  },
})

-- docker-compose LSP
vim.lsp.config("docker_compose_language_service", {})

local servers =
  { "html", "cssls", "pyright", "ruff", "clangd", "lua_ls", "gopls", "dockerls", "docker_compose_language_service" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
