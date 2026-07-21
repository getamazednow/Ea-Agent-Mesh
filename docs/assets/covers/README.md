# Cover backdrop artwork — drop zone

Place the cover **background images** here. On the next pass the `getamazednow-ai-brand` skill is re-run **only** to drop these behind the (already-aligned) cover of each artefact — no other restyle.

The artefacts are already brand-aligned to **Getamazednow AI Design System v1.2**; these images become the backdrop layer beneath the existing cover text and logo lockup.

## Where each file goes

| Folder | Artefact | Cover variant | File name to use |
|---|---|---|---|
| `docx/` | `docs/whitepaper/Agentic-EA-Whitepaper.docx` | **W2 · framed lower hero** | `whitepaper-cover-bg.png` |
| `pptx/` | `docs/deck/Agentic-EA-Operating-Model.pptx` | **P1 · centred (title slide)** | `deck-title-bg.png` |
| `pptx/` | closing slide (optional) | P1 closing | `deck-closing-bg.png` |

## Image specification (hybrid strategy, §7/§8 of the spec)

Keep images **dark-toned** or apply an **Ink (`#2A363B`) scrim** so the reversed logo and title stay legible. Signal `#5FA8CC` is the only accent. Avoid soft glows/halos (they band in print).

| Artefact | Aspect | Min pixels | Notes |
|---|---|---|---|
| Whitepaper W2 card | ~16:10 landscape | **1600 × 1000** | Sits in a framed card (radius 16, signalDeep hairline) anchored to the lower ~48% of the cover. Keep it dark; the title reads in the white space above. |
| Deck title P1 | 16:9 | **1920 × 1080** (2560 × 1440 preferred) | Full-bleed behind an Ink scrim. **Keep the centre calmer** — the title and lockup sit centred over it. |
| Deck closing P1 | 16:9 | **1920 × 1080** | Same treatment as the title slide. |

Formats: PNG (or high-quality JPG). Do not overwrite the design-system's own `Getamazednow-AI-Hero-Lattice` / `Getamazednow-AI-Slide-BG-Ink` — those remain the branded defaults if you drop nothing here.

## Next pass — what will happen

Once files are in place, re-running the brand skill will:

1. Whitepaper: insert `whitepaper-cover-bg.png` into the W2 framed card on the cover (behind the existing lockup, title and status line).
2. Deck: set `deck-title-bg.png` (and `deck-closing-bg.png` if present) as the full-bleed title/closing background with an Ink scrim, leaving all content slides on the light master.

Nothing else about the artefacts changes — fonts, colours, header/footer and content are already v1.2-aligned.
