# PERPEND AGENT GUIDE

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This document defines how AI agents should work within the Perpend repository.

It is an operational guide for agents, not a replacement for the Perpend Handbook.

Agents should use the repository's existing documentation, architecture, ADRs, implementation, and external authoritative sources as evidence before proposing or implementing changes.

The goal is not for an agent to memorize Perpend.
The goal is for an agent to know where to look before making a decision.

---

# 1. THE FIRST RULE: ESTABLISH THE REFERENCE

Before making a significant change, establish what is already true.

Do not assume that:

- the roadmap has changed,
- a document does not exist,
- an architectural decision has not already been made,
- a feature has not already been implemented,
- a previous plan is obsolete,
- a tool or plugin still behaves the way it did in previous versions,
- or a new approach is preferable to the existing one.

Search the repository first.

Read the relevant documentation.
Inspect the implementation.
Check existing ADRs.

For external technologies, consult their current authoritative documentation.

Only then propose a change.

When information is missing, explicitly identify the uncertainty rather than filling the gap with an assumption.

---

# 2. SOURCE-OF-TRUTH HIERARCHY

When determining project intent or current state, use the following hierarchy.

## 2.1 Current Implementation

The source code is authoritative for what the project currently does.

Do not describe behavior based solely on documentation if the implementation contradicts it.

## 2.2 Architecture Decision Records

ADRs are authoritative for significant architectural decisions and their historical rationale.

Before proposing a change to an established architectural area:

1. Find related ADRs.
2. Read them.
3. Determine whether the decision is still active.
4. Identify the principles involved.
5. Determine whether the proposed change requires a new ADR.

Never silently reverse an existing architectural decision.

## 2.3 Handbook

The Handbook is authoritative for Perpend's philosophy, vision, principles, architecture, and roadmap.

Important documents include:

- `handbook/README.md`
- `handbook/philosophy.md`
- `handbook/vision.md`
- `handbook/principles.md`
- `handbook/architecture.md`
- `handbook/roadmap.md`

The Handbook explains not only what Perpend is, but why it is built this way.

## 2.4 External Authoritative Documentation

When researching technologies used by Perpend, the latest authoritative documentation takes precedence over an agent's prior knowledge.

Examples include:

- plugin GitHub repositories,
- official plugin documentation,
- official Neovim documentation,
- official language-server documentation,
- official language documentation,
- official framework documentation,
- official API references,
- official release notes and changelogs.

An agent's training knowledge is not sufficient evidence for current technical behavior when authoritative, up-to-date documentation is available.

## 2.5 AGENTS.md

`AGENTS.md` defines how agents should operate.

It does not override project philosophy, architecture, ADRs, or current implementation.

If this document conflicts with a more authoritative project artifact, stop and investigate the discrepancy rather than silently choosing one.

---

# 3. RESEARCH MUST BE CURRENT

Research is part of Perpend's engineering process.

When investigating a technology, dependency, plugin, API, configuration option, or tool, agents must seek the most current reliable information available.

Research performed for Perpend should produce reusable project knowledge rather than disappearing into an individual agent's context.

## 3.1 Never rely on training knowledge alone

AI agents may possess knowledge that is incomplete, outdated, or based on an earlier version of a technology.

Prior knowledge may be useful for forming an initial hypothesis.

It is not sufficient evidence for a current implementation decision when authoritative, up-to-date documentation is available.

## 3.2 Prefer primary sources

When researching an external technology, prefer sources in approximately this order:

1. Official documentation.
2. Official GitHub repository.
3. Official API/reference documentation.
4. Official release notes or changelog.
5. Official migration guides.
6. Maintainer-authored documentation.
7. Reliable secondary sources when primary sources do not answer the question.

For GitHub-hosted plugins, inspect the plugin's current repository rather than relying exclusively on remembered configuration examples.

## 3.3 Verify the version

When version information matters, determine:

- the version currently used by Perpend,
- the latest relevant stable version,
- whether the API or configuration changed,
- whether the documented approach applies to the version being evaluated.

Do not assume that the latest documentation necessarily applies unchanged to an older pinned version.

Likewise, do not assume that an old configuration remains valid for the latest release.

If the versions differ, explicitly explain the difference.

## 3.4 Check current configuration APIs

For plugin and tool research, verify when relevant:

- current installation instructions,
- current configuration API,
- current module names,
- current option names,
- current defaults,
- supported filetypes,
- supported integrations,
- breaking changes,
- migration guidance,
- and deprecations.

A configuration copied from an old tutorial is not considered verified.

## 3.5 Record what Perpend learned

Research findings that are relevant to the project should be recorded in `handbook/research-notes.md`.

This file is a planned Handbook chapter and the project's intended record of knowledge gained through investigation. Until the chapter is created, agents may seed it with significant findings.

Research Notes should capture useful findings such as:

- technology evaluations,
- plugin investigations,
- version differences,
- API changes,
- compatibility findings,
- rejected alternatives,
- experiments,
- performance observations,
- implementation discoveries,
- and lessons learned from external documentation.

The purpose is to preserve knowledge so that future contributors and agents do not need to repeat the same investigation unnecessarily.

## 3.6 Research Notes are not ADRs

Research Notes record what Perpend learned.

ADRs record what Perpend decided.

A research investigation may lead to an ADR, but the two documents serve different purposes.

For example:

```
Research:
"Plugin X changed its configuration API in version 5.
The previous setup is deprecated."

         |
         v

Research Notes:
handbook/research-notes.md

         |
         v

Decision:
"Perpend will migrate to the new configuration API."

         |
         v

ADR:
docs/adr/XXXX-migrate-plugin-x.md

         |
         v

Implementation:
plugins/plugin-x.lua
```

Do not use Research Notes to silently establish architectural decisions.
Do not use ADRs as a replacement for documenting significant research.

## 3.7 Research conclusions must identify evidence

When research materially influences a decision, record the relevant evidence.

A Research Note should make it possible for another engineer to understand where the conclusion came from.

For example:

```
Technology:        Plugin X
Version Investigated: v5.2.0
Perpend Version:   v5.2.0
Source:            Official GitHub repository
Documentation:     Official configuration guide
Finding:           The previous configuration API was deprecated in v5.
Impact:            Perpend's existing configuration should be reviewed.
Conclusion:        Migration to the current API is recommended.
```

Include links or references to the authoritative sources whenever practical.

## 3.8 Do not preserve outdated knowledge as current knowledge

Research Notes are historical records as well as knowledge resources.

When later research proves an earlier finding incorrect or outdated:

1. Preserve the original finding when it is historically useful.
2. Clearly identify the newer information.
3. Record the relevant version or date.
4. Do not allow obsolete information to appear as current guidance.

Research should evolve as technology evolves.

The goal is not to pretend previous knowledge was never wrong.
The goal is to preserve how understanding changed.

## 3.9 Research protocol

When a task requires research, follow this sequence:

1. Define the question.
2. Determine which version of the technology matters.
3. Find the primary source.
4. Inspect the latest relevant documentation.
5. Inspect the official repository when applicable.
6. Check release notes or changelog when version changes may matter.
7. Compare the current documentation with Perpend's implementation.
8. Record relevant findings in `handbook/research-notes.md` when the research is significant enough to benefit future contributors.
9. Distinguish verified information from interpretation.
10. Make the recommendation only after verification.

The purpose of this sequence is to ensure that research becomes part of Perpend's knowledge rather than remaining temporary agent context.

For plugin research, the minimum expectation is:

- Plugin name
- Current Perpend version/reference
- Latest relevant plugin version
- Official repository
- Current official configuration guidance
- Relevant breaking changes/deprecations
- Compatibility considerations
- Recommendation

Do not recommend a plugin configuration based solely on a remembered configuration snippet.

When research produces a significant architectural or project-wide decision, determine whether an ADR should also be created.

Research Notes preserve what Perpend learned.
ADRs preserve what Perpend decided.

---

# 4. CURRENT PROJECT STATUS

The authoritative roadmap is maintained in `handbook/roadmap.md`.

Agents must read that document before planning substantial work.

Do not treat any summary in this guide as a replacement for the roadmap.

Perpend has completed **Phase I — Foundation** and is currently working on **Phase II — Developer Productivity**.

The project's phases are:

- **Phase I — Foundation** (complete)
- **Phase II — Developer Productivity** (current)
- **Phase III — User Experience**
- **Phase IV — Release & Distribution**
- **Phase V — Continuous Evolution**

The exact scope and readiness criteria for each phase must be verified against `handbook/roadmap.md` before work begins.

---

# 5. NEVER CREATE A COMPETING ROADMAP

Agents must not create a new roadmap or silently replace the existing phase/milestone structure.

When a new idea appears:

1. Determine whether it already exists in `handbook/roadmap.md`.
2. Determine whether it belongs to the current phase.
3. Determine whether it belongs to a future phase.
4. Identify whether it is merely an idea rather than a committed task.
5. If uncertain, record the uncertainty.
6. Do not promote the idea into the roadmap without explicit human agreement.

A compelling new idea is not automatically a roadmap change.

---

# 6. NEVER INVENT PROJECT HISTORY

Never claim that Perpend:

- previously decided something,
- abandoned something,
- completed a milestone,
- planned a feature,
- rejected an approach,
- created a document,
- or agreed upon a design

unless that history can be verified through repository artifacts or explicitly supplied project context.

If historical information cannot be verified, say:

> "I could not verify this from the repository."

Do not reconstruct missing history from assumptions.

A plausible history is still an invented history.

---

# 7. DISTINGUISH FACT FROM INFERENCE

Agents should explicitly distinguish between:

- Verified fact
- Inference
- Proposal
- Unknown

For example:

```
Verified:   An ADR exists for keymap architecture.
Inference:  The current keymap structure appears to follow that decision.
Proposal:   A shared keymap interface could simplify the current structure.
Unknown:    It is unclear whether the previous experimental approach was
            intentionally abandoned.
```

Never present an inference or proposal as historical fact.

---

# 8. THE TWO-PASS RULE

For significant tasks, agents should work in two passes.

**Pass 1 — Understanding**

Before changing anything:

- inspect relevant files,
- search for related concepts,
- read relevant Handbook chapters,
- inspect related ADRs,
- inspect current implementation,
- research external technologies when applicable,
- identify constraints,
- identify the current phase,
- summarize the current state.

Do not modify files during this pass unless explicitly requested.

**Pass 2 — Implementation**

Only after the current state is understood:

- propose the smallest appropriate change,
- implement it,
- update relevant documentation,
- update or create ADRs when necessary,
- verify the result.

The purpose of the two-pass rule is to prevent solving an imagined version of the problem.

---

# 9. CHANGE DISCIPLINE

Before making a significant change, determine:

- **What exists?** Inspect the current implementation and documentation.
- **Why does it exist?** Read relevant principles and ADRs.
- **What problem does the proposed change solve?** State the problem explicitly.
- **What alternatives exist?** Consider simpler approaches before introducing complexity.
- **What external evidence is available?** Research current authoritative documentation when the decision involves an external technology.
- **What changes?** Identify affected components and documentation.
- **What must remain stable?** Identify existing behavior, architectural boundaries, and decisions that should not change.

---

# 10. ADR DISCIPLINE

An ADR should be considered when a change:

- alters architecture,
- changes responsibilities,
- introduces a significant dependency,
- establishes a project-wide convention,
- changes a major workflow,
- reverses an existing architectural decision,
- or creates a decision future contributors would reasonably need to understand.

Do not create an ADR for every small implementation detail.

Do not modify an existing ADR to hide historical decisions.

If an existing decision changes, prefer recording the new decision and linking it to the previous one.

---

# 11. DOCUMENTATION DISCIPLINE

Documentation is part of the product.

When implementation changes meaningfully:

1. Identify affected documentation.
2. Update it when appropriate.
3. Preserve the reasoning behind the change.
4. Avoid duplicating information unnecessarily.

The goal is not maximum documentation.
The goal is preserved understanding.

---

# 12. MINIMAL CHANGE PRINCIPLE

Prefer the smallest change that solves the actual problem.

Do not:

- reorganize unrelated files,
- introduce unnecessary abstractions,
- replace working tools without justification,
- add dependencies without a meaningful reason,
- rewrite documentation that does not require modification,
- or expand scope simply because an adjacent improvement is possible.

If a larger refactor appears necessary, explain why before proceeding.

---

# 13. WORKING WITH MULTIPLE AGENTS

When multiple agents work on Perpend, each agent should identify:

- the task being performed,
- the files being modified,
- the relevant phase,
- the relevant principles,
- relevant ADRs,
- dependencies on other work,
- and any assumptions being made.

Agents should avoid overlapping modifications unless coordination is explicit.

Before starting work, inspect `git status` and recent changes.

Never assume another agent's work is complete merely because the task appears in the roadmap.

---

# 14. HANDOFF FORMAT

When handing work to another agent, provide:

- **Task:** What was being worked on.
- **Current State:** What has been verified.
- **Changes Made:** What was actually changed.
- **Files:** Files modified or created.
- **Decisions:** Relevant architectural or engineering decisions.
- **Research:** External sources consulted, versions investigated, and relevant findings.
- **Research Notes:** Relevant entry in `handbook/research-notes.md`, if created or updated.
- **Unresolved Questions:** Things that remain uncertain.
- **Next Recommended Step:** The smallest logical next action.
- **Verification:** What was tested or inspected.

A handoff should describe reality, not intention.

---

# 15. WHEN UNCERTAINTY IS HIGH

Stop and ask for clarification when:

- two authoritative documents conflict,
- the roadmap and implementation disagree,
- an existing ADR appears to conflict with a new requirement,
- project philosophy or principles would be materially changed,
- project history cannot be verified,
- external documentation is contradictory,
- version compatibility is uncertain,
- or the task requires choosing between materially different architectural directions.

Do not resolve significant ambiguity by guessing.

---

# 16. THE DECISION TEST

When evaluating a proposed change, ask:

- Does it solve a real problem?
- Is the problem understood?
- Has the current implementation been inspected?
- Has relevant documentation been reviewed?
- Has current authoritative external documentation been consulted when necessary?
- Is the solution simpler than its alternatives?
- Does it have a clear responsibility?
- Does it introduce unnecessary complexity?
- Does every dependency justify its place?
- Can the decision be explained?
- Does it help the next reader?
- Does it preserve or improve understanding?
- Does it align with the current phase?

If several answers are unclear, investigate before implementing.

---

# 17. THE PHASE COMPLETION TEST

A phase is not complete because all listed tasks were implemented.

Before declaring a phase complete, verify:

- implementation,
- documentation,
- architectural decisions,
- research where applicable,
- tests or verification where applicable,
- roadmap status,
- and lessons learned.

A phase should leave the workshop better than it found it.

---

# 18. AGENT BEHAVIOR

Agents working on Perpend should behave as collaborators, not autonomous project owners.

Agents may:

- investigate,
- explain,
- research,
- propose,
- implement,
- document,
- test,
- and identify inconsistencies.

Agents should not silently:

- redefine project goals,
- replace the roadmap,
- invent historical decisions,
- create new project milestones,
- change foundational philosophy,
- change foundational principles,
- or override established architecture.

Significant changes to project direction require explicit human agreement.

---

# 19. FOUNDATIONAL DOCUMENT CHANGES

The following documents define the identity of Perpend:

- `handbook/philosophy.md`
- `handbook/vision.md`
- `handbook/principles.md`
- `handbook/roadmap.md`

Changes to these documents should be treated as significant project decisions.

Before changing them:

1. Read the current document completely.
2. Identify the existing intent.
3. Check related documents for dependencies.
4. Determine whether an ADR is appropriate.
5. Explain the proposed change.
6. Obtain explicit human agreement before making a change that alters project direction.

Do not rewrite foundational documents merely because a new formulation sounds better.
Refactor them when the project has genuinely learned something new.

---

# 20. THE CONTEXT CHECK

Before beginning significant implementation work, an agent should be able to answer:

- **Current Phase:** What phase is active?
- **Current Objective:** What are we trying to accomplish?
- **Relevant Principles:** Which Perpend principles apply?
- **Relevant ADRs:** Which existing decisions constrain the work?
- **Current Implementation:** What currently exists?
- **External Research:** What current authoritative documentation is relevant?
- **Files Likely Affected:** Which files are actually involved?
- **Verified Constraints:** What must remain true?
- **Unknowns:** What remains uncertain?
- **Proposed Next Step:** What is the smallest logical next action?

If these questions cannot be answered from evidence, the agent should investigate before implementing.

---

# 21. THE FINAL CHECK

Before completing significant work, ask:

- Did I establish the reference before making the decision?
- Did I verify the current implementation?
- Did I consult current authoritative documentation when necessary?
- Did I build with intention?
- Did I preserve the project's history rather than inventing it?
- Did I leave the workshop better than I found it?

If the answer is yes, the work is aligned with Perpend.
If the answer is uncertain, investigate before declaring the work complete.
