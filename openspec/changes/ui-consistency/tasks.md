# Tasks: UI Consistency

## 1. Colorscheme Configuration

- [x] 1.1 Update `lua/plugins/catppuccin.lua` with proper config
- [x] 1.2 Update `lua/plugins/tokyonight.lua` with proper config
- [x] 1.3 Create `lua/config/colorschemes.lua` with available themes

## 2. Colorscheme Switcher

- [x] 2.1 Create `lua/keymaps/ui.lua` for UI-related keymaps
- [x] 2.2 Add `<leader>uc` keymap to cycle through colorschemes
- [x] 2.3 Add visual notification on switch

## 3. Testing

- [x] 3.1 Verify all colorschemes load correctly
- [x] 3.2 Test colorscheme switching with `<leader>uc`
- [x] 3.3 Verify visual feedback on switch
- [ ] 3.4 Check consistency across all themes — manual visual check pending

> Theme-by-theme visual consistency (`3.4`) requires an interactive session and human judgment; the switcher itself is exercised headlessly.

## 4. Documentation

- [x] 4.1 Add research note N-017 (UI consistency)
- [x] 4.2 Update AGENTS.md plugin table
