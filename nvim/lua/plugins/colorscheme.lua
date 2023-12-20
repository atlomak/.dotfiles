return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },
    { "navarasu/onedark.nvim" },
    -- Configure LazyVim to load gruvbox
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "onedark",
      },
    },
  }
  