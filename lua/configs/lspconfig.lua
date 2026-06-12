require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("pyright", {
  settings = {
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

vim.lsp.config("hyprlang", {
  cmd = { "hyprls" },
  filetypes = { "hyprlang" },
  settings = {
    hyprls = {
      preferIgnoreFile = false,
    },
  },
})

vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig" },
  root_markers = { "build.zig", ".git" },
  single_file_support = true,
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
})

local servers = { "html", "cssls", "pyright", "clangd", "lua_ls", "hyprlang", "zls", "gopls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
