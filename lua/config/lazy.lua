local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- change some telescope options and a keymap to browse plugin files
    {
      "nvim-telescope/telescope.nvim",
      keys = {
        -- add a keymap to browse plugin files
        -- stylua: ignore
        {
          "<leader>fp",
          function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
          desc = "Find Plugin File",
        },
      },
      -- change some options
      opts = {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,
        },
      },
    },
    -- {
    --   "telescope.nvim",
    --   dependencies = {
    --     'nvim-telescope/telescope-file-browser.nvim', -- NetRW replacement,
    --     build = "make",
    --     config = function()
    --       require("telescope").load_extension("file_browser")
    --       vim.opts.set('n', '<leader>e',
    --         '<cmd>lua require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", cwd = telescope_buffer_dir(), respect_git_ignore = false, hide_parent_dir = true, git_status = false,  hidden = true, grouped = true, previewer = false, initial_mode = "normal", layout_config = { height = 40 }})<CR>',
    --         { noremap = true, silent = true, desc = "File Browser" })
    --     end,
    --   }
    -- },
    -- add telescope-fzf-native
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },
    {
      "telescope.nvim",
      dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    {
      "bufferline.nvim",
      dependencies = {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = function()
          return {
            { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
            { "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
            { "<leader>bb", "<cmd>BufferLinePick<CR>", desc = "Pick" },
            { "<leader>bw", "<cmd>BufferLinePickClose<CR>", desc = "Pick Close" },
          }
        end,
      },
    },
    {
      "nvimdev/dashboard-nvim",
      lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
      opts = function()
        local logo = [[
███████  ██████  ██████   ██████  ███████    ██    ██ ██ ███    ███ 
██      ██    ██ ██   ██ ██       ██         ██    ██ ██ ████  ████ 
█████   ██    ██ ██████  ██   ███ █████      ██    ██ ██ ██ ████ ██ 
██      ██    ██ ██   ██ ██    ██ ██          ██  ██  ██ ██  ██  ██ 
██       ██████  ██   ██  ██████  ███████ ██   ████   ██ ██      ██ 
                                                                    
                                                                                                ]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"

        local opts = {
          theme = "doom",
          hide = {
            -- this is taken care of by lualine
            -- enabling this messes up the actual laststatus setting after loading a file
            statusline = false,
          },
          config = {
            header = vim.split(logo, "\n"),
    -- stylua: ignore
    center = {
      { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "r" },
      { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
      { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "R" },
      { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "/" },
      { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
      { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
      { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
    },
            footer = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return { "⚡ ForgeVim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
          },
        }

        for _, button in ipairs(opts.config.center) do
          button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
          button.key_format = "  %s"
        end

        -- open dashboard after closing lazy
        if vim.o.filetype == "lazy" then
          vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(vim.api.nvim_get_current_win()),
            once = true,
            callback = function()
              vim.schedule(function()
                vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
              end)
            end,
          })
        end

        return opts
      end,
    },
    { -- add symbols-outline
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
      config = true,
    }, -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
vim.cmd.colorscheme("catppuccin")
