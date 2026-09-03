return {
    keymap = {
        preset = "enter",
    },

    appearance = {
        nerd_font_variant = "mono",
    },

    completion = {
        menu = {
            border = "rounded",
            draw = {
                treesitter = { "lsp" },
                columns = {
                  { "kind_icon" },
                  { "label", "label_description", gap = 1 },
                },
            },
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            window = {
                border = "rounded",
            },
        },

        ghost_text = {
            enabled = true,
        },
    },

    signature = {
        enabled = true,
        window = {
            border = "rounded",
        },
    },

    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },

    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
    },
}
