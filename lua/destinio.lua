local M = {}

M.rtps = function()
  vim.print(vim.inspect(vim.api.nvim_list_runtime_paths()))
end

-- Terminal Stuff
function M.right_terminal(opts)
  opts = opts or {}

  local width = math.floor(vim.o.columns * (opts.width or 0.4))

  vim.cmd(width .. "vsplit | terminal")
end

local function validate_github_link(text)
  if text:find("/") and not text:find("%s") then
    return true
  end
  return false
end

M.open_url_in_browser = function(url)
  os.execute(string.format("open %q", url)) -- TODO: support other macOS: 'open', Linux: 'xdg-open', Windows: 'start'
  -- TODO: open in lynx
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
      M.open_url_in_browser(fin_text)
      return fin_text
    end

    print("Not A github link")
    return nil
  end
end

M.setup = function()
  -- Keymaps =====================

  -- Terminal
  vim.keymap.set("n", "<Leader>tt", M.right_terminal, { desc = "right Terminal" })

  -- browser stuff
  vim.keymap.set("n", "<Leader>gh", M.go_to_github_link, { desc = "Go Git[H]ub link" })

  vim.keymap.set("n", "<Leader>gs", function()
    M.open_url_in_browser("https://www.google.com/webhp")
  end, { desc = "Go [S]earch Google" })
  vim.keymap.set("n", "<Leader>gc", function()
    M.open_url_in_browser("https://chatgpt.com/")
  end, { desc = "Go [C]hat GPT" })

  -- Sauce
  vim.keymap.set("n", "<Leader>sx", function()
    vim.print("Sauce: File")
    vim.cmd("source %")
  end, { desc = "Sauce: file" })

  -- end keymaps ==============================

  -- User Commands =========================
  vim.api.nvim_create_user_command("TermOpen", function()
    vim.cmd("split | terminal")
  end, {})

  -- Autocommands ========================
  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.wo.number = false -- Disable line numbers in terminal
      vim.wo.relativenumber = false
      vim.cmd("startinsert") -- Start in insert mode
    end,
  })
end

return M
