return {
  -- ONLY add your own LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        pyright = {},
      },
    },
  },
}
