return {
  "ag-libs/lathe.nvim",
  ft = "java",
  cmd = "LatheStart",
  event = { "BufReadPre pom.xml", "BufNewFile pom.xml" },
  config = function()
    require("lathe").setup()
  end,
}
