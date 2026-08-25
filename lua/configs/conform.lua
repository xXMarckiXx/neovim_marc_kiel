local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    go = { "gofmt" },
    css = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    ["yaml.docker-compose"] = { "prettier" },
  },

  formant_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

return options
