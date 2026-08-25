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

-- Ctrl+j and Ctrl+k as Esc
map("n", "<C-j>", "<Esc>")
map("i", "<C-j>", "<Esc>")
map("v", "<C-j>", "<Esc>")
map("s", "<C-j>", "<Esc>")
map("x", "<C-j>", "<Esc>")
map("c", "<C-j>", "<Esc>")
map("o", "<C-j>", "<Esc>")
map("l", "<C-j>", "<Esc>")
map("t", "<C-j>", "<Esc>")

-- no arrow keys --- force yourself to use the home row
map("n", "<up>", "<nop>")
map("n", "<down>", "<nop>")
map("i", "<up>", "<nop>")
map("i", "<down>", "<nop>")
map("i", "<left>", "<nop>")
map("i", "<right>", "<nop>")
-- let the left and right arrows be useful: they can switch buffers
map("n", "<left>", ":bp<cr>")
map("n", "<right>", ":bn<cr>")

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

-- <leader>q = Quickfix öffnen (optional: <leader>Q schließen)
map("n", "<leader>q", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd "cclose"
      return
    end
  end
  vim.cmd "copen"
end, { desc = "Toggle Quickfix" })

-- Ctrl-j / Ctrl-k = Quickfix Einträge vor/zurück
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

-- öffnen eines Terminals Horizontal
vim.keymap.set({ "n", "t" }, "<M-i>", function()
  term.toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Terminal toggle (horizontal)" })

-- OLd Neovim Config
map("n", "<C-d>", "x")
map("i", "<C-d>", "<Del>")

-- Golang Keybinding
vim.keymap.set("i", "<M-=>", ":=", { noremap = true, silent = true })

-- Telescope Funtkionen Finden
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols in file" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Find symbols in workspace" })

-- ============================================================
-- Debugging (nvim-dap)
-- Alles unter <leader>d..., dazu die ueblichen F-Tasten im Lauf.
-- Die require's stehen absichtlich in den Callbacks: so laedt lazy.nvim
-- nvim-dap erst beim ersten Tastendruck.
-- ============================================================
local function dap()
  return require "dap"
end

map("n", "<leader>db", function()
  dap().toggle_breakpoint()
end, { desc = "DAP Breakpoint an/aus" })

map("n", "<leader>dB", function()
  vim.ui.input({ prompt = "Bedingung: " }, function(cond)
    if cond and cond ~= "" then
      dap().set_breakpoint(cond)
    end
  end)
end, { desc = "DAP Breakpoint mit Bedingung" })

map("n", "<leader>dc", function()
  dap().continue()
end, { desc = "DAP Start / Weiter" })
map("n", "<F5>", function()
  dap().continue()
end, { desc = "DAP Start / Weiter" })

map("n", "<leader>dn", function()
  dap().step_over()
end, { desc = "DAP Step over" })
map("n", "<F10>", function()
  dap().step_over()
end, { desc = "DAP Step over" })

map("n", "<leader>di", function()
  dap().step_into()
end, { desc = "DAP Step into" })
map("n", "<F11>", function()
  dap().step_into()
end, { desc = "DAP Step into" })

map("n", "<leader>do", function()
  dap().step_out()
end, { desc = "DAP Step out" })
map("n", "<F12>", function()
  dap().step_out()
end, { desc = "DAP Step out" })

map("n", "<leader>dx", function()
  dap().terminate()
  require("dapui").close()
end, { desc = "DAP beenden" })

map("n", "<leader>dl", function()
  dap().run_last()
end, { desc = "DAP letzte Session erneut" })

map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "DAP UI an/aus" })

map({ "n", "v" }, "<leader>de", function()
  require("dapui").eval(nil, { enter = true })
end, { desc = "DAP Ausdruck auswerten" })

map("n", "<leader>dt", function()
  require("dap").repl.toggle()
end, { desc = "DAP REPL an/aus" })
