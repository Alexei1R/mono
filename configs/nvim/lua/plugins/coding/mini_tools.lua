-- Mini.nvim tools for coding
return {
  { 
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside text objects
      require("mini.ai").setup({ n_lines = 500 })
      
      -- Surround text objects
      require("mini.surround").setup()
    end,
  }
}
