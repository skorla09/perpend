return {
  -- snacks.nvim: dashboard and notifier modules
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
            { icon = " ", key = "b", desc = "Find Buffer", action = ":Telescope buffers" },
            { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 40, max = 50 },
        height = { min = 1, max = 10 },
        margin = { top = 0, right = 1, bottom = 0, left = 1 },
        padding = { top = 0, right = 1, bottom = 0, left = 1 },
        sort = "status",
        level = vim.log.levels.INFO,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        keep = function(notif)
          return vim.fn.has("win32") == 1 or notif.level == vim.log.levels.ERROR
        end,
        style = "compact",
        top_down = true,
        date_format = "%T",
        max_width = 50,
      },
    },
    keys = {
      { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss Notification" },
      { "<leader>nh", function() Snacks.notifier.history() end, desc = "Notification History" },
    },
  },

  -- startup.nvim: disabled (replaced by snacks.nvim dashboard)
  -- Reason: startup.nvim has lower adoption (502 stars), GPL license, and fewer features
  -- snacks.nvim is maintained by folke (lazy.nvim author) and provides modern dashboard
  -- Date: 2026-09-14
  -- { "max397574/startup.nvim", enabled = false },
}
