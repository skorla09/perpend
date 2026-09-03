return {
    {
        "<leader>cf",
        function()
            require("conform").format({
                async = true,
                lsp_format = "fallback",
            })
        end,
        desc = "Format Buffer",
    },
}
