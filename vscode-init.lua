if not vim.g.vscode then
  return
end

local vscode = require "vscode"
local map = vim.keymap.set
vim.g.mapleader = " "

-- Speichern (:w wird von VSCode als Save behandelt)
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Zeilenanfang / -ende
map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "$")

-- visuelle Zeilen bei Soft-Wrap
map("n", "j", "gj")
map("n", "k", "gk")

-- very magic Suche
map("n", "/", "/\\v")
map("n", "?", "?\\v")
map("c", "%s/", "%sm/")

-- Suche zentriert
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "*", "*zz", { silent = true })
map("n", "#", "#zz", { silent = true })
map("n", "g*", "g*zz", { silent = true })

-- Ctrl-d = Zeichen löschen (Normal). Insert-Variante -> keybindings.json
map("n", "<C-d>", "x")

-- Diagnostics/Quickfix gibt es in VSCode nicht (LSP läuft in VSCode, nicht in Neovim)
-- -> auf das "Problems"-Panel umgebogen:
map("n", "grq", function()
  vscode.action "workbench.actions.view.problems"
end, { desc = "Diagnostics -> Problems" })
map("n", "<leader>q", function()
  vscode.action "workbench.actions.view.problems"
end, { desc = "Problems" })
map("n", "<C-j>", function()
  vscode.action "editor.action.marker.nextInFiles"
end, { desc = "Next Problem" })
map("n", "<C-k>", function()
  vscode.action "editor.action.marker.prevInFiles"
end, { desc = "Prev Problem" })
