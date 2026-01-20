-- tsgo requires lspconfig v3+ which breaks AstroNvim
-- Using ts_ls until AstroNvim updates to support new lspconfig API
return {
  "AstroNvim/astrolsp",
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
