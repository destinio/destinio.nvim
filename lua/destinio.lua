local M = {}

M.setup = function() end

M.say_hello = function()
  vim.print("Hello from destinio.nvim")
end

M.rtps = function()
  vim.print(vim.inspect(vim.api.nvim_list_runtime_paths()))
end

return M
