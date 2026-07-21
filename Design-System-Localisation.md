# EA Agent Mesh — Design System Localisation

> This note localises the portable **Getamazednow AI Design System v1.2** (see `Getamazednow AI Design System v1.2/LOCALISE.md`) for the **EA Agent Mesh Operating Model** project. Brand tokens are consumed unchanged; only the points below are project-specific. The design-system folder itself stays byte-identical to the master — do not edit it.

>
> **Sourcing:** this repo is **public**, so the design-system folder is **gitignored and never committed here**. Its master lives in its own repository. Clone/copy it to the project root before producing artefacts; re-sync from the master, never edit in place.

## 1. Artefact / product name

**Assure Architect** (product) · *Agentic EA Operating Model* (artefact set) — a multi-cadence agent mesh for continuous Enterprise Architecture governance (Daily · Weekly · Monthly · Quarterly · Yearly).

Shown as:

- Web topbar: `Getamazednow AI · Assure Architect` — published at `mesh.getamazednow.ai`
- Running headers: `Getamazednow AI · Agentic Enterprise Architecture · EA Agent Mesh <version>`
- Covers: the artefact title beneath the full-colour logo lockup.

Artefacts in scope:

- **Whitepaper (DOCX)** — `docs/whitepaper/Agentic-EA-Whitepaper.docx` — whitepaper cover variant **W2 (framed lower hero)**.
- **Deck (PPTX)** — `docs/deck/Agentic-EA-Operating-Model.pptx` — presentation masters **P1 (centred)** for title/section/closing, light content slides.
- **Live page (HTML)** — `index.html` (repo root, GitHub Pages source) + `docs/visualization/…`, serving `mesh.getamazednow.ai`. Logo/favicon files are vendored into `assets/` so the published site does not depend on the gitignored design-system folder.

## 2. Version + status

Current cycle: **v1.1 → v1.2** (brand system upgraded from the deleted flat `design-system/` folder to `Getamazednow AI Design System v1.2/`).

Status line on every cover/footer: **FOR PEER REVIEW**. Version lives inside the document (cover + footer), not in file/folder names.

## 3. Legacy colour remap

The DOCX was already built on the brand palette (Ink, signalDeep, neutrals, semantics) — no remap needed there. The **deck (PPTX)** carried a legacy Office navy and default fonts, remapped as follows:

| Legacy | → | Getamazednow AI | Meaning |
|---|---|---|---|
| `2A3B60` (navy) | → | `2A363B` | dark surface / title fill → **Ink** |
| `Calibri Light` | → | Poppins | display / titles → **Poppins** |
| `Calibri` | → | Inter | body / tables / captions → **Inter** |
| `Cambria` | → | Poppins | legacy serif headings → **Poppins** |

On-Ink semantic tints already present in the deck are **correct v1.2 tokens** and were kept unchanged: success `6FBF8B`, warning `E3A253`, error `E08585`, info `7FB3C2` (`semantic.*.lightOnInk`); accent Signal `5FA8CC`; Stone `A8A17B`.

Fonts overall: legacy `Calibri / Calibri Light / Cambria` → **Poppins** (display/heading) / **Inter** (body).

## 4. Reference implementation

- Whitepaper cover W2: `Getamazednow AI Design System v1.2/Getamazednow_AI_Whitepaper_Template_W2.docx`
- Presentation P1/P2: `Getamazednow AI Design System v1.2/Getamazednow_AI_Presentation_Template.pptx`
- Cover backdrop artwork drop zone: `docs/assets/covers/` (see its README) — populated in the next pass, then the brand skill is re-run to place backgrounds only.

---

*Source of truth for brand + application rules: `Getamazednow AI Design System v1.2/` (`design-tokens.json`, `Artefact-Application-Spec.md`, `LOCALISE.md`). This note localises it for **EA Agent Mesh** only.*
