# Proposal: Notifications System

## Problem
Perpend currently has no notification system for LSP progress, plugin status, or user messages.

## Solution
Implement notifications using snacks.nvim's notifier module with LSP progress display via autocmd.

## Benefits
- Visual feedback for LSP operations (loading, formatting, etc.)
- Plugin status notifications (lazy.nvim updates, etc.)
- Consistent notification UI across all plugins

## Alternatives Considered
- No notifications (rejected: poor user experience)
- fidget.nvim (rejected: additional plugin dependency)
- nvim-notify (rejected: less maintained, separate plugin)

## Decision
Use snacks.nvim's built-in notifier module with LspProgress autocmd for LSP progress display.

## Date
2026-09-14
