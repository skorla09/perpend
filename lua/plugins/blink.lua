return {
    {
        "saghen/blink.cmp",
        version = "1.*",

        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        opts = require("config.blink"),

        opts_extend = {
            "sources.default",
        },
    },
}
