-- Auto-install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  -- 🌈 Colorscheme: Catppuccin Frappe
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme catppuccin-frappe")
    end,
  },
  -- 🗂 File tree with no line numbers
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          vim.api.nvim_buf_set_option(bufnr, "number", false)
          vim.api.nvim_buf_set_option(bufnr, "relativenumber", false)
        end,
      })
    end,
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "python", "javascript", "typescript", "java", "c_sharp", "go",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
  -- 🔍 Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },
    -- For automatic file templates
{
  'glepnir/template.nvim',
  config = function()
    require('template').setup({
      temp_dir = "~/.config/nvim/templates",
      author = "Your Name",
      email = "your.email@example.com",
    })
  end
},
  -- 📊 Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  },
  -- ⚙️ LSP and Mason
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  -- 🌐 TypeScript
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- ☕ Java
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },
  -- 🐛 Debugging Support for C#
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio", -- Required for nvim-dap-ui
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Setup DAP UI
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- .NET Core debugging setup
      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg', -- Make sure netcoredbg is in your PATH
        args = {'--interpreter=vscode'}
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
        },
      }

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Debug keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = "Continue" })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Step Over" })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Step Into" })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Step Out" })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = "Conditional Breakpoint" })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Toggle Debug UI" })
    end,
  },
  -- 🧠 Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },
})
