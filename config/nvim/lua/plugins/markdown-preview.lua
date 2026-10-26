return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/mkdp/markdown.css")
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_combine_preview = 1 -- reusa la misma pestaña al cambiar de archivo
      vim.g.mkdp_page_title = "${name}"
    end,
  },
}
