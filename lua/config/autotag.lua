-- nvim-ts-autotag reads its options from the nested `opts` table.
-- The defaults are stated explicitly so the behavior is reviewable.
-- See `docs/handbook/research-notes.md` (N-010).
return {
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = false,
	},
}
