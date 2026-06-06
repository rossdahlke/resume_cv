$pdf_mode = 5;  # xelatex
$xelatex = 'xelatex -interaction=nonstopmode -halt-on-error %O %S';
# No biber/bibtex: publications are plain LaTeX (\pub macro), not biblatex.
# Descending numbers are auto-counted via the .aux, so latexmk's normal rerun
# loop (until .aux is stable) is all that's needed.
