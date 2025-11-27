return {
  "numToStr/Comment.nvim",
  opts = {},
  keys = {
    { "<leader>/", function() require("Comment.api").toggle.linewise.current() end, mode = "n"},
    { "<leader>/", "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", mode = "v"},
  },
}
