---@type LazySpec
return {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe", "rfc_csv", "rfc_semicolon" },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  opts = {
    parser = { comments = { "#", "//" } },
    view = { display_mode = "border" },
    keymaps = {
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    },
  },
}
