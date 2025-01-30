-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
    vim.keymap.set("n", "<leader>md", function()
      require("auto-pandoc").run_pandoc()
    end, { silent = true, buffer = 0 })
  end,
  group = vim.api.nvim_create_augroup("setAutoPandocKeymap", {}),
  desc = "Set keymap for auto-pandoc",
})
