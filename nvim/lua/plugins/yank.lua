return {
    {
        "ibhagwan/smartyank.nvim",
        config = function()
            require("smartyank").setup({
                highlight = {
                    enabled = true,
                    timer = 150,
                },
                clipboard = {
                    enabled = true,
                },
                tmux = {
                    enabled = false,
                    cmd = { "tmux", "load-buffer", "-" },
                },
                osc52 = {
                    enabled = false,
                    ssh_only = true,
                    silent = false,
                    echo_hl = "Directory",
                },
                validate_yank = function ()
                    return vim.v.operator == "y"
                end,
            })
        end,
    },
}
