# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Research & troubleshooting

You have `WebSearch` and `WebFetch` tools available. Reach for them when a LaTeX/biblatex error, package option, or API detail isn't obvious from local files — official docs and CTAN pages are often the fastest way to resolve obscure issues (e.g., load-order quirks, deprecated options, package-version-specific behavior) rather than trial-and-error in the build.

## Repository Overview

This repo holds two parallel CV/resume pipelines:

- **`CV/`** — the academic CV. Hand-authored in **pure LaTeX** against a custom class (`dahlkecv.cls`), rendered with XeLaTeX + biblatex/biber.
- **`resume/`** — the professional resume. Still built from R Markdown with the `vitae` package. (Not yet migrated.)

They share the bibliography under `bibliography/`.

## Project Structure

- `CV/`
  - `dahlke_ross_cv.tex` — main document; `\input`s each section file
  - `dahlkecv.cls` — custom class (fonts, colors, and all CV-specific macros: `\cvheader`, `\cventry`, `\cvedu`, `\cvtalk`, `\cvaward`, `\cvcourse`, `\cvadvisee`, `\cvservice`, `\cvreviewerlist`, descending-numbered `cvnumbered` bib environment)
  - `biblatex-dm.cfg` — custom biblatex datamodel overlay that adds the `award` and `coverage` fields for per-paper honors and press coverage. biblatex auto-loads this file name.
  - `latexmkrc` — pins the build to XeLaTeX.
  - `sections/*.tex` — one file per CV section (`appointments`, `education`, `publications`, `talks`, `awards`, `teaching`, `advising`, `service`, `experience`).
  - `fonts/` — gitignored.
- `resume/` — R Markdown resume (`dahlke_ross_resume.Rmd`, vitae-based).
- `bibliography/` — shared BibTeX files.
  - `publications.bib` — published work.
  - `working-papers.bib` — under review / forthcoming.
  - `reports.bib` — public pre-prints and reports.
  - `presentations.bib` — conference presentations.
- `figures/` — supporting graphics.

## Building the CV

```bash
cd CV && latexmk -xelatex dahlke_ross_cv.tex
```

`latexmkrc` forces XeLaTeX and invokes biber automatically. `latexmk -C` cleans all artifacts.

## Building the Resume

```r
rmarkdown::render("resume/dahlke_ross_resume.Rmd")
```

## Key Dependencies

- TeX distribution with XeLaTeX, biber, and biblatex-apa (TinyTeX is fine).
- Fonts: STIX Two Text (preferred, falls back to Source Serif 4 → EB Garamond → Latin Modern Roman).
- For the resume only: R + `rmarkdown` + `vitae`.

## CV Document Architecture

### Section flow in `CV/dahlke_ross_cv.tex`

1. `\cvheader{name}{position}{affiliation}{email}{website}{handle}` — three-line masthead, contact column right-aligned.
2. Academic Appointments, Education (using `\cventry` / `\cvedu`).
3. Research: Publications, Papers Under Review, Public Pre-Prints & Reports, Invited Talks.
4. Awards & Funding.
5. Teaching (with Advising, Professional Development subsections).
6. Service.
7. Professional Experience.

### Bibliography rendering

- `\usepackage[style=apa,sorting=ydnt,backend=biber,defernumbers=true]{biblatex}` in the class.
- Each `.bib` is loaded in its own `\begin{refsection}[path]{...}\printbibliography[env=cvnumbered]\end{refsection}` block so numbering restarts per section.
- `cvnumbered` is a custom `defbibenvironment` that produces a hanging-indent list. Numbers descend (newest = highest) via `\cvbibsection{N}` declaring the entry total before each block, and `\cvbiblabel` computing `N − idx + 1`.
- **Hardcoded entry counts**: `\cvbibsection{13}` etc. must be bumped whenever a `.bib` file gains or loses an entry. See `sections/publications.tex`.
- `\mkbibnamefamily` is redefined to bold any "Dahlke" / "Dahlke*" family-name token in author lists. Doesn't affect sorting.
- `biblatex-dm.cfg` adds two optional fields per bib entry:
  - `award={…}` — renders as an italic `Award · <text>` sub-line under the entry.
  - `coverage={…}` — renders as an italic `Coverage · <text>` sub-line. Use `\href{url}{label}` for linked outlets.
- The `finentry` bibmacro is overridden in `dahlkecv.cls` to print those sub-lines.

### Date on the CV footer

`\cvdocdate` is redefined in `dahlke_ross_cv.tex` to "Month YYYY" at compile time. Edit the format there if needed.

## Common Workflows

### Adding a publication

1. Add a BibTeX entry to the appropriate `.bib` file in `bibliography/`.
2. **Sort entries in the following order — the first entry in the file appears first (top) in the rendered CV:**
   1. **Year** (newest to oldest).
   2. **Publication status** (within year): Forthcoming/Accepted > Conditionally Accepted > Revise & Resubmit > Under Review > Invited to Submit.
   3. **Authorship**: Within the same status, Ross Dahlke as first author (or co-first author with `*`) comes before middle/later-author papers.
   4. **Venue prestige**: Within the same status and authorship group, higher-prestige venues first.
3. **Bump the corresponding `\cvbibsection{N}` count** in `CV/sections/publications.tex` so descending numbers stay correct.
4. Rebuild with `latexmk -xelatex`.

### Adding per-paper award or media coverage

Inside a bib entry, add:

```bibtex
award={Top Paper, ICA Political Communication Division 2024},
coverage={\href{https://nytimes.com/...}{The New York Times}, \href{...}{Wired}}
```

### Updating contact information

Edit the `\cvheader{…}` call near the top of `CV/dahlke_ross_cv.tex`.

### Adding a new CV section

1. Create `CV/sections/<name>.tex`.
2. Use the existing semantic macros from `dahlkecv.cls`, or add a new one to the class if needed.
3. `\input{sections/<name>}` from `dahlke_ross_cv.tex` in the position you want it to appear.

## Build Artifacts

Gitignored XeLaTeX/biber intermediates: `*.aux`, `*.bbl`, `*.bcf`, `*.blg`, `*.fdb_latexmk`, `*.fls`, `*.out`, `*.run.xml`, `*.xdv`, `*.log`. The PDF (`dahlke_ross_cv.pdf`) is committed. Clean all with `latexmk -C`.
