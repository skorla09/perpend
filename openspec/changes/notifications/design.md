# Design: Notifications System

## Current State
- No notification system
- LSP operations run silently
- No visual feedback for background operations

## Solution Components

### 1. snacks.nvim Notifier Module
- Enable `notifier` module in snacks.nvim opts
- Configure notification appearance and behavior

### 2. LSP Progress Autocmd
- Create autocmd for `LspProgress` event
- Show progress notification with server name and operation
- Clear notification when operation completes

### 3. Notification Integration
- lazy.nvim can use snacks.nvim for update notifications
- Other plugins can use `vim.notify()` which routes to snacks.nvim

## Implementation Details

### Config Updates
- Add `notifier` to snacks.nvim opts in `lua/plugins/dashboard.lua`

### Autocmd Implementation
- Create `lua/config/autocmds.lua` update or new file
- Add LspProgress event handler
- Format progress message with server name and operation

### Key Features
- Non-intrusive notifications (bottom-right corner)
- Auto-dismiss after timeout
- Manual dismiss with `<leader>nd`
- History view with `<leader>nh`

## Testing Strategy
1. Trigger LSP operation (format, rename)
2. Verify notification appears
3. Verify notification auto-dismisses
4. Test manual dismiss and history view
