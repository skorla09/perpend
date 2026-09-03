return {
    {
        "stevearc/conform.nvim",

        event = "BufWritePre",

        cmd = {
            "ConformInfo",
        },

        keys = require("keymaps.code.conform"),

        opts = require("config.conform"),
    },
}

