\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dahlkecv}[2026/04/15 Academic CV class for Ross Dahlke]

\LoadClass[11pt]{article}

\RequirePackage[letterpaper,margin=0.85in,top=0.85in,bottom=0.9in]{geometry}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{tabularx}
\RequirePackage{multicol}
\RequirePackage{fancyhdr}
\RequirePackage{parskip}
\RequirePackage{etoolbox}
\RequirePackage{url}
\RequirePackage[hidelinks,breaklinks=true,colorlinks=true]{hyperref}
\urlstyle{same}

\definecolor{accent}{HTML}{414141}
\definecolor{muted}{HTML}{6F6F6F}
\definecolor{rule}{HTML}{BFBFBF}

\AtBeginDocument{\hypersetup{allcolors=accent}}

% TeX Gyre Termes (a Times clone, shipped with TeX Live) loaded BY FILENAME so
% fontspec resolves it via kpsewhich, not the system font database. This is
% deliberate: it has separate static Regular/Bold/Italic/BoldItalic .otf files,
% so \textbf actually renders bold, and the result is identical on every machine.
% (Do NOT switch to a system font like STIX Two Text — macOS ships those as
% variable fonts that XeLaTeX cannot extract a bold weight from.)
\setmainfont{texgyretermes}[
  Extension=.otf,
  UprightFont=*-regular,
  BoldFont=*-bold,
  ItalicFont=*-italic,
  BoldItalicFont=*-bolditalic,
  Ligatures=TeX
]

% Icon fonts, vendored in assets/icons/ and loaded by filename (same reliability
% rationale as Termes): FontAwesome 6 Free for brand/UI glyphs, Academicons for
% Google Scholar. Codepoints are FA6 / Academicons private-use values.
\newfontfamily\faBrandsFont{FontAwesome6-Brands.otf}[Path=./assets/icons/]
\newfontfamily\faSolidFont{FontAwesome6-Solid.otf}[Path=./assets/icons/]
\newfontfamily\acadIconsFont{Academicons.otf}[Path=./assets/icons/]
\newcommand{\faEmail}{{\faSolidFont\symbol{"F0E0}}}
\newcommand{\faWeb}{{\faSolidFont\symbol{"F0AC}}}
\newcommand{\faXicon}{{\faBrandsFont\symbol{"E61B}}}
\newcommand{\faBlueskyIcon}{{\faBrandsFont\symbol{"E671}}}
\newcommand{\faLinkedinIcon}{{\faBrandsFont\symbol{"F08C}}}
\newcommand{\faGithubIcon}{{\faBrandsFont\symbol{"F09B}}}
\newcommand{\aiScholar}{{\acadIconsFont\symbol{"E9D4}}}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\newcommand{\cvdocdate}{\today}
\fancyfoot[L]{\small\color{muted}\cvdocdate}
\fancyfoot[C]{\small\color{muted}Ross Dahlke \textperiodcentered{} Curriculum Vitae}
\fancyfoot[R]{\small\color{muted}\thepage}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.35em}

% No hyphenation: never split a word (or a name like "Bernstein") across lines.
% \emergencystretch lets justified lines stretch a little instead of overflowing,
% and a raised \tolerance permits the resulting looser spacing without warnings.
\hyphenpenalty=10000
\exhyphenpenalty=10000
\tolerance=1200
\setlength{\emergencystretch}{3em}
\setlist[itemize]{nosep,leftmargin=1.3em,label=\textbullet,topsep=2pt,partopsep=0pt}

% Three visual tiers: section (large small-caps + trailing rule that fills to the
% right margin), subsection (small small-caps, no rule), entry title (bold
% title-case, set by the macros). Small caps make the headings read as labels
% distinct from the bold entry names.
% The fill-rule: title text, then a thin rule raised to the heading's mid-height
% running to the right margin (\leaders…\hfill fills the remaining line width).
\newcommand{\cvsectionrule}[1]{%
  #1\hspace{0.6em}{\color{rule}\leaders\hrule height 0.30em depth -0.24em\hfill}\kern0pt}
\titleformat{\section}%
  {\Large\bfseries\color{accent}}{}{0em}{\cvsectionrule}
\titlespacing*{\section}{0pt}{1.0em}{0.5em}

\titleformat{\subsection}%
  {\large\bfseries\itshape\color{accent}}{}{0em}{}
\titlespacing*{\subsection}{0pt}{0.75em}{0.6em}

% \cvheader{name}{title line}{contact bar}
% Title line = role, unit, and institution on one line under the name. The
% contact bar is a one-line row of \cvsocial / \cvicon items (see helpers below).
\newcommand{\cvheader}[3]{%
  \begingroup
  % Name row: name left, UW crest right-justified (sized like a small mark so the
  % full-width title line below is unaffected).
  {\LARGE\bfseries\color{accent}#1}\hfill
  \raisebox{-0.22\height}{\includegraphics[height=0.9cm]{assets/uw-crest.pdf}}%
  \par\vspace{0.25em}
  {#2}\par\vspace{0.55em}
  {\footnotesize\color{muted}#3\par}%
  \vspace{0.1em}
  \endgroup
}

% Contact-bar building blocks. \cvsocial is an icon + linked text label (used for
% email and website); \cvicon is an icon-only linked item (used for the social /
% scholar profiles, whose logos identify them — keeps the whole bar to one line).
% \cvsep is the bulleted divider; \cviconsep is the tight gap between bare icons.
\newcommand{\cvsocial}[3]{\href{#2}{{\color{muted}#1\nobreak\hspace{0.35em}#3}}}
\newcommand{\cvicon}[2]{\href{#2}{{\color{muted}#1}}}
\newcommand{\cvsep}{\nobreak\hskip 0.55em\textcolor{rule}{\textbullet}\hskip 0.55em\relax}
\newcommand{\cviconsep}{\hspace{0.55em}}

% Entry macros use a left-text + \hfill + right-text layout (NOT a 2-column
% table): each logical line puts its title/detail on the left and its date/
% amount on the right *of the same baseline*, with real single-line spacing
% between the title and its detail. \cv@line is the shared one-line helper;
% \cv@tight is the tight break between a title and its detail line.
\newcommand{\cv@line}[2]{#1\nobreak\hfill\nobreak#2}
% Starred \\ forbids a page break at the forced line break, so an entry's stacked
% lines (title + detail) never split across a page boundary.
\newcommand{\cv@tight}{\\*[-0.12em]}
\newcommand{\cv@gap}{\vspace{0.55em}}
% Shared keep-together setup for entry macros: zero intra-entry \parskip and max
% out the penalties so a single entry (incl. wrapped lines) stays on one page.
% Breaks still occur between entries at \cv@gap. Mirrors the publist protection.
\newcommand{\cv@entrysetup}{%
  \setlength{\parskip}{0pt}\interlinepenalty\@M\clubpenalty\@M\widowpenalty\@M}

\newcommand{\cventry}[5]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#2}}{\textit{\color{muted}#3}}\cv@tight
  \cv@line{#1}{\textit{\color{muted}#4}}\par
  \ifstrempty{#5}{\vspace{0.12em}}{\nopagebreak\begin{itemize}#5\end{itemize}}%
  \cv@gap\endgroup
}

\newcommand{\cvedu}[6]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#1}}{\textit{\color{muted}#2}}\cv@tight
  \cv@line{#3}{\textit{\color{muted}#5}}\par
  \ifstrempty{#4}{}{{\itshape\color{muted}#4}\par}%
  \ifstrempty{#6}{\vspace{0.12em}}{\nopagebreak\begin{itemize}#6\end{itemize}}%
  \cv@gap\endgroup
}

% #1 talk title (bold) · #2 venue · #3 host (· joins #2/#3) · #4 date (right)
\newcommand{\cvtalk}[4]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#1}}{\textit{\color{muted}#4}}%
  \ifstrempty{#2#3}{}{\cv@tight
    {\color{muted}\ifstrempty{#2}{}{#2\ifstrempty{#3}{}{ \textperiodcentered{} }}#3}}%
  \par\cv@gap\endgroup
}

% #1 award name (bold) · #2 institution · #3 amount (right, 2nd line) · #4 year (right)
\newcommand{\cvaward}[4]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#1}}{\textit{\color{muted}#4}}%
  \ifstrempty{#2#3}{}{\cv@tight
    \cv@line{\color{muted}#2}{\ifstrempty{#3}{}{\textbf{#3}}}}%
  \par\cv@gap\endgroup
}

% #1 course code (bold) · #2 title (after en-dash) · #3 institution · #4 role · #5 term (right)
\newcommand{\cvcourse}[5]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#1}\ifstrempty{#2}{}{ \textendash{} #2}}{\textit{\color{muted}#5}}%
  \ifstrempty{#3#4}{}{\cv@tight
    {\color{muted}#3\ifstrempty{#3}{}{\ifstrempty{#4}{}{ \textperiodcentered{} }}#4}}%
  \par\cv@gap\endgroup
}

% #1 advisee name (bold) · #2 program · #3 role · #4 topic/placement · #5 dates (right)
\newcommand{\cvadvisee}[5]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#1}}{\textit{\color{muted}#5}}%
  \ifstrempty{#2#3}{}{\cv@tight
    {\color{muted}\ifstrempty{#2}{}{#2\ifstrempty{#3}{}{ \textperiodcentered{} }}#3}}%
  \ifstrempty{#4}{}{\cv@tight{\itshape\color{muted}#4}}%
  \par\cv@gap\endgroup
}

% #1 role · #2 organization (bold) · #3 URL · #4 dates (right)
\newcommand{\cvservice}[4]{%
  \begingroup\cv@entrysetup{}%
  \noindent\cv@line{\textbf{#2}}{\textit{\color{muted}#4}}%
  \ifstrempty{#1#3}{}{\cv@tight
    {\color{muted}\ifstrempty{#1}{}{#1\ifstrempty{#3}{}{ \textperiodcentered{} }}\ifstrempty{#3}{}{\href{#3}{\color{accent}#3}}}}%
  \par\cv@gap\endgroup
}

\newcommand{\cvreviewerlist}[1]{%
  \begin{multicols}{2}\raggedright
  \begin{itemize}[leftmargin=1.1em,label=\textbullet,itemsep=1pt,topsep=2pt]
    #1
  \end{itemize}
  \end{multicols}
}

\newcommand{\cvnote}[1]{{\small\itshape\color{muted}#1}\par\vspace{0.3em}}

%% --------------------------------------------------------------
%% Publication lists (plain LaTeX — no biblatex/biber)
%% --------------------------------------------------------------
%
% A publication list is just a hand-ordered, descending-numbered hanging list.
% Entries render in the order written (first = top = highest number). To bold
% your own name, type \textbf{Dahlke} in the author field. No .bib, no biber.

% Self-linking URL in the body font, breakable. Use \cvdoi for DOIs.
% Both read their argument once, so URLs containing # % _ etc. must be written
% with those characters escaped (\_ \# \%); \href/\nolinkurl normalise them.
\newcommand{\cvurl}[1]{\href{#1}{\nolinkurl{#1}}}
\newcommand{\cvdoi}[1]{\cvurl{https://doi.org/#1}}

% Optional per-paper sub-lines (used as the 5th arg of \pub).
\newcommand{\pubaward}[1]{%
  \par\nobreak\vspace{1pt}\nobreak{\small\color{muted}\textit{Award}~\textperiodcentered~#1}}
\newcommand{\pubcoverage}[1]{%
  \par\nobreak\vspace{1pt}\nobreak{\small\color{muted}\textit{Coverage}~\textperiodcentered~#1}}
% Generic per-paper clarifying note (e.g. "venue X is a peer-reviewed journal").
\newcommand{\pubnote}[1]{%
  \par\nobreak\vspace{1pt}\nobreak{\small\color{muted}\textit{Note}~\textperiodcentered~#1}}

% Descending numbers with NO hardcoded totals: each publist writes its entry
% count to the .aux under a key; the next compile reads it back so labels run
% high-to-low (newest = highest). latexmk reruns until stable.
\newcounter{cvpubidx}
\newcommand{\setcvpubtotal}[2]{\csgdef{cvpubtotal@#1}{#2}}
% Total for a key, or 0 before the first compile has written the .aux.
\newcommand{\cvpubtotal}[1]{\ifcsname cvpubtotal@#1\endcsname\csname cvpubtotal@#1\endcsname\else0\fi}

\newenvironment{publist}[1]{%
  \def\cv@publistkey{#1}%
  \setcounter{cvpubidx}{0}%
  \begin{list}{}{%
    \setlength{\labelwidth}{2.2em}%
    \setlength{\labelsep}{0.6em}%
    \setlength{\leftmargin}{2.8em}%
    \setlength{\itemindent}{0pt}%
    \setlength{\itemsep}{0.55em}%
    \setlength{\parsep}{0pt}%
    \setlength{\topsep}{2pt}%
    \renewcommand{\makelabel}[1]{\makebox[\labelwidth][r]{##1}}%
  }%
  % Keep each publication entry together: forbid page breaks within an item's
  % paragraph (and its award/coverage/note sub-lines via \nobreak in those
  % macros). Breaks still happen between entries at \itemsep.
  \interlinepenalty\@M \clubpenalty\@M \widowpenalty\@M
}{%
  \end{list}%
  \immediate\write\@auxout{%
    \string\setcvpubtotal{\cv@publistkey}{\the\value{cvpubidx}}}%
}

% \pub{authors}{year}{title (incl. trailing period or ?)}{venue, vol(iss), pp. \cvdoi{...}}{extras}
\newcommand{\pub}[5]{%
  \stepcounter{cvpubidx}%
  \item[\textbf{\the\numexpr\cvpubtotal{\cv@publistkey}-\value{cvpubidx}+1\relax.}]%
  #1 (#2). #3\ #4#5%
}

\endinput
