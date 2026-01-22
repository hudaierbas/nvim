return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "zbirenbaum/copilot.lua",
    },
    config = function()
      require("codecompanion").setup({
        display = {
          chat = {
            window = {
              layout = "vertical",
              width = 0.25,
            },
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  -- default = "claude-3-7-sonnet",
                  default = "gpt-4.1",
                },
              },
            })
          end,
        },
        strategies = {
          chat = { adapter = "copilot" },
          inline = { adapter = "copilot" },
          agent = { adapter = "copilot" },
        },
      })
    end,
  },
}
