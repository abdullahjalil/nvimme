-- Create React App command
vim.api.nvim_create_user_command('CreateReactApp', function(opts)
  local app_name = opts.args
  if app_name == "" then
    app_name = vim.fn.input("App name: ")
  end
  
  local cmd = string.format("!npx create-react-app %s", app_name)
  vim.cmd(cmd)
  
  -- Automatically open the new project
  vim.defer_fn(function()
    vim.cmd(string.format("cd %s", app_name))
    vim.cmd("edit src/App.js")
  end, 2000)
end, { nargs = '?' })

-- Create React component
vim.api.nvim_create_user_command('CreateComponent', function(opts)
  local component_name = opts.args
  if component_name == "" then
    component_name = vim.fn.input("Component name: ")
  end
  
  local template = string.format([[
import React from 'react';

const %s = () => {
  return (
    <div>
      <h1>%s Component</h1>
    </div>
  );
};

export default %s;
]], component_name, component_name, component_name)
  
  local filename = string.format("src/components/%s.jsx", component_name)
  vim.fn.mkdir("src/components", "p")
  vim.fn.writefile(vim.split(template, "\n"), filename)
  vim.cmd("edit " .. filename)
end, { nargs = '?' })
