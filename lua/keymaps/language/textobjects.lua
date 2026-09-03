-- lua/keymaps/treesitter-textobjects.lua

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

--------------------------------------------------------------------------------
-- Select
--------------------------------------------------------------------------------

vim.keymap.set({ "x", "o" }, "af", function()
	select.select_textobject("@function.outer", "textobjects")
end, { desc = "Around Function" })

vim.keymap.set({ "x", "o" }, "if", function()
	select.select_textobject("@function.inner", "textobjects")
end, { desc = "Inside Function" })

vim.keymap.set({ "x", "o" }, "ac", function()
	select.select_textobject("@class.outer", "textobjects")
end, { desc = "Around Class" })

vim.keymap.set({ "x", "o" }, "ic", function()
	select.select_textobject("@class.inner", "textobjects")
end, { desc = "Inside Class" })

vim.keymap.set({ "x", "o" }, "ap", function()
	select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Around Parameter" })

vim.keymap.set({ "x", "o" }, "ip", function()
	select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Inside Parameter" })

--------------------------------------------------------------------------------
-- Move
--------------------------------------------------------------------------------

vim.keymap.set({ "n", "x", "o" }, "]m", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next Function" })

vim.keymap.set({ "n", "x", "o" }, "[m", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Previous Function" })

vim.keymap.set({ "n", "x", "o" }, "]c", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next Class" })

vim.keymap.set({ "n", "x", "o" }, "[c", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Previous Class" })
