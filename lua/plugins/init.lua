return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- lädt vor dem Speichern (Format-on-save)
    opts = require "configs.conform",
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true

      require("catppuccin").setup {
        flavour = "latte", -- latte, frappe, macchiato, mocha
      }

      vim.cmd.colorscheme "catppuccin-latte"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvimtools/none-ls.nvim", -- statt null-ls
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" }, -- lädt nur bei Rust-Dateien
    config = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ["rust-analyzer"] = {
              -- nur an/aus:
              checkOnSave = true,

              -- welches cargo-Kommando: "check" ist Default,
              -- hier explizit gesetzt:
              check = {
                -- check | clippy
                command = "check",
              },
            },
          },
        },
      }
    end,
  },

  {
    "echasnovski/mini.nvim",
    version = false, -- immer latest (empfohlen)
    lazy = false,
    config = function()
      -- essentials
      require("mini.pairs").setup {
        mappings = {
          -- ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
          -- ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
          -- ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
          --
          -- [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
          -- ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
          -- ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
          --
          -- ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
          -- ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
          -- ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },

          [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
        },
      }
      require("mini.surround").setup()
      require("mini.ai").setup()
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
        options = {
          reindent_linewise = true,
        },
      }
      require("mini.surround").setup {
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
    end,
  },
  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        crates = {
          enabled = true, -- crates.io Suche
          min_chars = 3,
          max_results = 10,
        },
      },
    },
  },
  {
    "ziglang/zig.vim",
    ft = "zig",
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- egal welches preset du nutzt, wir überschreiben Tab gezielt:
      opts.keymap["<Tab>"] = { "snippet_forward", "select_next", "fallback" }
      opts.keymap["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" }
    end,
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  --   opts = function(_, opts)
  --     -- Parser-Liste erweitern (nicht ersetzen)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --     vim.list_extend(opts.ensure_installed, {
  --       "vim",
  --       "lua",
  --       "vimdoc",
  --       "html",
  --       "css",
  --       "c",
  --       "markdown",
  --       "markdown_inline",
  --       "query",
  --       "rust",
  --       "toml",
  --       "zig",
  --     })
}
