if not vim.g.vscode then
  return
end

local vscode = require "vscode"
local map = vim.keymap.set
vim.g.mapleader = " "

-- Yank/Delete/Paste nutzen das System-Clipboard (+) -> wl-copy/wl-paste
vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = { "wl-copy" },
    ["*"] = { "wl-copy", "--primary" },
  },
  paste = {
    ["+"] = { "wl-paste", "--no-newline" },
    ["*"] = { "wl-paste", "--no-newline", "--primary" },
  },
  cache_enabled = 0,
}

-- mini.surround auch in VSCode: Klammern/Quotes setzen, ersetzen, löschen
-- (sa = add im Visual-/Normal-Mode, sr = replace, sd = delete ...)
-- mini.nvim ist über lazy installiert -> Pfad in den runtimepath aufnehmen.
vim.opt.rtp:append(vim.fn.stdpath "data" .. "/lazy/mini.nvim")
local ok_surround, surround = pcall(require, "mini.surround")
if ok_surround then
  surround.setup {
    mappings = {
      add = "sa",
      delete = "sd",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      replace = "sr",
      update_n_lines = "sn",
    },
  }
end

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

vim.notify "vscode-init.lua wurde geladen!"
