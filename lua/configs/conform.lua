local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    go = { "gofmt" },
    css = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    toml = { "taplo" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    ["yaml.docker-compose"] = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_format = "never",
  },
}

return options
