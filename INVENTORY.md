# Electronotes Archive — Content Inventory

## Regular Issues (EN)

| Group | Issues | Format | OCR | Quality |
|---|---|---|---|---|
| **Personally scanned** | 24 issues (selected from vol. 5, 8–15, 17, 19–24) | Raw TIFF + ScanTailor-processed per-page TIFs + assembled PDF | **GCV JSON** (gzip) | Best available — proven avg 0.886 confidence, rich bounding box data |
| **PDF only** (online-sourced, vol. 22–24) | ~40 issues (EN205–EN229) | PDF only, no scans | **Embedded Tesseract** via ocrmypdf, or native (Word 2007 creator = likely natively digital) | Variable — natively digital PDFs need no OCR; scanned-to-PDF quality unknown |
| **Partial coverage** (older volumes) | ~20 issues (EN35–EN72 area) | TIFF or PDF only, no GCV | None or embedded | Low — no GCV, some may have no OCR at all |
| **Not in archive** | ~145 issues (EN1–EN34, vol. 6, 7, 16, 18 entirely, gaps elsewhere) | — | — | Missing |

**Total of 229 known issues; ~84 present in archive in some form. 24 well-covered (scans + GCV JSON + metadata).**

### Scanned issues — detail

Each of the 24 well-covered issues has:
- `ENxxx.tiff` — raw multipage scan (300dpi or 600dpi depending on volume; vol. 10 has both)
- `pages/` — ScanTailor-processed per-page TIFs (deskewed, despecked, cropped) — preferred input for Marker
- `scans/` — raw scan TIFs
- `ENxxx-ocr.json.gz` — GCV DOCUMENT_TEXT_DETECTION output, one response per page, includes full bounding box geometry at block/paragraph/word/symbol level
- `ENxxx.pdf` — assembled PDF (Tesseract OCR via ocrmypdf)
- `metadata.yaml` — hand-compiled, inconsistent quality

---

## Application Notes (AN)

| Group | Count | Format | OCR | Quality |
|---|---|---|---|---|
| **Personally scanned** | 117 (AN1–AN117 approx.) | Per-page TIFs in `pages/` + raw multipage TIFF | **None** | Scans exist, no text extracted yet |
| **Downloaded PDFs** | 104 | PDF | Mixed: ~62 native Word 2007 (digital), ~15 Sprint, ~4 Tesseract, ~20 unknown | Natively digital ones are clean; others variable |
| **Old PDFs** | 11 | PDF | Sprint (5), Tesseract (5), unknown (1) | Variable |
| **Not in archive** | ~200 (AN118–AN362) | — | — | Large gap |
| **Free online, not yet downloaded** | 70+ (AN363–AN432) | PDF on electronotes.netfirms.com | Likely natively digital | Not yet retrieved |

**AN "Sprint" creator** = print-to-PDF from a scanned source document; likely image-only, needs OCR.

---

## Musical Engineer's Handbook (MEH)

| Format | OCR | Quality |
|---|---|---|
| 376 PNM scans at 600dpi, organized by section (frontmatter, sections 1–9, index) | **GCV JSON** — 51 JSON files covering all 376 pages | Best available — same pipeline as scanned EN issues |
| `MEH-ocr.pdf` — 381 pages | Tesseract 4 via ocrmypdf (2019) | Superseded by GCV; usable as fallback |
| `MEHCh6aPart.PDF`, `MEHPWM.PDF`, `Scales-MEH.PDF` | Unknown | Specific chapter excerpts downloaded from official site |

**Most complete and best-documented item in the archive. GCV JSON + 600dpi PNMs = ideal processing starting point.**

---

## WebNotes (ENWN)

| Count | Format | OCR | Quality |
|---|---|---|---|
| 58 PDFs (ENWN1–ENWN58) | Native digital PDF (Word 2007: 50, Word 2016: 7, LibreOffice Writer: 1) | **None needed** — natively digital | Excellent — authored digitally, no OCR required |

~3 issues missing (ENWN59+). Easiest content to process — text extraction only, no OCR pipeline needed.

---

## Theory & Practice of Musical Sound Synthesis (TOPOMSS)

| Format | OCR | Quality |
|---|---|---|
| 5 PDFs (Ch1, Ch2a–Ch2d), 70 pages total, downloaded 2012 | **None** — scanned image PDFs | Needs OCR; no GCV JSON, no source TIFs available |

Only chapters 1 and 2 were released publicly. Remaining chapters (if they exist) were never published online.

---

## AES Papers

| Format | OCR | Quality |
|---|---|---|
| 9 PDF files = 6 unique papers | Sprint (all 9) | Likely image-only PDFs; need OCR |

Duplicates: AES2, AES3, AES5 each have two copies (one with descriptive filename, one without — identical content). Papers:
- AES1: Experimental electronic music devices employing Walsh functions (Oct 1973)
- AES2: Application of a real-time Hadamard transform network to sound synthesis (Sep 1975)
- AES3: The frequency modulation spectrum of an exponential VCO (Apr 1975)
- AES4: Animation (Nov 1981)
- AES5: Adapting delay comb filter (Jan/Feb 1982)
- AES6: Simple hardware pitch extractor (Mar 1982)

---

## Supplements

| Item | Format | OCR | Notes |
|---|---|---|---|
| S-007 | PDF (downloaded) | Unknown | Digivox user's guide (Dec 1972) |
| S-008 | PDF (downloaded) | Unknown | Hybrid voltage-controlled digital EM systems (Dec 1972) |
| S-014 | TIFF (scanned) | **None** | New approaches to analog music synthesis (Jun 1977) |
| S-015 | TIFF (scanned) | **None** | Transform methods in musical engineering (Jul 1977) |
| S-016 | PDF + TIFF + OCR PDF | **Tesseract** (ocrmypdf) | Laboratory problems and examples (1978) — has existing OCR pass |
| S-017 | TIFF (scanned) | **None** | Literature evaluation LE-1 to LE-10 (1977) |
| S-019 | PDF (downloaded) | Unknown | Log and exponential circuits (Spring 1981) |
| S-001–006, 009–013, 018 | — | — | Not in archive |

---

## Mid-Month Letters

| Format | OCR | Quality |
|---|---|---|
| 26 yearly bundles (70-A through 96-A), each ~2 pages, per-page TIFs in `pages/` + `metadata.yaml` | **None** | Scans exist, no text extracted |

These appear to be scanned pages. Each year is a single letter/bulletin. No OCR done on any of them.

---

## Books — Builder's Guide & Preferred Circuits Collection (BG&PCC)

| Format | OCR | Notes |
|---|---|---|
| Physical copy only — not scanned | — | Complete scan + Tesseract 5 OCR available on Archive.org (`electronotes-meh-ebgpcc-torrent`, uploaded May 2022). Worth downloading rather than scanning. One unique item not in other publications: "Making rack panels" by Thomas Henry (1981). |

---

## OCR Status Summary

| Status | Content |
|---|---|
| **GCV JSON (best)** | 24 EN issues, full MEH (376 pages) |
| **Natively digital PDF (excellent)** | All 58 WebNotes, ~62 downloaded ANs, vol. 22–24 EN issues authored in Word |
| **Tesseract OCR (adequate)** | MEH-ocr.pdf (superseded by GCV), S-016, ~9 downloaded ANs, vol. 10 EN PDFs |
| **Scanned TIFs, no OCR yet** | 117 ANs, 26 mid-month letter years, S-014/015/017, TOPOMSS chapters |
| **Sprint/unknown PDF** (likely image-only, needs OCR) | ~35 downloaded ANs, all 9 AES papers, S-007/008/019 |
| **Not in archive** | EN1–EN34, vol. 6/7/16/18, AN118–362, most supplements, ENWN59+ |

## Coverage by publication type

| Series | Total known | In archive | Well-covered | Missing |
|---|---|---|---|---|
| Newsletter (EN) | 229 | ~84 | 24 | ~145 |
| Application Notes (AN) | 432 | ~232 | 0 (none with GCV) | ~200 |
| WebNotes (ENWN) | 61+ | 58 | 58 (natively digital) | 3+ |
| Supplements (S) | 19 | 7 | 1 (S-016) | 12 |
| Mid-Month Letters | ~27 | 26 | 0 (no OCR) | 1 |
| MEH | 1 | 1 | 1 (full GCV) | 0 |
| BG&PCC | 1 | 0 (physical only) | 0 | — |
| TOPOMSS | partial | 1 (Ch1–2) | 0 (no OCR) | remaining chapters |
| AES Papers | 6 | 6 | 0 (Sprint, needs OCR) | 0 |
