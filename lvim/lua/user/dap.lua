------------------------
-- Dap
------------------------


-- Dap
local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
  print("nvim-dap not installed!")
  return
end

dap.set_log_level('INFO') -- Helps when configuring DAP, see logs with :DapShowLog

-- Go 

-- Dap Go
local dapgo_ok, dapgo = pcall(require, "dap-go")
if not dapgo_ok then
  return
end

dapgo.setup()

-- Dap adapters 

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  }
}

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

-- Dap go config

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

-- Dap rust config

dap.configurations.rust = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
  },
}
