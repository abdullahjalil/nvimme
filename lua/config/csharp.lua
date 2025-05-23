-- lua/config/csharp.lua
-- Optional: Additional C# specific configurations

local M = {}

function M.setup()
  -- C# specific file type settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.smartindent = true
      -- Add any other C# specific settings here
    end,
  })

  -- Additional C# commands (these are already in your lsp.lua, so this is optional)
  vim.api.nvim_create_user_command('DotnetNew', function(opts)
    local template = opts.args or 'console'
    vim.cmd('!dotnet new ' .. template)
  end, { nargs = '?', desc = 'Create new dotnet project' })

  vim.api.nvim_create_user_command('DotnetRestore', function()
    vim.cmd('!dotnet restore')
  end, { desc = 'Restore dotnet packages' })

  vim.api.nvim_create_user_command('DotnetAdd', function(opts)
    vim.cmd('!dotnet add package ' .. (opts.args or ''))
  end, { nargs = '?', desc = 'Add dotnet package' })
end

return M
