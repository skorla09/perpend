local map = vim.keymap.set

map("n", "<leader>uc", function()
    require("config.colorschemes").cycle()
end, { desc = "Cycle Colorscheme" })

map("n", "<leader>us", function()
    local colorscheme = require("config.colorschemes").get_current()
    vim.notify("Current colorscheme: " .. colorscheme, vim.log.levels.INFO)
end, { desc = "Show Current Colorscheme" })
