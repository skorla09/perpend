local M = {}

M.colorschemes = {
    "kanagawa",
    "catppuccin",
    "tokyonight",
}

-- Track current index in module variable
M.current_index = nil

-- Sync with vim.g.colors_name on first call
local function sync_index()
    if M.current_index then
        return
    end

    local current = vim.g.colors_name or "kanagawa"
    for i, cs in ipairs(M.colorschemes) do
        if cs == current then
            M.current_index = i
            return
        end
    end
    -- Default to first if no match
    M.current_index = 1
end

function M.get_current()
    sync_index()
    return M.colorschemes[M.current_index], M.current_index
end

function M.cycle()
    sync_index()
    M.current_index = M.current_index % #M.colorschemes + 1
    local colorscheme = M.colorschemes[M.current_index]
    vim.cmd.colorscheme(colorscheme)
    vim.notify("Colorscheme: " .. colorscheme, vim.log.levels.INFO)
end

return M
