# ADR-005: COMMITTED PLUGIN LOCKFILE

## Status

Accepted

## Context

Perpend delegates plugin installation to lazy.nvim, which records the resolved branch and commit of every installed plugin in `lazy-lock.json`. The file was previously listed in `.gitignore`, so a fresh clone resolved each plugin to the latest commit allowed by its spec.

That behavior made installations non-reproducible: two users cloning on different days could receive different plugin code, and a regression in an upstream plugin could break a configuration that had worked the day before. It also caused a concrete installation failure: `install.sh` copied `lazy-lock.json`, but the file did not exist in a fresh clone, so `set -e` aborted the install after the user's existing configuration had already been moved aside.

## Problem

Should Perpend track the resolved plugin versions so that installations are reproducible?

## Decision

Perpend commits `lazy-lock.json`.

- The file is tracked in version control and is no longer ignored by `.gitignore`.
- `install.sh` copies the lockfile when it is present and warns when it is absent.
- Contributors update the lockfile intentionally with `:Lazy update` and commit the change alongside any related configuration updates.
- A lockfile change is reviewed like any other dependency change.

## Rationale (Why)

A distribution that claims reproducible behavior should pin the code it installs. The lockfile is the smallest artifact that makes plugin state reviewable and repeatable, and it turns an upstream update into an explicit, reviewable commit instead of an invisible side effect of cloning.

Committing the lockfile also removes the installer's dependency on a file that only existed on already-configured machines.

## Alternatives considered

1. Keep `lazy-lock.json` untracked and let every install resolve latest
   Rejected - It makes installations non-reproducible and caused the installer failure described above.

2. Commit the lockfile but let `install.sh` ignore it
   Rejected - The installer would then deliberately discard the reproducibility the repository promises.

3. Pin every plugin with an explicit commit in its declaration
   Rejected - It duplicates lazy.nvim's own mechanism, adds maintenance overhead, and obscures the plugin spec.

## Consequences

### Benefits

- Reproducible installs from a fresh clone.
- Upstream changes become visible, reviewable commits.
- The installer no longer depends on an untracked file.
- A broken upstream release can be diagnosed against a known plugin state.

### Trade-off

- Contributors must remember to update and commit the lockfile when they intend to upgrade plugins.
- The lockfile can conflict when several branches update plugins at once; resolve it by regenerating with `:Lazy update` rather than hand-merging.

## Related Principles

- Reproducibility
- Explicitness
- Every Dependency Must Justify Its Place

## Review Notes

Revisit if lazy.nvim changes how it records resolved plugin state, or if Neovim's native package manager (`vim.pack`) gains an equivalent, stable lockfile mechanism.
