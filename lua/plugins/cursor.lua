return {
  "sphamba/smear-cursor.nvim",
  event = "BufWinEnter",
  config = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      callback = function()
        require('smear_cursor').toggle()
      end
    })
  end
}

