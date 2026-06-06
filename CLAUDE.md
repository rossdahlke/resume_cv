# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Research & troubleshooting

You have `WebSearch` and `WebFetch` tools available. Reach for them when a LaTeX/biblatex error, package option, or API detail isn't obvious from local files — official docs and CTAN pages are often the fastest way to resolve obscure issues (e.g., load-order quirks, deprecated options, package-version-specific behavior) rather than trial-and-error in the build.

## Repository Overview

This repo holds two parallel CV/resume pipelines:

- **`CV/`** — the academic CV. Hand-authored in **pure LaTeX** against a custom class (`dahlkecv.cls`), rendered with XeLaTeX. **No biblatex/biber** — publications are written directly as `\pub{…}` macro calls (see below). This is deliberate: a CV is a hand-curated list, and biblatex's sorting/numbering/APA machinery caused more problems than it solved.
- **`resume/`** — the professional resume. Still built from R Markdown with the `vitae` package. (Not yet migrated.)

The `bibliography/` `.bib` files are now used **only by the resume**. The CV no longer reads them; when you add a paper, you edit both `CV/sections/publications.tex` (for the CV) and the `.bib` (only if you want the resume updated too).

## Project Structure

- `CV/`
  - `dahlke_ross_cv.tex` — main document; `\input`s each section file
  - `dahlkecv.cls` — custom class. Loads **TeX Gyre Termes by filename** (see "Fonts" below) and defines all CV macros: `\cvheader`, `\cventry`, `\cvedu`, `\cvtalk`, `\cvaward`, `\cvcourse`, `\cvadvisee`, `\cvservice`, `\cvreviewerlist`, `\cvnote`, and the publication system (`publist` environment + `\pub`, `\pubaward`, `\pubcoverage`, `\cvdoi`, `\cvurl`).
  - `latexmkrc` — pins the build to XeLaTeX (no biber).
  - `sections/*.tex` — one file per CV section (`appointments`, `education`, `publications`, `talks`, `awards`, `teaching`, `advising`, `service`, `experience`).
  - `fonts/` — gitignored.
- `resume/` — R Markdown resume (`dahlke_ross_resume.Rmd`, vitae-based; still uses the `.bib` files).
- `bibliography/` — BibTeX files (resume only now).
  - `publications.bib`, `working-papers.bib`, `reports.bib`, `presentations.bib`.
- `figures/` — supporting graphics.

## Building the CV

```bash
cd CV && latexmk -xelatex dahlke_ross_cv.tex
```

`latexmkrc` forces XeLaTeX. No biber step. The descending publication numbers auto-count via the `.aux` (each `publist` writes its entry total back to `.aux`), so latexmk's normal "rerun until `.aux` is stable" loop handles it — usually two passes. `latexmk -C` cleans all artifacts.

## Building the Resume

```r
rmarkdown::render("resume/dahlke_ross_resume.Rmd")
```

## Key Dependencies

- TeX distribution with XeLaTeX (TinyTeX is fine). No biber/biblatex needed for the CV.
- **Fonts: TeX Gyre Termes**, which ships with TeX Live — so there is no external font dependency and the CV renders identically on any machine. It is loaded *by filename* (`texgyretermes` + `Extension=.otf`, `*-regular`/`*-bold`/`*-italic`/`*-bolditalic`) so fontspec resolves it via kpsewhich, not the system font DB. Do **not** revert to a system font like STIX Two Text: macOS ships those as *variable fonts*, which XeLaTeX cannot extract a bold weight from — `\textbf` then silently renders as regular. (That bug is the whole reason this CV uses Termes.)
- For the resume only: R + `rmarkdown` + `vitae` (which still reads the `.bib` files).

## CV Document Architecture

### Section flow in `CV/dahlke_ross_cv.tex`

1. `\cvheader{name}{position}{affiliation}{email}{website}{handle}` — three-line masthead, contact column right-aligned.
2. Academic Appointments, Education (using `\cventry` / `\cvedu`).
3. Research: Publications, Papers Under Review, Public Pre-Prints & Reports, Invited Talks.
4. Awards & Funding.
5. Teaching (with Advising, Professional Development subsections).
6. Service.
7. Professional Experience.

### Publication lists (`\pub` / `publist`)

Publications, Papers Under Review, and Public Pre-Prints & Reports are plain hand-written lists in `sections/publications.tex`. Each is wrapped in a `publist` environment with a unique key:

```latex
\begin{publist}{publications}   % key must be unique per list
\pub{authors}{year}{title (include its own trailing . or ?)}{venue, vol(iss), pp. \cvdoi{...}}{extras}
...
\end{publist}
```

- **Order = the order you type.** First entry = top = highest number. There is no automatic sorting to fight. Keep entries in the order described under "Adding a publication".
- **Descending numbers auto-count** — no hardcoded totals. Each `publist` writes its entry count to the `.aux` (`\setcvpubtotal{key}{N}`); the next compile reads it so labels run high→low. (First-ever compile shows odd/negative numbers for one pass; latexmk reruns and they settle.)
- **Bold your own name** by typing `\textbf{Dahlke}` (or `\textbf{Dahlke}*` for co-first) directly in the author field. Nothing magic — it's literal bold. This works because the CV uses TeX Gyre Termes, which has a real bold face.
- **DOIs / URLs**: `\cvdoi{10.xxxx/yyyy}` prints a clickable, breakable `https://doi.org/...`. `\cvurl{https://...}` for non-DOI links. URLs with `# % _` etc. must have those characters backslash-escaped (`\_`), since the macro reads its argument once (e.g. `\cvurl{https://doi.org/10.31234/osf.io/qtdmg\_v1}`).
- **Per-paper award / press**: pass `\pubaward{...}` and/or `\pubcoverage{...}` as the 5th `\pub` argument (empty `{}` if none). Each renders as an italic `Award ·` / `Coverage ·` sub-line. Use `\href{url}{label}` for linked outlets inside coverage.

### Date on the CV footer

`\cvdocdate` is redefined in `dahlke_ross_cv.tex` to "Month YYYY" at compile time. Edit the format there if needed.

## Common Workflows

### Adding a publication

1. Add a `\pub{…}{…}{…}{…}{…}` entry to the right `publist` in `CV/sections/publications.tex` (Publications / Papers Under Review / Reports).
2. **Place it in the correct position — the first entry in a list renders at the top (highest number):**
   1. **Year** (newest to oldest).
   2. **Publication status** (within year): Forthcoming/Accepted > Conditionally Accepted > Revise & Resubmit > Under Review > Invited to Submit.
   3. **Authorship**: within a status, Ross as first author (or co-first with `*`) before middle/later-author papers.
   4. **Venue prestige**: within a status and authorship group, higher-prestige venues first.
3. Bold the name (`\textbf{Dahlke}`), give the title its own trailing `.`/`?`, add `\cvdoi{}`/`\cvurl{}` for links. No counts to bump — numbers auto-update.
4. Rebuild with `latexmk -xelatex`. (Optionally also add/update the entry in the matching `.bib` so the resume stays in sync.)

### Adding per-paper award or media coverage

Pass them as the 5th argument of `\pub`:

```latex
\pub{authors}{year}{title.}{venue. \cvdoi{...}}
  {\pubaward{Top Paper, ICA Political Communication Division 2024}%
   \pubcoverage{\href{https://nytimes.com/...}{The New York Times}, \href{...}{Wired}}}
```

### Updating contact information

Edit the `\cvheader{…}` call near the top of `CV/dahlke_ross_cv.tex`.

### Adding a new CV section

1. Create `CV/sections/<name>.tex`.
2. Use the existing semantic macros from `dahlkecv.cls`, or add a new one to the class if needed.
3. `\input{sections/<name>}` from `dahlke_ross_cv.tex` in the position you want it to appear.

## Build Artifacts

Gitignored XeLaTeX/biber intermediates: `*.aux`, `*.bbl`, `*.bcf`, `*.blg`, `*.fdb_latexmk`, `*.fls`, `*.out`, `*.run.xml`, `*.xdv`, `*.log`. The PDF (`dahlke_ross_cv.pdf`) is committed. Clean all with `latexmk -C`.
