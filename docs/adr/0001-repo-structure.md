# ADR 0001: Monorepo, structured by operating-model concept, not by team

## Status
Proposed

## Context
The operating model (see /docs/whitepaper) defines 5 cadences, 12 artefacts, 13 agents and
8 stakeholder groups. The repo needs to make the running mesh and its governed outputs
inspectable, reviewable and auditable — not just host code.

## Decision
Single repo, top-level directories organized by operating-model concept:
docs (rationale) / artefacts (governed outputs) / mesh (agents + orchestrator + policy) /
cadence (scheduling) / stakeholder-views (access) / infra / tests.

This keeps an artefact's data next to the agent that owns it conceptually, while letting
CODEOWNERS and branch protection enforce the human checkpoint per cadence directly on
folder paths, rather than relying on a separate governance tool.

## Alternatives considered
See the accompanying rationale document for the full monorepo-vs-multi-repo comparison.

## Consequences
- CI and CODEOWNERS rules are path-based and must be kept in sync as agents/artefacts are added.
- A single repo scales to Phase 1–3 of the adoption roadmap comfortably; revisit if agent
  build/release cadences diverge sharply by Phase 4 (see rationale doc, Risks).
