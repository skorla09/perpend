local M = {}

M.colorschemes = {
    "kanagawa",
    "catppuccin",
    "tokyonight",
}

function M.get_current()
    local current = vim.g.colors_name or "kanagawa"
    for i, cs in ipairs(M.colorschemes) do
        if cs == current then
            return cs, i
        end
    end
    return M.colorschemes[1], 1
end

function M.cycle()
    local _, currentIndex = M.get_current()
    local nextIndex = currentIndex % #M.colorschemes + 1
    local colorscheme = M.colorschemes[nextIndex]
    vim.cmd.colorscheme(colorscheme)
    vim.notify("Colorscheme: " .. colorscheme, vim.log.levels.INFO)
end

return M
