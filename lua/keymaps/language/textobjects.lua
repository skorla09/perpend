-- lua/keymaps/language/textobjects.lua

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

--------------------------------------------------------------------------------
-- Select
--------------------------------------------------------------------------------

vim.keymap.set({ "x", "o" }, "af", function()
	select.select_textobject("@function.outer", "textobjects")
end, { desc = "Around function" })

vim.keymap.set({ "x", "o" }, "if", function()
	select.select_textobject("@function.inner", "textobjects")
end, { desc = "Inside function" })

vim.keymap.set({ "x", "o" }, "ac", function()
	select.select_textobject("@class.outer", "textobjects")
end, { desc = "Around class" })

vim.keymap.set({ "x", "o" }, "ic", function()
	select.select_textobject("@class.inner", "textobjects")
end, { desc = "Inside class" })

vim.keymap.set({ "x", "o" }, "ap", function()
	select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Around parameter" })

vim.keymap.set({ "x", "o" }, "ip", function()
	select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Inside parameter" })

--------------------------------------------------------------------------------
-- Move
--------------------------------------------------------------------------------

vim.keymap.set({ "n", "x", "o" }, "]m", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function" })

vim.keymap.set({ "n", "x", "o" }, "[m", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Previous function" })

vim.keymap.set({ "n", "x", "o" }, "]c", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class" })

vim.keymap.set({ "n", "x", "o" }, "[c", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Previous class" })
