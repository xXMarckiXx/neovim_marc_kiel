local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    zig = { "zigfmt" },
    go = { "gofmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = function(bufnr)
    -- ipynb.nvim: Edit-Float-Buffer und Facade-Buffer NICHT formatieren.
    -- Das Formatieren über BufWritePre ändert den Edit-Buffer, ohne den
    -- Facade-Buffer zu synchronisieren -> Speichern verwirft die Änderungen.
    if vim.b[bufnr].ipynb_is_edit_buffer or vim.bo[bufnr].filetype == "ipynb" then
      return nil
    end
    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
}

return options
