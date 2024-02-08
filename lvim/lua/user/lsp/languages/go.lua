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


-- ray-x go setup 
--

local go_ok, go = pcall(require, "go")
if not (go_ok) then
  print("ray-x/go not installed!")
  return
end

go.setup({
  dap_debug_gui = {
 expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.33 },
          { id = "breakpoints", size = 0.17 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        size = 0.33,
        position = "right",
      },
      {
        elements = {
          { id = "repl", size = 0.45 },
          { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5, -- Floats will be treated as percentage of your screen.
      border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { "q", "<Esc>" },
      },
    } ,
  }
})

