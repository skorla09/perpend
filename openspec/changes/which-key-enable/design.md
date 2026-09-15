# Design: Enable Which-Key Keymaps

## Current State
- which-key.nvim is configured with groups
- Keymaps are commented out in `lua/keymaps/which-key.lua`
- `<leader>?` keymap is defined but not enabled

## Solution

### Enable Keymaps
- Uncomment the `keys` line in `lua/plugins/which-key.lua`
- Keep the `<leader>?` keymap for buffer-local keymaps

### Keymap Behavior
- `<leader>?` shows buffer-local keymaps
- which-key displays popup with available keymaps
- Groups are already configured in `config/which-key.lua`

## Implementation Details

### Plugin File Update
- Enable `keys` field in `lua/plugins/which-key.lua`

### Keymap File
- Keep existing `<leader>?` keymap
- Remove "PROBABLY NOT NEEDED" comment

## Testing Strategy
1. Verify which-key popup appears on `<leader>?`
2. Check that buffer-local keymaps are displayed
3. Verify groups are shown correctly
