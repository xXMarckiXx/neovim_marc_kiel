return {
  {
    "stevearc/conform.nvim",
    -- lädt vor dem Speichern (Format-on-save)
    event = { "BufWritePre" },
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
    "mrcjkb/rustaceanvim",
    -- v9 setzt Neovim 0.12 voraus; v8 ist der neueste Major fuer 0.11
    version = "^8",
    ft = { "rust" }, -- lädt nur bei Rust-Dateien
    dependencies = { "mfussenegger/nvim-dap" },
    init = function()
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
        -- dap.adapter bleibt Default: rustaceanvim findet codelldb selbst
        -- ueber die mason-registry (mason PATH ist bei NvChad auf "skip").
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(ev)
          local m = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          m("<leader>dr", function()
            vim.cmd.RustLsp "debuggables"
          end, "Rust: Debuggables auswählen")
          m("<leader>dR", function()
            vim.cmd.RustLsp { "debuggables", bang = true }
          end, "Rust: letztes Debuggable erneut")
          m("<leader>rr", function()
            vim.cmd.RustLsp "runnables"
          end, "Rust: Runnables")
          m("<leader>re", function()
            vim.cmd.RustLsp "explainError"
          end, "Rust: Fehler erklären")
          m("<leader>rc", function()
            vim.cmd.RustLsp "openCargo"
          end, "Rust: Cargo.toml öffnen")
        end,
      })
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

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {
        map = "<C-y>",
        use_virt_lines = false,
        highlight = "IncSearch",
      },
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
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
          -- crates.io Suche
          enabled = true,
          min_chars = 3,
          max_results = 10,
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- Reihenfolge ist wichtig:
      --   1. Menü offen        -> durch die Vorschläge blättern
      --   2. Cursor im Snippet -> zum nächsten/vorherigen Argument springen
      --   3. sonst             -> ganz normales Tab
      opts.keymap["<Tab>"] = { "select_next", "snippet_forward", "fallback_to_mappings" }
      opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback_to_mappings" }

      -- Vorschlag übernehmen (expandiert bei Funktionen die Argument-Platzhalter)
      opts.keymap["<CR>"] = { "accept", "fallback" }

      -- NvChad startet LuaSnip mit history = true. blink fragt für snippet_forward
      -- sonst ls.jumpable() ab, und das bleibt dadurch auch nach dem Verlassen eines
      -- Snippets dauerhaft true -> jedes Tab wird abgefangen, select_next kommt nie dran.
      -- locally_jumpable prüft stattdessen, ob der Cursor wirklich noch im Snippet steht.
      opts.snippets = opts.snippets or {}
      opts.snippets.active = function(filter)
        local direction = filter and filter.direction or 1
        return require("luasnip").locally_jumpable(direction)
      end
      opts.snippets.jump = function(direction)
        local ls = require "luasnip"
        return ls.locally_jumpable(direction) and ls.jump(direction)
      end

      opts.completion = opts.completion or {}
      opts.completion.accept = opts.completion.accept or {}
      opts.completion.accept.auto_brackets = opts.completion.accept.auto_brackets or {}
      opts.completion.accept.auto_brackets.enabled = true
      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    main = "nvim-treesitter.configs", -- sonst ruft lazy require("nvim-treesitter").setup() auf
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, opts)
      opts.highlight = { enable = true }
      opts.indent = { enable = true }

      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "c",
        "cpp",
        "cmake",
        "css",
        "diff",
        "go",
        "html",
        "json",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "yaml",
        "zig",
      })
    end,
  },

  -- Smear Cursor
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    cond = vim.g.neovide == nil,
    opts = {
      hide_target_hack = true,
      cursor_color = "none",
    },
    specs = {
      -- disable mini.animate cursor
      {
        "nvim-mini/mini.animate",
        optional = true,
        opts = {
          cursor = { enable = false },
        },
      },
    },
  },
  { "b0o/schemastore.nvim" },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP-Server
        "bash-language-server",
        "clangd",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "emmet-language-server",
        "gopls",
        "hyprls",
        "json-lsp",
        "lua-language-server",
        "neocmakelsp",
        "postgrestools", -- nur Postgres; für gemischte DBs stattdessen "sqls"
        -- "sqls",
        "pyright",
        "ruff",
        "rust-analyzer",
        "taplo",
        "typescript-language-server",

        -- Formatter
        "black",
        "clang-format",
        "prettier",
        "shfmt",
        "stylua",

        -- Linter
        "hadolint",
        "shellcheck",

        -- Debug-Adapter (nvim-dap)
        "codelldb",
        "debugpy",
      },
    },
  },
}
