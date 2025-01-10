local M = {}

local function validate_github_link(text)
  if text:find("/") and not text:find("%s") then
    return true
  end
  return false
end

M.open_url_in_browser = function(text, og_text)
  print("Visiting our friends at: " .. og_text)
  os.execute(string.format("open %q", text)) -- macOS: 'open', Linux: 'xdg-open', Windows: 'start'
end

M.go_to_github_link = function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local start_quote = line:sub(1, col):match(".*['\"']()")
  local end_quote = line:find("['\"]", col + 1)

  if start_quote and end_quote then
    local text = line:sub(start_quote, end_quote - 1)

    if validate_github_link(text) then
      local fin_text = "https://github.com/" .. text
      M.open_url_in_browser(fin_text, text)
      return fin_text
    end

    print("Not A github link")
    return nil
  end
end

M.setup = function()
  vim.keymap.set("n", "<Leader>tt", M.right_terminal, { desc = "right Terminal" })
  vim.keymap.set("n", "<Leader>gh", M.go_to_github_link, { desc = "Go Git[H]ub link" })
  vim.keymap.set("n", "<Leader>xs", function()
    vim.print("Sauce")
    vim.cmd("source %")
  end, { desc = "Sauce it" })

  -- User Commands
  vim.api.nvim_create_user_command("TermOpen", function()
    vim.cmd("split | terminal")
  end, {})

  -- Autocommands
  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.wo.number = false -- Disable line numbers in terminal
      vim.wo.relativenumber = false
      vim.cmd("startinsert") -- Start in insert mode
    end,
  })
end

M.say_hello = function()
  vim.print("Hello from destinio.nvim")
end

M.rtps = function()
  vim.print(vim.inspect(vim.api.nvim_list_runtime_paths()))
end

M.nightly = function()
  vim.print("nightly")
end

-- Terminal Stuff
function M.right_terminal(opts)
  opts = opts or {}

  local width = math.floor(vim.o.columns * (opts.width or 0.4))

  vim.cmd(width .. "vsplit | terminal")
end

return M
