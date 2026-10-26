return {
  "iamkarasik/sonarqube.nvim",
  event = "LazyFile",
  config = function()
    require("sonarqube").setup({})
  end,
}
