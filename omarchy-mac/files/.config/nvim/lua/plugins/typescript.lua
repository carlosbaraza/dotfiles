-- v6 uses vim.lsp.config; server options live under config["ts_ls"] directly
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    servers = { "ts_ls" },
    config = {
      ts_ls = {
        init_options = {
          maxTsServerMemory = 8192,
        },
      },
    },
  },
}
