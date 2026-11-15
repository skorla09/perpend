# Tasks: Notifications System

## 1. Notifications Implementation

- [x] 1.1 Update `lua/plugins/dashboard.lua` with snacks.nvim notifier opts
- [x] 1.2 Create LspProgress autocmd in `lua/config/autocmds.lua`
- [x] 1.3 Add notification keymaps (`<leader>nd`, `<leader>nh`)

## 2. Testing

- [x] 2.1 Verify LSP progress notifications appear
- [ ] 2.2 Verify notifications auto-dismiss — manual UI check pending
- [ ] 2.3 Test manual dismiss and history view — manual UI check pending
- [ ] 2.4 Verify notification appearance — manual UI check pending

> Manual UI checks (`2.2`–`2.4`) require an interactive session; the headless smoke test only confirms the notifier options load without errors.

## 3. Documentation

- [x] 3.1 Add research note N-015 (notification system)
- [x] 3.2 Update AGENTS.md plugin table
