local M = {}

M.colorschemes = {
    "kanagawa",
    "catppuccin",
    "tokyonight",
}

M.current_index = 1

function M.get_current()
    return M.colorschemes[M.current_index]
end

function M.cycle()
    M.current_index = M.current_index % #M.colorschemes + 1
    local colorscheme = M.colorschemes[M.current_index]
    vim.cmd.colorscheme(colorscheme)
    vim.notify("Colorscheme: " .. colorscheme, vim.log.levels.INFO)
end

return M
