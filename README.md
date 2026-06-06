# Ross Dahlke — Academic CV

The source for my academic CV, hand-authored in pure LaTeX and rendered with XeLaTeX.

## Build

```bash
latexmk -xelatex dahlke_ross_cv.tex
```

`latexmkrc` pins the build to XeLaTeX. The descending publication numbers auto-count
via the `.aux` file, so latexmk's normal "rerun until `.aux` is stable" loop settles
them (usually two passes). Clean all artifacts with `latexmk -C`.

## Dependencies

- A TeX distribution with **XeLaTeX** (TinyTeX is fine). No biber/biblatex needed.
- **TeX Gyre Termes**, which ships with TeX Live, so there is no external font
  dependency and the CV renders identically on any machine. It is loaded *by filename*
  (via `kpsewhich`), which is what makes a real bold weight available — see `CLAUDE.md`
  for why this matters.

## Layout

- `dahlke_ross_cv.tex` — main document; `\input`s each section.
- `dahlkecv.cls` — custom class defining the CV macros (`\cvheader`, `\cventry`,
  the `publist`/`\pub` publication system, etc.).
- `latexmkrc` — forces XeLaTeX.
- `sections/` — one `.tex` file per CV section.
- `dahlke_ross_cv.pdf` — the built CV (committed).

See `CLAUDE.md` for the full document architecture and authoring workflows.

## History

This repo previously held an R Markdown / `vitae` professional resume and an older
`moderncv`-based CV. Both have been retired. They remain fully recoverable in git
history under the `archive/vitae-cv` tag:

```bash
git checkout archive/vitae-cv
```
