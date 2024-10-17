-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
map("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Remove Highlight" })
map("v", "?", ":s/\\v", { desc = "Replace", remap = true })
map("n", "?", ":%s/\\v", { desc = "Replace", remap = true })
map("n", "<leader>r", ":so % <CR>:echo 'File Sourced!'<CR>", { desc = "Source File", silent = false })
