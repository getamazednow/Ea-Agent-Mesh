# EA Agent Mesh — Operating Model

A multi-cadence agent mesh that runs Enterprise Architecture as a continuously operating
practice — five clock speeds (Daily / Weekly / Monthly / Quarterly / Yearly), twelve core
artefacts, thirteen agents, one orchestrator.

See `/docs/whitepaper` for the executive rationale, `/docs/deck` for the board-level summary,
and `/docs/adr` for the architecture decisions behind this repo's structure.

## Repository map

| Path | What lives here | Owned by |
|---|---|---|
| `docs/` | Whitepaper, deck, visualization, ADRs | EA practice lead |
| `artefacts/` | The 12 EA artefacts as living, versioned data (not slideware) | Per-artefact agent + human approver |
| `mesh/` | Orchestrator + 13 agents + policy-as-code + connectors | Engineering |
| `cadence/` | Scheduling/trigger config for the 5 loops | Orchestrator owner |
| `stakeholder-views/` | Per-role dashboard/digest configs | Platform team |
| `assets/` | Logo and favicon files served by the published site | Brand/design owner |
| _(external)_ `Getamazednow AI Design System v1.2/` | Brand tokens, templates and logo files. **Vendored locally, deliberately not committed** — this repo is public and the design system is not published with it. Obtain it from the design-system master repo and place it at the project root before producing artefacts. See `Design-System-Localisation.md`. | Brand/design owner |
| `Design-System-Localisation.md` | Project-specific localisation of the design system (artefact names, version/status, colour remap) | Brand/design owner |
| `infra/` | Deployment IaC for the mesh | Platform team |
| `tests/` | Unit/integration tests for agents and policy gates | Engineering |

## The five loops

Daily (Sense) → Weekly (Review) → Monthly (Adjust) → Quarterly (Realign) → Yearly (Reset).
Signal flows up, constraints flow down. See the whitepaper §3 for full detail.

## Adoption phasing

This repo is intended to be built out bottom-up, matching the whitepaper's adoption roadmap:
Phase 1 Daily+Weekly → Phase 2 +Monthly → Phase 3 +Quarterly → Phase 4 +Yearly.
Do not scaffold agents ahead of the phase you are actually running.

## Repo automation

Governance isn't a document here — it's enforced by two scripts, both driven by the single
source of truth `config/repo-governance.yml`.

| Script | When | What it does |
|---|---|---|
| `scripts/bootstrap-repo.sh` | **Post-push** — once after your first `git push`, and again whenever `config/repo-governance.yml` changes | Applies branch protection (required status checks + CODEOWNERS review) to `main`, creates/updates labels, and checks that every team referenced in CODEOWNERS actually exists — it warns rather than silently creating people-teams |
| `scripts/pre-pr-check.sh` | **Pre-PR** — run locally before opening a PR (or auto-run via a git hook) | Fails the push if a commit touching `artefacts/**` is missing its provenance fields (data source / policy version / prior decision); previews which CODEOWNERS group will be required to review; runs tests if a test suite exists |
| `scripts/install-hooks.sh` | Once, per clone | Wires `pre-pr-check.sh` in as a `pre-push` git hook so it runs automatically |

**Setup:**

1. Edit `config/repo-governance.yml` — replace `repo.owner` (`<github-org-or-user>`) with your
   real GitHub org/username, and adjust `teams` if your review-group names differ.
2. `./scripts/install-hooks.sh` — makes `pre-pr-check.sh` run automatically before every push.
3. After your first `git push`, with the [GitHub CLI](https://cli.github.com) installed and
   authenticated (`gh auth login`) with admin rights on the repo: `./scripts/bootstrap-repo.sh`.

Both scripts were dry-run tested against a scratch repo (provenance pass/fail cases, CODEOWNERS
path resolution, and a stubbed `gh` for the branch-protection payload) before being added here.
