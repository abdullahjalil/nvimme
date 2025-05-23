-- LSP configuration using mason, lspconfig, typescript-tools, jdtls, and omnisharp

-- Setup Mason
require("mason").setup()

-- Setup Mason LSP config with ensure_installed
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "gopls",
    "omnisharp",
  },
})

-- Required for autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Common on_attach function
local on_attach = function(_, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true, noremap = true }

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "[d", vim.diagnostic.goto_prev, opts)
  map("n", "]d", vim.diagnostic.goto_next, opts)
  map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end

-- Set up lspconfig manually
local lspconfig = require("lspconfig")

-- List of basic servers to configure
local servers = { "lua_ls", "gopls" }  -- Removed pyright since it's configured separately below

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- TypeScript via typescript-tools
require("typescript-tools").setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayFunctionLikeReturnTypeHints = true,
    },
  },
})

-- OmniSharp LSP setup for C#
lspconfig.omnisharp.setup({
  capabilities = capabilities,
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  enable_editorconfig_support = true,
  enable_ms_build_load_projects_on_demand = false,
  enable_roslyn_analyzers = false,
  organize_imports_on_format = false,
  enable_import_completion = false,
  sdk_include_prereleases = true,
  analyze_open_documents_only = false,
  on_attach = on_attach,  -- Use the common on_attach function
})

-- Python setup for virtualenv support
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      venvPath = vim.fn.expand("~/.virtualenvs"),
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
})

-- Java via nvim-jdtls
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local jdtls = require("jdtls")
    local home = os.getenv("HOME")
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = home .. "/.local/share/jdtls/workspace/" .. project_name

    jdtls.start_or_attach({
      cmd = { "jdtls" },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "build.gradle" }),
      workspace_dir = workspace_dir,
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- Python virtual environment detection
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.py",
  callback = function()
    local venv = vim.fn.findfile("pyvenv.cfg", ".;")
    if venv ~= "" then
      local venv_dir = vim.fn.fnamemodify(venv, ":h")
      vim.env.VIRTUAL_ENV = venv_dir
      vim.env.PATH = venv_dir .. "/bin:" .. vim.env.PATH
    end
  end,
})

-- Global keymaps (not LSP-specific)
local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "

-- C# project commands (global, not buffer-specific)
map('n', '<leader>cb', ':!dotnet build<CR>', { desc = "Build project", silent = true })
map('n', '<leader>cr', ':!dotnet run<CR>', { desc = "Run project", silent = true })
map('n', '<leader>ct', ':!dotnet test<CR>', { desc = "Run tests", silent = true })
map('n', '<leader>cc', ':!dotnet clean<CR>', { desc = "Clean project", silent = true })

-- Terminal
map('n', '<leader>tt', ':terminal<CR>', { desc = "Open terminal", silent = true })
map('t', '<Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode", silent = true })

-- File operations
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer", silent = true })
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find files", silent = true })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live grep", silent = true })
