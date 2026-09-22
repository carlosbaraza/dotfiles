-- Install the language tools required by this profile on a fresh ARM machine.
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "typescript-language-server",
      "stylua",
    },
  },
}
