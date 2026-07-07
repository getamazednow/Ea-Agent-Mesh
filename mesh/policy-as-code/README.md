# Policy-as-code

Rules enforced by the Gate Agent against every PR, IaC template, and cloud deployment.
Recommend a declarative rule engine (e.g. OPA/Rego, or equivalent) so rules are versioned,
testable, and diffable — each rule change is itself a PR with its own provenance trail.
