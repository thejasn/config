local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "goimports", filetypes = { "go" } },
  { command = "gofumpt",   filetypes = { "go" } },
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
})

lsp_manager.setup("gopls", {
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
  end,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        generate = false,
        gc_details = true,
        test = true,
        tidy = true,
      },
    },
  },
})

local status_ok, gopher = pcall(require, "gopher")
if not status_ok then
  return
end

gopher.setup {
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
  },
}

------------------------
-- Language Key Mappings
------------------------

------------------------
-- Dap
------------------------
local dapgo_ok, dapgo = pcall(require, "dap-go")
if not dapgo_ok then
  return
end

dapgo.setup()

local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
  print("nvim-dap not installed!")
  return
end

dap.set_log_level('INFO') -- Helps when configuring DAP, see logs with :DapShowLog

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  }
}

dap.configurations.go = {
  {
    type = "delve",           -- Which adapter to use
    name = "Debug exec",        -- Human readable name
    request = "launch",    -- Whether to "launch" or "attach" to program
    program = "${file}",   -- The buffer you are focused on when running nvim-dap
  },
  {
    type = "delve",           -- Which adapter to use
    name = "Debug",
    request = "launch",
    mode = "debug",
    program = "./${relativeFileDirname}",
  },
  {
    type = "delve",           -- Which adapter to use
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  {
    type = "delve",           -- Which adapter to use
    name = "Attach (Pick Process)",
    mode = "local",
    request = "attach",
    processId = require('dap.utils').pick_process,
  },
  {
    type = "delve",
    name = "Attach (127.0.0.1:9080)",
    mode = "remote",
    request = "attach",
    port = "9080"
  },
}


