return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            include_surrounding_whitespace = false,
            lookahead = true,
            keymaps = {
              [".s"] = {
                query = "@scope",
                query_group = "locals",
                desc = "Incremental scope selection"
              },
              ["if"] = "@function.inner",
              ["af"] = "@function.outer",
              ["ic"] = "@class.inner",
              ["ac"] = "@class.outer",
              ["ip"] = "@parameter.inner",
              ["ap"] = "@parameter.outer",
              ["i,"] = "@call.inner",
              ["a,"] = "@call.outer",
            },
            selection_modes = {
              ['@scope'] = 'v',
              ['@function.outer'] = 'V',
            }
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]p"] = "@parameter.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[p"] = "@parameter.outer",
            }
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sn"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sp"] = "@parameter.inner",
            }
          }
        }
      })
    end
  }
}
