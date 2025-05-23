-- Your existing configurations...
require("config.options")
require("config.lazy")
require("config.colors")
require("config.lsp")
require("config.nvim-tree")
require("config.statusline")
require("config.telescope")
require("config.react")
-- Add C# configuration
require("config.csharp").setup()
