return {
  {
    "NStefan002/speedtyper.nvim",
    cmd = "SpeedTyper",
    lazy = false,
    -- branch = "v2",
  },

  {
    "kwakzalver/duckytype.nvim",
    cmd = "DuckyType",
    lazy = false,
    config = function()
      require('duckytype').setup({})
    end
  }
}
