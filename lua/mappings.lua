require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local term = require "nvchad.term"

--map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

map("", "H", "^")
map("", "L", "$")
-- make j and k move by visual line, not actual line, when text is soft-wrapped
map("n", "j", "gj")
map("n", "k", "gk")

-- "very magic" (less escaping needed) regexes by default
map("n", "?", "?\\v")
map("n", "/", "/\\v")
map("c", "%s/", "%sm/")

map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "*", "*zz", { silent = true })
map("n", "#", "#zz", { silent = true })
map("n", "g*", "g*zz", { silent = true })

map("n", "grq", function()
  vim.diagnostic.setqflist { open = false }
end, { desc = "Diagnostics -> Quickfix" })

-- 2) <leader>q = Quickfix öffnen (optional: <leader>Q schließen)
map("n", "<leader>q", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd "cclose"
      return
    end
  end
  vim.cmd "copen"
end, { desc = "Toggle Quickfix" })

-- 3) Ctrl-j / Ctrl-k = Quickfix Einträge vor/zurück
map("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next Quickfix" })
map("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Prev Quickfix" })

local del = vim.keymap.del

for _, mode in ipairs { "n", "t" } do
  pcall(del, mode, "<M-h>")
  pcall(del, mode, "<M-j>")
  pcall(del, mode, "<M-k>")
  pcall(del, mode, "<M-l>")

  -- manche Terminals melden Alt als <A-...>
  pcall(del, mode, "<A-h>")
  pcall(del, mode, "<A-j>")
  pcall(del, mode, "<A-k>")
  pcall(del, mode, "<A-l>")
end

require("mini.move").setup {
  mappings = {
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",

    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
  },
  options = { reindent_linewise = true },
}

vim.keymap.set({ "n", "t" }, "<M-i>", function()
  term.toggle { pos = "sp", id = "htoggleTerm" } -- horizontal
end, { desc = "Terminal toggle (horizontal)" })

-- OLd Neovim Config
map("n", "<C-d>", "x")
map("i", "<C-d>", "<Del>")

-- Golang Keybinding
vim.keymap.set("i", "<M-=>", ":=", { noremap = true, silent = true })

-- Telescope Funtkionen Finden
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols in file" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Find symbols in workspace" })
