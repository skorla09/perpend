# INTEGRATION PATTERNS

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This chapter documents patterns for extending Perpend with additional functionality.

Perpend deliberately excludes certain plugins to maintain simplicity. This chapter provides guidance for users who want to add features that are not part of the default distribution.

Each pattern follows Perpend's 3-file architecture and respects the project's architectural principles.

---

# WHEN TO ADD A PLUGIN

Before adding a plugin, ask:

1. Does this solve a real problem I have?
2. Is the problem severe enough to justify a new dependency?
3. Does this plugin follow the architectural patterns Perpend expects?
4. Will I maintain this configuration?

If the answer to any of these questions is no, reconsider the addition.

---

# TERMINAL INTEGRATION

Terminal integration allows managing terminal sessions within Neovim. All major distributions include this feature, but Perpend keeps it optional to avoid assumptions about the user's workflow.

## When to Add

- You frequently switch between editing and terminal commands
- You want floating or split terminal windows
- You prefer in-Neovim terminal management over tmux or external terminals

## Recommended Plugin

- `akinsho/toggleterm.nvim` — Terminal management with multiple orientations

## Configuration Pattern

### Plugin Declaration

```lua
-- lua/plugins/toggleterm.lua
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = {
      border = "curved",
    },
  },
}
```

### Keymaps

```lua
-- lua/keymaps/terminal/toggleterm.lua
local M = {}

M.setup = function()
  local Terminal = require("toggleterm.terminal").Terminal

  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })

  vim.keymap.set("n", "<leader>Tg", function() lazygit:toggle() end, { desc = "Toggle lazygit" })
  vim.keymap.set("n", "<leader>Tf", function() require("toggleterm").toggle(0, nil, nil) end, { desc = "Toggle floating terminal" })
  vim.keymap.set("n", "<leader>Th", function() require("toggleterm").toggle(0, 15, nil, "horizontal") end, { desc = "Toggle horizontal terminal" })
  vim.keymap.set("n", "<leader>Tv", function() require("toggleterm").toggle(0, nil, nil, "vertical") end, { desc = "Toggle vertical terminal" })
end

return M
```

---

# SESSION PERSISTENCE

Session persistence saves and restores open buffers, window layouts, and cursor positions. This is a high-value, low-complexity feature that many users appreciate.

## When to Add

- You work on multiple projects daily
- You want to restore your editing session after closing Neovim
- You lose work context frequently

## Recommended Plugin

- `folke/persistence.nvim` — Session management

## Configuration Pattern

### Plugin Declaration

```lua
-- lua/plugins/persistence.lua
return {
  "folke/persistence.nvim",
  event = "VeryLazy",
  opts = {},
}
```

### Dashboard Integration

If using `startup.nvim` or another dashboard, add a "Restore Session" option:

```lua
-- Example for startup.nvim
{
  section = {
    { type = "text", content = require("startup").utils.logo("dashboard") },
    { type = "padding", value = 1 },
    { type = "text", content = "Perpend", options = { hl = "Special" } },
    { type = "padding", value = 1 },
    { type = "text", content = "A minimal Neovim distribution", options = { hl = "Comment" } },
    { type = "padding", value = 2 },
    {
      type = "group",
      items = {
        { "  ", "Telescope Find Files", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true, nowait = true } },
        { "  ", "Restore Session", function() require("persistence").load() end, { noremap = true, silent = true, nowait = true } },
        { "  ", "New File", "ene <BAR> startinsert", { noremap = true, silent = true, nowait = true } },
        { "  ", "Quit", "<cmd>qa<cr>", { noremap = true, silent = true, nowait = true } },
      },
    },
  },
}
```

### Keymaps

```lua
-- lua/keymaps/session/persistence.lua
local M = {}

M.setup = function()
  vim.keymap.set("n", "<leader>ps", function() require("persistence").load() end, { desc = "Restore session" })
  vim.keymap.set("n", "<leader>pS", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
  vim.keymap.set("n", "<leader>pd", function() require("persistence").stop() end, { desc = "Stop session persistence" })
end

return M
```

---

# DEBUGGING (DAP)

Debugging support allows setting breakpoints, stepping through code, and inspecting variables. This feature is workflow-dependent and not universally needed.

## When to Add

- You use interactive debugging (not just print/log statements)
- You debug complex applications with breakpoints and variable inspection
- You want IDE-like debugging within Neovim

## Recommended Plugins

- `mfussenegger/nvim-dap` — Debug Adapter Protocol client
- `rcarriga/nvim-dap-ui` — Debug UI
- `theHamsta/nvim-dap-virtual-text` — Inline variable values
- `nvim-neotest/nvim-nio` — Async I/O (dependency for nvim-dap-ui)

## Configuration Pattern

### Plugin Declaration

```lua
-- lua/plugins/dap.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
```

### Language-Specific Adapters

You must install debug adapters separately. Examples:

- **Python**: Install `debugpy` via `pip install debugpy`
- **Node.js**: Install `node-debug2-adapter` via `npm install -g node-debug2-adapter`
- **Go**: Use `nvim-dap-go` with `dlv` installed via `go install github.com/go-delve/delve/cmd/dlv@latest`

### Keymaps

```lua
-- lua/keymaps/debug/dap.lua
local M = {}

M.setup = function()
  local dap = require("dap")

  vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue" })
  vim.keymap.set("n", "<leader>dn", function() dap.step_over() end, { desc = "Step over" })
  vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step into" })
  vim.keymap.set("n", "<leader>do", function() dap.step_out() end, { desc = "Step out" })
  vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional breakpoint" })
  vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle REPL" })
  vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run last" })
  vim.keymap.set("n", "<leader>dt", function() dap.terminate() end, { desc = "Terminate" })
end

return M
```

---

# TASK RUNNERS

Task runners provide a structured way to run builds, tests, and custom commands within Neovim. Most developers use terminal commands or tmux instead.

## When to Add

- You want to run build/test/lint commands from within Neovim
- You want output parsing and quickfix integration
- You want task templates and reusability

## Recommended Plugin

- `stevearc/overseer.nvim` — Task runner and job orchestrator

## Configuration Pattern

### Plugin Declaration

```lua
-- lua/plugins/overseer.lua
return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>oR", "<cmd>OverseerRunLast<cr>", desc = "Run last task" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
    { "<leader>os", "<cmd>OverseerToggle!<cr>", desc = "Toggle task runner" },
    { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear task cache" },
  },
  opts = {},
}
```

### Task Templates

Create custom task templates in `.overseer/` directory at project root:

```lua
-- .overseer/template.lua
return {
  name = "Run tests",
  builder = function()
    return {
      cmd = { "npm", "test" },
      components = { "default" },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.filereadable("package.json") == 1
    end,
  },
}
```

---

# TESTING FRAMEWORK

Testing frameworks allow running tests from within Neovim. Testing is project-specific and should be configured per-project, not by the distribution.

## When to Add

- You want to run tests from within Neovim
- You want test output and failure locations in the editor
- You want test summary panels

## Recommended Plugin

- `nvim-neotest/neotest` — Test runner framework
- Language-specific adapters (e.g., `neotest-jest`, `neotest-vitest`, `neotest-python`)

## Configuration Pattern

### Plugin Declaration

```lua
-- lua/plugins/neotest.lua
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
  },
  ft = { "typescript", "javascript", "python" },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest"),
        -- require("neotest-vitest"),
        -- require("neotest-python"),
      },
    })
  end,
}
```

### Keymaps

```lua
-- lua/keymaps/testing/neotest.lua
local M = {}

M.setup = function()
  local neotest = require("neotest")

  vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { desc = "Run nearest test" })
  vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
  vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
  vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, { desc = "Show test output" })
  vim.keymap.set("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run last test" })
  vim.keymap.set("n", "<leader>ta", function() neotest.run.run(vim.uv.cwd()) end, { desc = "Run all tests" })
end

return M
```

---

# MAINTAINING THIS CHAPTER

When adding new integration patterns:

1. Follow the 3-file pattern (plugin, config, keymaps)
2. Include clear "When to Add" criteria
3. Provide complete, working configuration examples
4. Document keymaps with descriptive `desc` values
5. Note any language-specific requirements
