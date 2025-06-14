return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        global_settings = {
          save_on_toggle = false,
          save_on_change = true,
          mark_branch = true,
        },
      })

      vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon: Add file" })

      vim.keymap.set("n", "<leader>ha", function() require("harpoon"):list():select(1) end, { desc = "Harpoon: Go to file 1" })
      vim.keymap.set("n", "<leader>hs", function() require("harpoon"):list():select(2) end, { desc = "Harpoon: Go to file 2" })
      vim.keymap.set("n", "<leader>hd", function() require("harpoon"):list():select(3) end, { desc = "Harpoon: Go to file 3" })
      vim.keymap.set("n", "<leader>hf", function() require("harpoon"):list():select(4) end, { desc = "Harpoon: Go to file 4" })

      vim.keymap.set("n", "<C-n>", function() require("harpoon"):list():next() end, { desc = "Harpoon: Next file" })
      vim.keymap.set("n", "<C-p>", function() require("harpoon"):list():prev() end, { desc = "Harpoon: Prev file" })

      vim.keymap.set("n", "<leader>ho", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon: Toggle menu" })

      require("telescope").load_extension("harpoon")
      vim.keymap.set("n", "<leader>hm", ":Telescope harpoon marks<CR>", { desc = "Harpoon: Telescope marks" })
    end,
  },
}
