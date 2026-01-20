return {
  "AstroNvim/astrolsp",
  opts = {
    servers = {
      "ts_ls",
    },
    config = {
      ts_ls = {
        init_options = {
          maxTsServerMemory = 8192,  -- 8GB, adjust as needed
        },
      },
    },
  },
}
