---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- language servers
        "lua-language-server",
        "typescript-language-server",
        "tailwindcss-language-server",

        -- formatters
        "stylua",
        "prettier",
      },
    },
  },
}
