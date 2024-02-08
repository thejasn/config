lvim.builtin.dap.active = true
lvim.transparent_window = true
lvim.colorscheme="tokyonight-night"
lvim.builtin.terminal.active = true

lvim.format_on_save = {
  pattern = {"*.lua", "*.go", "*.py","*.c", "*.rs", "*.cs"}
}


-- encoding options
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16"}
require("lspconfig").clangd.setup({ capabilities = capabilities})

