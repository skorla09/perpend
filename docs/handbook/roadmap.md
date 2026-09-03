# Roadmap

## Introduction

The development of Perpend is guided by a long-term vision rather than a collection of isolated features. Every milestone represents a stage in the project's evolution, where each new capability builds upon a stable and well-understood foundation.

The roadmap exists to communicate direction, not deadlines. It explains where the project is heading and why each milestone matters, while leaving room for continuous refinement as the project grows.

---

## Phase I — Foundation

**Goal:** Build a reliable, understandable, and maintainable foundation.

This phase establishes the architectural principles that define Perpend. Rather than focusing on adding features quickly, the priority is creating a configuration that is easy to read, easy to extend, and enjoyable to maintain.

Key milestones include:

- Project architecture
- Native LSP
- Treesitter
- Formatting and linting
- Diagnostics
- Telescope navigation
- Keymap architecture
- Documentation (Perpend Handbook)

The completion of this phase marks the point where Perpend becomes a software project instead of simply a personal configuration.

---

## Phase II — Developer Productivity

**Goal:** Improve the daily development experience.

With a solid foundation in place, the next step is providing tools that increase productivity without sacrificing simplicity.

Areas of focus include:

- Git integration
- Testing
- Debugging
- Task runners
- Terminal integration
- Project management

Every addition must continue following the architectural principles established during Phase I.

---

## Phase III — User Experience

**Goal:** Create a polished and cohesive editing experience.

Once the core workflow is complete, attention shifts toward the overall user experience.

Areas of focus include:

- Dashboard
- Statusline
- Notifications
- Which-Key integration
- Session management
- Startup experience
- User interface consistency

This phase focuses on making Perpend feel intuitive, predictable, and pleasant to use every day.

---

## Phase IV — Release & Distribution

**Goal:** Prepare Perpend for public adoption.

With the architecture and user experience established, the project can focus on distribution and accessibility.

Areas of focus include:

- Installation experience
- Repository organization
- Release process
- Documentation improvements
- Versioning
- Community onboarding

The first public release represents the transition from a personal project to an open-source software project.

---

## Phase V — Continuous Evolution

**Goal:** Sustain long-term quality and maintainability.

Software is never truly finished. This phase represents the ongoing evolution of Perpend as new ideas, technologies, and community contributions emerge.

Areas of focus include:

- Architecture Decision Records (ADRs)
- Performance improvements
- Documentation updates
- Plugin research
- Community feedback
- Future releases

Growth should always preserve the principles that define the project.

---

## Success Criteria

The success of Perpend is not measured by the number of installed plugins or implemented features.

Instead, the project is considered successful when:

- The architecture remains easy to understand.
- Every component has a clearly defined responsibility.
- Documentation accurately reflects the implementation.
- New contributors can quickly understand the project.
- Simplicity is preserved as the project grows.
- New features strengthen the architecture instead of increasing complexity.

These principles serve as the project's definition of quality.

---

## Current Status

Perpend has completed **Phase I — Foundation**.

The project's architecture, documentation, and core development workflow have been established:

- Project architecture and layered organization
- Native LSP with servers on `$PATH` (ADR-004)
- Treesitter provider subsystem (ADR-003)
- Formatting and linting via conform and nvim-lint
- Diagnostics
- Telescope navigation
- Keymap architecture (ADR-001)
- Perpend Handbook, complete with Style Guide, Folder Structure, Plugin Guidelines, Milestones, Research Notes, and Agent Guide
- Startup smoke test (`scripts/smoke.sh`)

The next step is **Phase II — Developer Productivity**, which focuses on testing, debugging, task runners, terminal integration, and project management while preserving the simplicity and maintainability that define the project.

---

## Looking Ahead

The roadmap is intentionally designed to evolve over time. As new ideas emerge and the project matures, future milestones may change, but the philosophy behind them should remain constant.

Perpend is never truly finished.

Each release is another step toward a clearer, more maintainable, and more enjoyable development environment.
