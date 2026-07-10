require("nvim-eslint").setup({})

local function has_oxfmt_config(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.find(".oxfmtrc.json", {
    path = fname,
    upward = true,
  })[1] ~= nil
end
local function js_formatter(bufnr)
  if has_oxfmt_config(bufnr) then return { "oxfmt", "eslint_d" } end
  return { "prettierd", "eslint_d" }
end

require("conform").setup({
  formatters_by_ft = {
    javascript = js_formatter,
    typescript = function(bufnr) return has_oxfmt_config(bufnr) and { "oxfmt" } or { "prettier" } end,
    javascriptreact = { "oxfmt", "eslint_d" },
    typescriptreact = { "oxfmt", "eslint_d" },
    css = { "oxfmt" },
    scss = { "oxfmt" },
    html = { "prettierd" },
    svg = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
    async = false,
  },
})
