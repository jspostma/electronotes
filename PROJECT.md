# Electronotes LLM — Project Summary

## Goal

Build a centralized, searchable knowledge base for the Electronotes publication archive. The LLM/RAG query interface is one layer on top — the deeper goal is a well-structured digital archive that has been a long-term personal project. There is an existing online community with interest in this material; the project should eventually be open to others.

**Human editing and refinement of machine-produced output is as much a goal as building the knowledge base itself.** Machine OCR, metadata extraction, and figure detection are starting points, not finished products. The platform needs to make it easy for humans to correct, annotate, and verify that output — and to track what has been human-verified vs. machine-generated.

## Desired features

### Phase 1 — Core archive (personal use)
- [ ] Full-text search across all Electronotes content (newsletters, app notes, webnotes, MEH, supplements)
- [ ] Article and issue browser with metadata (issue number, date, volume, author, article titles)
- [ ] Linked figure/schematic viewer — OCR text alongside original scan page
- [ ] Q&A interface via RAG + Ollama (web UI and CLI)
- [ ] Provenance tracking per page/chunk: source file, OCR method, confidence, human-verified flag
- [ ] Unified canonical index: all articles across all publications, consolidated from existing partial indexes, in human-editable Git-friendly format
- [ ] Subject/topic tagging system: extend EN96 YAML subject index forward through all volumes; component/IC tag layer

### Comprehensive unified index
A key goal alongside the knowledge base is a single canonical index consolidating all existing index sources into one consistent, extensible structure. Several partial indexes already exist in different formats with different coverage (see Key Reference Files). The unified index should cover:

- Every article in every publication: title, author(s), issue/AN number, page, date, volume
- Subject/topic tags per article (extending the EN96 YAML subject index forward through all volumes)
- Cross-references between articles (continuations, corrections, related topics)
- Errata (the wiki index has many; others exist in the archive)
- Availability status: in archive, format, OCR status, scan quality
- Component/IC mentions as a secondary tag layer (CA3080, LM13700, CEM3340, etc.)

**Existing index sources to consolidate** (see INVENTORY.md for detail):
- `electronotes_indices_wiki.txt` — most complete for article-level data; has dates, authors, errata, web availability
- `index/Electronotes_EN_index.txt` + `full.txt` + `index.json` — article titles and page numbers, all volumes
- `index/stinchombe-index.json` — volume date ranges
- `index/appnotes.csv/.tsv` — app notes index
- `index/subjects/index/*.yaml` — A–Z subject tagging with cross-references and comments, **covers only 1972–1978 (through EN96)**; needs extending forward through all volumes
- `EN96_index.csv` — published index through EN96

Extending the subject tagging beyond EN96 is inherently a human task and a natural entry point for community contribution. The tagging vocabulary from the EN96 index provides a controlled starting point that can be extended.

**Format**: the unified index should live as human-editable, Git-friendly files (YAML or structured JSON), one file per volume or per series, not in a database. The database is built from it, not the other way around.

### Phase 2 — Human editing layer
- [ ] OCR correction interface: scan image and extracted text side by side, editable
- [ ] Metadata editing: issue, date, author, article titles, page numbers
- [ ] Figure annotation: add descriptions/captions to extracted image crops
- [ ] Equation editing: correct or add LaTeX for math regions
- [ ] Verification workflow: mark content as human-reviewed; track who reviewed what
- [ ] Errata/notes: attach corrections or commentary to specific pages or articles (the wiki index has many errata worth preserving)

### Phase 3 — Community / open access
- [ ] Multi-user access with contribution tracking
- [ ] Public read access, authenticated write/edit access
- [ ] Export of cleaned content in open formats (plain text, markdown, JSON)
- [ ] API for programmatic access to the archive
- [ ] Gap tracking: what issues/ANs are missing, what needs better scans or OCR

### Future enhancements
- [ ] LaTeX equation extraction (Nougat / LaTeX-OCR / Mathpix) — see notes below
- [ ] Vision LLM captioning of figure crops
- [ ] Cross-reference linking (articles that cite or continue other articles)
- [ ] Component/IC index (all mentions of CA3080, LM13700, etc. across the archive)
- [ ] Author index across all publications

## Core design principle: the interface is the translator

Machine output (GCV JSON, Marker markdown, layout detection) is too dense for a human to parse directly — but human verification is essential because machine output has errors, gaps, and ambiguities. The solution is not to make humans parse machine formats. The interface must translate between them.

A concrete example: the GCV JSON for every scanned issue contains full bounding box geometry that reveals exactly where figures are — but this was invisible until examined programmatically. The right interface would show the scan with coloured overlays (green = high-confidence text, yellow = low-confidence, red = unparsed region) making figure locations and OCR quality immediately obvious without touching any JSON.

The workflow should be:
```
Machine output  →  Interface  →  Human attention (focused on uncertainty)  →  Structured corrections
(dense, opaque)    (translates)   (what the machine got wrong or missed)       (readable, versioned)
```

**The interface should surface what needs attention**, not present everything equally:
- Low-confidence OCR regions flagged for review
- Missing or incomplete metadata
- Uncaptioned figures
- Pages not yet human-verified
- Equations that need LaTeX

Humans should never need to touch raw JSON, bounding box coordinates, or confidence scores directly. Those inform the interface; they are not the interface.

## Design implications of community/editing goals

These goals affect fundamental architecture choices:

**Storage format must be human-editable and version-controllable.** Processed content should live as plain text/markdown/YAML files in a Git repository, not locked in a database. The database (ChromaDB or similar) is an index built *from* those files, not the source of truth. This means corrections made by humans automatically flow into the next index rebuild.

**Provenance must be tracked at the page/chunk level.** Every piece of content needs metadata recording: OCR method used (GCV/Marker/Tesseract/human), confidence score where available, human-verified flag, last editor, date. This lets the system surface low-confidence content for review and lets users trust high-confidence content.

**The scan is always the ground truth.** The web interface must make it trivial to view the original scan page alongside any extracted text. Editors need to be able to compare them without leaving the interface.

**The flask_ocr_viewer project** (`projects/flask_ocr_viewer/`) was already moving in this direction — a Flask app for browsing OCR output with a database backend. Worth reviewing when designing the editing interface.

## Approach: RAG, not fine-tuning

Not fine-tuning (modifying model weights) — that requires significant GPU resources, expertise, and doesn't reliably inject factual knowledge anyway. The right approach is **RAG (Retrieval-Augmented Generation)**:

1. Extract and clean text from all archive content
2. Chunk text with rich metadata (issue, date, author, topic, page)
3. Embed chunks into a vector database (ChromaDB)
4. At query time, retrieve relevant chunks and feed them to an LLM as context
5. LLM answers grounded in actual source material

## Stack

| Component | Tool | Notes |
|---|---|---|
| LLM | Ollama (existing, `10.33.0.10:11434`) | Server: Ryzen 5 5600X, 64GB RAM, RTX 2080 Super (8GB VRAM) |
| Embeddings | nomic-embed-text via Ollama | Small, fast |
| Vector DB | ChromaDB | Co-located on server, Docker |
| Web interface | Open WebUI | Docker, same server — not yet installed |
| CLI interface | Python script | Thin client, talks to same ChromaDB + Ollama |
| OCR | GCV JSON (existing) + Marker (fallback) | See OCR strategy below |
| Ingestion | Python (TBD) | Pipeline: raw files → text + figures → ChromaDB |

## Figure/schematic handling

Document-level segmentation only — no caption association, no schematic-to-netlist parsing. For each processed document:

- Text regions → OCR → indexed chunks
- Non-text regions (schematics, graphs, diagrams) → cropped image files, referenced inline (`[figure: p05_fig1.png]`)
- Original scans always the authoritative source
- Vision LLM captioning is a future enhancement, not a first-pass requirement

Challenges specific to Electronotes: no borders around figures, captions/labels same font and size as body text, 1970s mimeo/offset printing. Component labels (`R1`, `33k`, `1N914`) and figure numbers (`FIG. 2`) are detectable patterns.

## OCR strategy

The archive naturally splits into two groups:

**Group 1 — Has GCV JSON (~24 EN issues + full MEH):**
- Extract body text from high-confidence, wide blocks
- Use bounding box geometry to detect figure regions (see below)
- Crop figures from source TIFFs
- No need for Marker on these

**Group 2 — Everything else:**
- Run Marker on ScanTailor-processed `pages/` TIFs where available, raw TIFs otherwise
- Marker handles both text extraction and figure cropping in one pass
- Test Marker on one issue that also has GCV JSON to validate quality before committing to a full run
- If Marker quality is insufficient, a new Google Cloud account for GCV is cheap (~$1.50/1000 pages, ~$10–12 for the full remaining archive) and worth considering

**GCV vs Marker:**
- GCV: proven on this content, excellent on degraded printing, rich bounding box data, requires external account
- Marker: local, free, native figure extraction, unknown performance on 1970s mimeo — must test
- Consistency across OCR methods doesn't matter for RAG as long as text is clean
- Don't run both on the same content — redundant for this use case

### GCV JSON structure (examined EN73, MEH)

Sent to GCV as multipage TIFFs via GCS (`gs://electronotes.timegoat.org/`, now defunct). Response structure:
```
data
├── inputConfig  (source URI, mimeType)
└── responses[]  (one per page)
    └── fullTextAnnotation
        ├── text        (full page plain text)
        └── pages[]
            └── blocks[]
                ├── blockType    (always TEXT — GCV doesn't detect figure regions)
                ├── confidence   (0.0–1.0)
                ├── boundingBox  (pixel vertices, 4 corners)
                └── paragraphs[] → words[] → symbols[]
```

EN73 overall confidence: avg **0.886**. Solid on plain text; degrades on math notation and schematic labels.

### Figure detection from GCV bounding boxes

GCV doesn't label figures, but geometry reveals them:
- **Body text blocks**: near-full page width, high confidence (>0.95)
- **Figure regions**: dense clusters of small scattered blocks, variable confidence — component labels, pin numbers, figure numbers, values
- Gap between body text regions = figure region → crop from TIFF

## Archive content

See `electronotes_indices_wiki.txt` for the authoritative article-level catalog (from sdiy.info).

| Series | Total known | In archive | Notes |
|---|---|---|---|
| Newsletter (EN) | 229 issues, 24 volumes, 1972–~2012 | ~60 scanned; EN191–229 as PDFs | EN1–190 paper-only; EN191+ free online |
| Application Notes (AN) | 432 total | 117 scanned TIFs + ~115 PDFs | AN363+ free online; large gap AN118–362 |
| WebNotes (WN) | 61+ | 58 PDFs | Nearly complete |
| Supplements (S) | S1–S19 | S-007, 008, 014–017, 019 | Only S14–S17 still available from publisher |
| Mid-Month Letters | ~22 years | By year: 70-A through 91-A | |
| Musical Engineer's Handbook | 1 book | **Complete**: 376 PNM scans (600dpi, by section) + full GCV JSON (51 files, 376 pages) + Tesseract PDF (2019, superseded) | Written 1975 |
| Builder's Guide & PCC | 1 book | Physical copy only, not scanned | Reprint anthology of EN/AN content; unique item: Thomas Henry "Making rack panels" (1981). Complete scan on Archive.org (`electronotes-meh-ebgpcc-torrent`) |
| Theory & Practice of Musical Sound Synthesis | Ch. 1–2 (partial, online free) | 5 PDFs (TOPOMSS-Ch1, Ch2a–Ch2d), 70 pages, downloaded 2012 | Scanned images, need OCR |
| AES Papers | 6 | All 6 present (9 files; AES2, AES3, AES5 have duplicate copies with descriptive names) | |
| Total | ~9,000 pages | | Per Bernie Hutchins |

## Key gaps

- **Application Notes have zero OCR coverage** despite being the largest single series (432 total). 117 are scanned as TIFs with `pages/` directories ready for Marker, but no text has been extracted from any of them. They are short, self-contained, and technically dense — ideal RAG source material. Closing this gap should be a high priority after the EN issues.
- **EN1–EN72** (Volumes 1–8, 1972–1976): almost none scanned — earliest and most historically significant issues
- **Volumes 16 and 18**: not present in `regular issues/by-volume/` at all
- **AN118–AN362**: gap between scanned ANs (~AN1–117) and free online ANs (AN363+)
- **AN363–AN432**: free on electronotes.netfirms.com, not yet downloaded
- **Metadata**: hand-compiled, inconsistent across issues; only 24 issues have `metadata.yaml`

## File organization

```
electronotes/
├── regular issues/by-volume/   # Volumes 5,8-15,17,19-24 (EN35–EN229)
│   └── ENxxx/
│       ├── metadata.yaml        # Hand-compiled, inconsistent — only 24 issues
│       ├── ENxxx.tiff           # Raw multipage scan
│       ├── ENxxx.pdf            # PDF (variable quality)
│       ├── ENxxx-ocr.json.gz    # GCV JSON — best text source where present
│       ├── pages/               # ScanTailor-processed per-page TIFs (preferred for Marker)
│       └── scans/               # Raw scan TIFs (300dpi and/or 600dpi)
├── app notes/
│   ├── scanned/ANxxx/          # 117 scanned app notes (per-page TIFs)
│   ├── downloaded/             # ~104 PDFs
│   └── old/                    # 11 older PDFs
├── scans/appnotes/             # 117 multipage TIFs (AN1–AN117 area)
├── scans/mmletters/            # Mid-month letters scan
├── mmletters/                  # By year: 70-A through 91-A
├── supplements/                # S-007, S-008, S-014–S-017, S-019
├── web-notes/                  # 58 PDFs (ENWN1–ENWN58+)
├── books/
│   ├── musical-engineers-handbook/
│   │   ├── MEH-ocr.pdf          # Tesseract 4 OCR, 381 pages (superseded by GCV)
│   │   └── scans/
│   │       ├── MEH/json/        # 51 GCV JSON files, all 376 pages
│   │       └── electronotes-musical-engineers-handbook-xsane-scans/
│   │           └── [frontmatter, section1–9, index]/  # 376 PNM files, 600dpi
│   └── Theory and Practice of Musical Sound Synthesis/
│       └── TOPOMSS-Ch1.PDF, Ch2a–Ch2d.PDF  # 70 pages, need OCR
├── papers/                     # 9 files = 6 AES papers (3 have duplicate named copies)
├── perspectives/               # 3 PDFs
├── index/
│   ├── Electronotes_EN_index.txt    # Tab-separated article index, all volumes
│   ├── full.txt                     # Similar, slightly different format
│   ├── index.json                   # JSON version
│   ├── stinchombe-index.json        # Tim Stinchcombe's index (CouchDB format)
│   ├── appnotes.csv / .tsv / .ods   # App notes index
│   └── subjects/index/              # A-Z YAML subject index from EN96 (1972–1978)
└── unsorted/
```

## Scanning workflow (reconstructed from scripts)

Per-issue `pages/` directories were produced by:

1. **XSane** → raw multipage TIFF → `scans/` (300 or 600dpi)
2. **ScanTailor** → deskew, despeckle, crop → per-page TIFs → `scans/out/`
3. **`rename.sh`** → move from `scans/out/` to `pages/`, strip dpi prefix, clean up
4. **`process.py`** / **`projects/scantailor2pdf/main.py`** → assemble `pages/*.tif` into PDF via PyMuPDF

`pages/` TIFs are preferred over raw `scans/` for Marker input. Only volumes 5, 8–15, 17, 19–24 have `pages/` directories.

The MEH used XSane directly to PNM per section (no ScanTailor pass documented).

## Past project attempts

All in `projects/` directory. External services (CouchDB, GCS) are gone; code is preserved.

- **`google-ocr/get_ocr.py` + `get_ocr2.py`** — The GCV OCR pipeline. `get_ocr2.py` is the final version: takes a raw multipage TIFF, uploads to GCS, runs async `DOCUMENT_TEXT_DETECTION`, downloads and gzip-compresses results. This produced all the `.json.gz` files in the archive. Credentials defunct.
- **`electronotes_index/`** — Data model classes: `Issue`, `Article`, `AppNote`, `Author`. Well-designed schema; reference when designing ingestion pipeline.
- **`electronotes-couchdb/` + `electronotes_timegoat_org/`** — Two iterations of a CouchDB-backed Flask web app. `timegoat_org` was more complete (authors, content, docs, files, watcher, DocumentClasses modules). Database gone, architecture preserved.
- **`scantailor2pdf/main.py`** — Polished CLI version of `process.py` with argparse and dry-run mode.
- **`ENDoc/checkmd.py`** — Validates `metadata.yaml` files with colour-coded pass/fail output.
- **`flask_ocr_viewer/`** — Flask app for browsing OCR results with database backend.
- **`layoutparser/`** — Venv only; Facebook's LayoutParser was going to be tried for layout analysis, never got further.
- **`en_docai/`** — Google Document AI experiment, incomplete.
- **`llama/llama.py`** — Working Ollama + vision model experiment. Uses Python `ollama` client, connects to `10.33.0.10:11434`. Proves the Ollama connection pattern works; test images were personal photos.

## Key reference files

- `INVENTORY.md` — Detailed content inventory: every publication type, format, OCR status and source, coverage gaps
- `electronotes_indices_wiki.txt` — Article-level catalog from sdiy.info: all 229 issues, 432 ANs, supplements, webnotes, AES papers, with dates, authors, page numbers, errata
- `electronotes_wiki.txt` — General Electronotes overview from sdiy.info
- `electronotes/index/subjects/` — A-Z YAML subject index transcribed from EN96 (covers 1972–1978)
- `electronotes/EN96_index.csv` — CSV version of the EN96 published index

## External sources

- **Archive.org `electronotes-meh-ebgpcc-torrent`** — Complete scan of MEH (redundant) and Builder's Guide & PCC (useful — saves scanning physical copy). Tesseract 5 OCR. BG&PCC searchable PDF worth downloading.
- **Wayback Machine** — electronotes.netfirms.com snapshots exist; worth manually browsing for cached newsletter PDFs. Automated access blocked.
- **electronotes.netfirms.com/free.htm** — EN191+, AN363+, all webnotes available as free PDFs directly from publisher.

## Equation/LaTeX extraction (future phase)

Electronotes content is mathematically dense — transfer functions, filter design equations, Fourier analysis, s-plane notation. Converting this to LaTeX would significantly improve RAG quality and long-term archival value.

**What's realistic:**
- Displayed/block equations: good — clear boundaries, Nougat handles these well
- Inline math mixed with body text: hard — requires detecting math spans first
- Fractions with horizontal rules: moderate — Nougat better than GCV/Tesseract
- 1970s typewriter approximations of math (slashes for fractions, spelled-out Greek): difficult, case by case
- Schematic component labels (`R1`, `10kΩ`, `0.1µF`): easy — pattern matching, not math OCR

**Tools:**
- **Nougat** (Meta, open source, GPU) — neural parser for scientific documents, outputs markdown + LaTeX math. Test alongside Marker when processing begins; they may complement each other.
- **LaTeX-OCR / pix2tex** (open source) — takes cropped equation image, outputs LaTeX. Good for isolated displayed equations.
- **Mathpix** (commercial API) — best quality for mixed inline/display math, handles ambiguous notation well.

**Design implication:** figure/equation crops must be saved generously enough to capture full equations, so a future LaTeX pass doesn't require reprocessing scans. The human editing layer (Phase 2) should include an equation editor so humans can correct or supply LaTeX where automated tools fail.

## Development approach

Data exploration is a consistent stumbling point when datasets grow beyond what fits in a page or two of terminal output. The pipeline and inspection tooling need to be developed together — every processing step should come with a way to sanity-check its output at human scale before moving on.

**Practical tools:**
- **Jupyter notebooks** for exploration and one-off analysis — interactive, persistent output, easy to rerun individual cells
- **Rich** (Python library) for readable terminal output — coloured tables, truncated summaries, progress bars; turns walls of JSON into navigable output
- **Summary-first scripts** — every processing step produces a stats report (pages processed, confidence distribution, figure regions found, gaps) before any individual results are examined
- **Focused inspection tools** — "show me page 7 of EN85", "show me all low-confidence blocks", "which issues have no detected figure regions" — targeted queries rather than scrolling

**The rule:** never write a processing script without also writing the thing that tells you whether it worked.

The GCV JSON is a concrete example of this problem: the bounding box data revealing figure locations was always there, but invisible until examined programmatically. A simple confidence-overlay visualization of any scan page would have made it obvious immediately.

## Open questions

- Deduplication strategy when multiple versions of the same issue exist (online PDF + personal scan + downloaded copy)
- Whether to download remaining free content from electronotes.netfirms.com before building ingestion pipeline
- Whether to download BG&PCC from Archive.org or defer
