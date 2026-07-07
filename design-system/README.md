# Design system — Getamazednow AI v1.0

Shared brand and UI assets used across the mesh's outputs, so board packs, dashboards and
whitepapers carry one consistent identity regardless of which agent or team produced them.

- `brand/` — brand design system reference (voice, color, type rules)
- `templates/` — presentation and report templates for board/CxO packs (`docs/`, quarterly and
  yearly artefact outputs)
- `tokens/` — `design-tokens.json` and `tokens.css`: the source of truth for color, spacing and
  type tokens. `stakeholder-views/*` dashboards should consume these tokens directly rather than
  hardcoding styles, so a brand update propagates to every role's view in one change.
- `logo/` — logo and favicon assets (SVG + PNG, color/mono/white variants)

Any new stakeholder-view dashboard or agent-generated document should reference this directory
rather than embedding its own styling.
