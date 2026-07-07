# Governance model

This repo's branch protection and review rules are the enforcement mechanism for the
operating model described in `/docs/whitepaper`. Each cadence maps to a control below.

| Cadence | Repo control | Human checkpoint |
|---|---|---|
| Daily | Required CI check: policy-as-code gate (`gate-agent`) on every PR | Alert-only, on breach |
| Weekly | CODEOWNERS review from Solution Architects on `artefacts/landscape-maps`, `artefacts/architecture-assessments` | Architect/Eng Manager sign-off |
| Monthly | CODEOWNERS review from Product Owners on `artefacts/asset-portfolios`, `artefacts/asset-roadmaps` | PO approval, not just merge |
| Quarterly | Protected branch + required review from `@general-managers` `@risk-committee` on `artefacts/architecture-principles`, `artefacts/capability-maps`; tag a quarterly release | Architecture Board / Risk Committee decision |
| Yearly | Protected branch + required review from `@cxo` on `artefacts/ea-blueprint`, `artefacts/strategy-whitepapers`; tag an annual release | CxO strategy offsite decision |

Every merge to an artefact path must carry, in the PR description: data source, policy/principle
version referenced, and the prior decision it builds on. PRs missing provenance should be
blocked by the `provenance-check` workflow, not by reviewer memory.
