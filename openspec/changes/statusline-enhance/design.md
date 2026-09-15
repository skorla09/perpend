# Design: Statusline Enhancement

## Current State
- lualine.nvim with minimal config: `theme = "auto"` only
- Missing LSP server information
- Basic file location display

## Enhanced Configuration

### Sections
1. **lualine_a**: Mode indicator (existing)
2. **lualine_b**: Branch, diff, diagnostics (existing, enhanced)
3. **lualine_c**: Filename (existing, can be enhanced with path)
4. **lualine_x**: Encoding, file format, file type (existing)
5. **lualine_y**: Progress indicator (existing)
6. **lualine_z**: Location (existing, enhanced)

### New Components
1. **LSP Server Name**: Show connected LSP servers
2. **Indentation Info**: Show spaces/tabs and indent size
3. **File Location**: Enhanced with line:column format

### Visual Enhancements
- Use Nerd Font separators (, )
- Proper section separators
- Clean component separators

## Implementation Details

### Config File Updates
- Add section separators
- Add component separators
- Configure each section explicitly

### Plugin File Updates
- Keep dependencies (nvim-web-devicons)
- Keep `opts` pattern

## Testing Strategy
1. Verify statusline displays correctly
2. Check all sections show information
3. Test with different file types
4. Verify colorscheme compatibility
