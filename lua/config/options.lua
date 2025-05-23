vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = true -- Relative to cursor line

-- Add these C# friendly defaults
vim.opt.tabstop = 4        -- Default tab width for C#
vim.opt.shiftwidth = 4     -- Default indent width
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart indentation

-- Useful for C# development
vim.opt.ignorecase = true  -- Ignore case in search
vim.opt.smartcase = true   -- But be smart about it
vim.opt.wildmode = "longest:full,full" -- Better command completion

-- Show matching brackets
vim.opt.showmatch = true
