# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Research & troubleshooting

You have `WebSearch` and `WebFetch` tools available. Reach for them when a LaTeX error, package option, or API detail isn't obvious from local files — official docs and CTAN pages are often the fastest way to resolve obscure issues (e.g., load-order quirks, deprecated options, package-version-specific behavior) rather than trial-and-error in the build.

## Repository Overview

This repo holds Ross Dahlke's academic CV, hand-authored in **pure LaTeX** against a custom class (`dahlkecv.cls`), rendered with XeLaTeX. **No biblatex/biber** — publications are written directly as `\pub{…}` macro calls (see below). This is deliberate: a CV is a hand-curated list, and biblatex's sorting/numbering/APA machinery caused more problems than it solved.

> An older `moderncv`-based CV and an R Markdown / `vitae` professional resume previously lived here. Both have been retired; they remain recoverable in git history under the `archive/vitae-cv` tag (`git checkout archive/vitae-cv`).

## Project Structure

- `dahlke_ross_cv.tex` — main document; `\input`s each section file.
- `dahlkecv.cls` — custom class. Loads **TeX Gyre Termes by filename** (see "Key Dependencies" below) and defines all CV macros: `\cvheader`, `\cventry`, `\cvedu`, `\cvtalk`, `\cvaward`, `\cvcourse`, `\cvadvisee`, `\cvservice`, `\cvreviewerlist`, `\cvnote`, the contact-bar helpers (`\cvsocial`, `\cvicon`, `\cvsep`, `\cviconsep` + icon glyphs `\faEmail`, `\faWeb`, `\faXicon`, `\faBlueskyIcon`, `\faLinkedinIcon`, `\faGithubIcon`, `\aiScholar`), and the publication system (`publist` environment + `\pub`, `\pubaward`, `\pubcoverage`, `\pubnote`, `\cvdoi`, `\cvurl`).
- `assets/icons/` — **committed**, vendored icon OTFs loaded by filename (same reproducibility rationale as Termes): `FontAwesome6-Brands.otf` (X, Bluesky, LinkedIn, GitHub), `FontAwesome6-Solid.otf` (envelope, globe), `Academicons.otf` (Google Scholar). FA6 is vendored because TeX Live here only ships FA4 (no X/Bluesky glyphs) and `tlmgr` is cross-release-blocked; Academicons is vendored because the installed package's TTF is older than its `.sty` codepoint map (Google Scholar glyph missing) while the OTF has it.
- `latexmkrc` — pins the build to XeLaTeX (no biber).
- `sections/*.tex` — one file per CV section (`appointments`, `education`, `awards`, `publications`, `funding`, `presentations`, `teaching`, `advising`, `service`, `experience`).
- `dahlke_ross_cv.pdf` — the built CV (committed).
- `fonts/` — gitignored, unused by the Termes-based build.
- `reference/peer-cvs/` — gitignored. Local-only copies of UW–Madison colleagues' CVs (Kim, Shah, Wagner, Yang, Rojas, McLeod, Riddle) kept as formatting reference for the tenure-CV layout; never tracked or redistributed.

The CV layout follows the **UW–Madison Social Sciences Divisional Committee** tenure-CV checklist plus departmental conventions (see memory `uw-soc-sci-cv-format`).

## Building the CV

```bash
latexmk -xelatex dahlke_ross_cv.tex
```

`latexmkrc` forces XeLaTeX. No biber step. The descending publication numbers auto-count via the `.aux` (each `publist` writes its entry total back to `.aux`), so latexmk's normal "rerun until `.aux` is stable" loop handles it — usually two passes. `latexmk -C` cleans all artifacts.

## Key Dependencies

- TeX distribution with XeLaTeX (TinyTeX is fine). No biber/biblatex needed.
- **Icon fonts** for the header contact bar are vendored in `assets/icons/` (FontAwesome 6 Free + Academicons OTFs), loaded by filename via `Path=./assets/icons/` — committed so the build stays self-contained. See Project Structure for why they're vendored rather than pulled from TeX Live.
- **Fonts: TeX Gyre Termes**, which ships with TeX Live — so there is no external font dependency and the CV renders identically on any machine. It is loaded *by filename* (`texgyretermes` + `Extension=.otf`, `*-regular`/`*-bold`/`*-italic`/`*-bolditalic`) so fontspec resolves it via kpsewhich, not the system font DB. Do **not** revert to a system font like STIX Two Text: macOS ships those as *variable fonts*, which XeLaTeX cannot extract a bold weight from — `\textbf` then silently renders as regular. (That bug is the whole reason this CV uses Termes.)

## CV Document Architecture

### Section flow in `dahlke_ross_cv.tex`

1. `\cvheader{name}{position}{affiliation}{contact bar}` — name/title/affiliation stacked left, then a one-line muted **contact bar** built from `\cvsocial{icon}{url}{text}` (email + website, shown with text) and `\cvicon{icon}{url}` (Scholar/X/Bluesky/LinkedIn/GitHub, icon-only so it stays on one line), divided by `\cvsep` and `\cviconsep`. Edit the bar in `dahlke_ross_cv.tex`.
2. **Academic Appointments**, **Education** (using `\cventry` / `\cvedu`; Education includes the dissertation title + committee). *Appointments-first matches committee member Kim; to use the divisional-list/Wagner order, swap the two `\input` lines so Education comes first.*
3. **Honors & Awards** — non-monetary honors (`sections/awards.tex`), including **notable paper awards** (e.g. best-paper / top-paper). Paper awards appear in **both** places: as a `\cvaward` entry here *and* inline on the paper via `\pubaward`. (Named fellowships with dollar amounts live in `sections/funding.tex` instead, to avoid double-listing.)
4. **Research** — Publications (single chronological list). Then a separate **Research in Progress** section: *Manuscripts Under Review* + *Working Papers & Reports*.
5. **Research Funding & Fellowships** (`sections/funding.tex`) — monetary support, split out from Honors per the divisional "Research Support (source, dates, amount)" requirement.
6. **Presentations** (`sections/presentations.tex`) — *Invited Talks & Guest Lectures* + *Refereed Conference Presentations* (the latter lists ALL refereed conference papers Ross authors, not just podium talks).
7. **Teaching** — Courses + Professional Development.
8. **Advising** — own top-level section (PhD / Research MA / Directed Study), with role + placement.
9. **Service** — organized to the divisional service scheme (public · university · professional): Departmental & University · Professional Service (subsumes the editorial Data Editor role) · Peer Review. Editorial and peer review are nested under professional service, matching former divisional committee members Kim & Wagner (and Yang). No public/community items yet; add a leading subsection if any arise (divisional order lists public first).
10. **Professional Experience**.

### Publication lists (`\pub` / `publist`)

Publications, Manuscripts Under Review, and Working Papers & Reports are plain hand-written lists in `sections/publications.tex`. Each is wrapped in a `publist` environment with a unique key:

```latex
\begin{publist}{publications}   % key must be unique per list
\pub{authors}{year}{title (include its own trailing . or ?)}{venue, vol(iss), pp. \cvdoi{...}}{extras}
...
\end{publist}
```

- **Order = the order you type.** First entry = top = highest number. There is no automatic sorting to fight. Keep entries in the order described under "Adding a publication".
- **Descending numbers auto-count** — no hardcoded totals. Each `publist` writes its entry count to the `.aux` (`\setcvpubtotal{key}{N}`); the next compile reads it so labels run high→low. (First-ever compile shows odd/negative numbers for one pass; latexmk reruns and they settle.)
- **Co-author legend (departmental / Kim convention).** Mark authorship with literal symbols typed into the author field, defined in a `\cvnote` legend atop the Publications list: **bold** = Dahlke (full name, `\textbf{Dahlke, R.}`); `*` = equal/co-first authorship (baseline asterisk, the conventional co-first mark — placed **after the surname**, matching co-authors, e.g. co-author `Moore*, R. C.` and Ross `\textbf{Dahlke}*\textbf{, R.}` which keeps the full name + initial bold with a non-bold `*` after the surname); and as **superscripts** — `\textsuperscript{\#}` = graduate-student co-author, `\textsuperscript{\textdaggerdbl}` (‡) = undergraduate-student co-author, `\textsuperscript{\textasciicircum}` = untenured junior-faculty co-author, `\textsuperscript{+}` = tenured-faculty co-author. The legend now **leads** the rank symbols with "Co-author status *at time of submission*:" so the qualifier introduces the `#/‡/^/+` group rather than trailing it. The same legend applies to Refereed Conference Presentations. The `#/‡/^/+` tags are mostly not yet filled in — each multi-author entry carries a `% TODO` prompting Ross to add them; do not invent them. (Symbols are literal text, no macro magic; the asterisk/superscripts render because Termes has real bold/italic faces.) Note: no example peer CV marks senior/last author; the field idiom for senior authorship is a corresponding-author mark (Yang uses `*` for corresponding — here `*` is co-first, so a separate symbol would be needed if a corresponding/senior mark is ever added).
- **All listed articles are peer-reviewed**, stated in the legend (satisfies the divisional peer-reviewed-marking rule without per-item asterisks, since no non-refereed items are mixed in).
- **PACM HCI = journal, not proceedings.** The two CSCW papers are published in *Proceedings of the ACM on Human-Computer Interaction* — append `(PACM HCI)` to the venue and attach `\pubnote{PACM HCI is a peer-reviewed journal (ACM CSCW track).}` as the 5th `\pub` arg. (The one real *CHI* conference paper is left as a genuine proceeding.)
- **Bold your own name** by typing `\textbf{Dahlke, R.}` (full name, surname *and* initial) directly in the author field. Nothing magic — it's literal bold, working because the CV uses TeX Gyre Termes.
- **DOIs / URLs**: `\cvdoi{10.xxxx/yyyy}` prints a clickable, breakable `https://doi.org/...`. `\cvurl{https://...}` for non-DOI links. URLs with `# % _` etc. must have those characters backslash-escaped (`\_`), since the macro reads its argument once (e.g. `\cvurl{https://doi.org/10.31234/osf.io/qtdmg\_v1}`).
- **Per-paper award / press / note**: pass `\pubaward{...}`, `\pubcoverage{...}`, and/or `\pubnote{...}` as the 5th `\pub` argument (empty `{}` if none). Each renders as an italic `Award ·` / `Coverage ·` / `Note ·` sub-line. Use `\href{url}{label}` for linked outlets inside coverage. Do **not** add contribution notes here — per-paper contribution descriptions live in the tenure package, not the CV.

### Date on the CV footer

`\cvdocdate` is redefined in `dahlke_ross_cv.tex` to "Month YYYY" at compile time. Edit the format there if needed.

## Common Workflows

### Adding a publication

1. Add a `\pub{…}{…}{…}{…}{…}` entry to the right `publist` in `sections/publications.tex` (Publications / Manuscripts Under Review / Working Papers & Reports).
2. **Place it in the correct position — the first entry in a list renders at the top (highest number):**
   1. **Year** (newest to oldest).
   2. **Publication status** (within year): Forthcoming/Accepted > Conditionally Accepted > Revise & Resubmit > Under Review > Invited to Submit.
   3. **Authorship**: within a status, Ross as first author (or co-first with `*`) before middle/later-author papers.
   4. **Venue prestige**: within a status and authorship group, higher-prestige venues first.
3. Bold the name (`\textbf{Dahlke, R.}`); for co-first papers place the `*` after the surname while keeping the full name bold (`\textbf{Dahlke}*\textbf{, R.}`), give the title its own trailing `.`/`?`, add `\cvdoi{}`/`\cvurl{}` for links. No counts to bump — numbers auto-update.
4. Rebuild with `latexmk -xelatex`.

### Adding per-paper award or media coverage

Pass them as the 5th argument of `\pub`:

```latex
\pub{authors}{year}{title.}{venue. \cvdoi{...}}
  {\pubaward{Top Paper, ICA Political Communication Division 2024}%
   \pubcoverage{\href{https://nytimes.com/...}{The New York Times}, \href{...}{Wired}}}
```

### Updating contact information

Edit the `\cvheader{…}` call near the top of `dahlke_ross_cv.tex`. The 4th argument is the contact bar: add/remove `\cvsocial{icon}{url}{text}` (icon + visible text, for email/website) or `\cvicon{icon}{url}` (icon-only, for social/scholar links) items, separated by `\cvsep` (between text items) or `\cviconsep` (between bare icons). Keep it to **one line** — prefer icon-only `\cvicon` for additional platforms. Icon glyph macros live in `dahlkecv.cls` (`\faXicon`, `\faBlueskyIcon`, `\faLinkedinIcon`, `\faGithubIcon`, `\aiScholar`, `\faEmail`, `\faWeb`); to add a new platform, define a glyph macro there with the correct FontAwesome 6 / Academicons codepoint.

### Adding a new CV section

1. Create `sections/<name>.tex`.
2. Use the existing semantic macros from `dahlkecv.cls`, or add a new one to the class if needed.
3. `\input{sections/<name>}` from `dahlke_ross_cv.tex` in the position you want it to appear.

## Build Artifacts

Gitignored XeLaTeX intermediates: `*.aux`, `*.bbl`, `*.bcf`, `*.blg`, `*.fdb_latexmk`, `*.fls`, `*.out`, `*.run.xml`, `*.xdv`, `*.log`. The PDF (`dahlke_ross_cv.pdf`) is committed. Clean all with `latexmk -C`.
