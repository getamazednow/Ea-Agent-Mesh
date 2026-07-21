# Design Changelog — Getamazednow AI Design System

Tracks brand/design-system changes to the repo's artefacts. Authoritative brand rules live in `Getamazednow AI Design System v1.2/` (`design-tokens.json`, `Artefact-Application-Spec.md`); project-specific choices live in `Design-System-Localisation.md`.

## 2026-07-15 — Migrate to Design System v1.2

### Folder changes

**Removed** the former flat brand folder `design-system/` (superseded). Contents that no longer exist at the old paths:

| Removed path | Replaced by (in `Getamazednow AI Design System v1.2/`) |
|---|---|
| `design-system/README.md` | `LOCALISE.md` + `Artefact-Application-Spec.md` |
| `design-system/brand/Getamazednow_AI_Brand_Design_System.docx` | `Getamazednow_AI_Brand_Design_System.docx` |
| `design-system/logo/` (14 logo/favicon files) | `Logo Files/` (adds hero-lattice, slide-BG, and v1.2 containment-keyline variants) |
| `design-system/templates/Getamazednow_AI_Presentation_Template.pptx` | `Getamazednow_AI_Presentation_Template.pptx` |
| `design-system/templates/Getamazednow_AI_Report_Template.docx` | `Getamazednow_AI_Report_Template.docx` |
| `design-system/tokens/design-tokens.json` | `design-tokens.json` |
| `design-system/tokens/tokens.css` | `tokens.css` |

**Added** in v1.2 (not present in the old folder): whitepaper cover templates `…_Whitepaper_Template_W1.docx` / `…_W2.docx`, logo containment-keyline variants (`…-Icon-Color-Keyline-Signal.svg` / `…-Keyline-Neutral.svg`), and hero/slide background art (`…-Hero-Lattice`, `…-Slide-BG-Ink`).

**References updated** to the new folder: `README.md` (repo map), `config/repo-governance.yml` (CODEOWNERS note + brand-design-owner scope).

**Added** `Design-System-Localisation.md` (project root) — localises v1.2 for EA Agent Mesh (artefact names, version/status = FOR PEER REVIEW, deck colour/font remap).

### Artefact changes applied

**`docs/whitepaper/Agentic-EA-Whitepaper.docx`** — was already on the brand palette (Ink, signalDeep, neutrals, semantics) with Poppins headings and a text running header/footer. v1.2 gaps closed:

- Added the full-colour **logo lockup** on the cover (2.2 in, top-left) with a signalDeep divider rule (§3).
- Added a **version + status** line: *"Version 1.2 · Status: FOR PEER REVIEW"* (status in warning `#A85A16`) (§3/§7).
- Added the **monochrome-Ink icon** to the running header beside "GETAMAZEDNOW AI" (§4).
- Set the default body font to **Inter** (headings remain explicit Poppins).
- Fixed the front-matter section (Contents / Executive Summary) to carry the branded running header/footer — it had been inheriting the cover's empty header. Cover itself stays header/footer-free (§4 different-first-page, achieved via section break).
- Cover variant recorded as **W2**.

**`docs/deck/Agentic-EA-Operating-Model.pptx`** — carried the brand on-slide over a default Office theme. Remap applied (see `Design-System-Localisation.md §3`):

- Legacy navy `#2A3B60` → **Ink `#2A363B`** (312 fills).
- Theme + on-slide fonts: `Calibri Light` → **Poppins** (theme major), `Calibri` → **Inter** (477 runs, theme minor), `Cambria` → **Poppins** (56 runs).
- On-Ink semantic tints kept unchanged (they are correct v1.2 `lightOnInk` tokens): success `#6FBF8B`, warning `#E3A253`, error `#E08585`, info `#7FB3C2`; accent Signal `#5FA8CC`; Stone `#A8A17B`.
- Title layout recorded as **P1 (centred)**; content slides on the light master.

## 2026-07-16 — Cover backdrops applied (full-bleed)

Backdrop artwork was supplied in `docs/assets/covers/` and applied as **full-bleed** covers (chosen over the W2 framed card):

**Whitepaper** (`docx/EAMeshCoverWhitePaper 1.png`) — full-page A4 background anchored behind the cover text (page-anchored, behind-text, scoped to the cover section only so page 2+ stay clean). Cover treatment switched to dark-surface reverse:

- Logo → **Color badge + Signal containment keyline** (`Getamazednow-AI-Icon-Color-Keyline-Signal`, §4) with white "Getamazednow AI" wordmark + stone byline.
- Text reversed for legibility on Ink: title → white; kicker/divider → Signal `#5FA8CC`; subtitle/metadata → neutral-200 `#D5DADB`; status word → warning-on-ink `#E3A253`.

**Deck** (`pptx/EAMeshCoverPPT 1.png`, the 16:9 option) — full-bleed title-slide background placed above the slide's decorative arcs and behind all text/pills, with a ~34% Ink scrim for contrast. Title text was already white/Signal, so it remained legible.

### Still open (optional — flagged for review)

- **Deck title/closing logo lockup**: the title slide has a full-bleed backdrop but still no Getamazednow logo mark (the whitepaper cover now has one). Per the golden rule, a Color-badge + Signal-keyline lockup top-left would complete it — deferred pending your view on placement.
- **Deck closing slide backdrop**: no closing image was selected; `deck-closing-bg.png` slot remains available.
- **Fonts**: install **Poppins** + **Inter** on rendering machines; without them Office substitutes Montserrat/Segoe UI and metrics shift (§1).
