vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
})


require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },

    lualine_x = {
      {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })

          if #clients == 0 then
            return ""
          end

          return " " .. clients[1].name
        end,
      },
      "filetype",
    },

    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
