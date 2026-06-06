\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dahlkecv}[2026/04/15 Academic CV class for Ross Dahlke]

\LoadClass[11pt]{article}

\RequirePackage[letterpaper,margin=0.85in,top=0.85in,bottom=0.9in]{geometry}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
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

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\newcommand{\cvdocdate}{\today}
\fancyfoot[L]{\small\color{muted}\cvdocdate}
\fancyfoot[C]{\small\color{muted}Ross Dahlke \textperiodcentered{} Curriculum Vitae}
\fancyfoot[R]{\small\color{muted}\thepage}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.35em}
\setlist[itemize]{nosep,leftmargin=1.3em,label=\textbullet,topsep=2pt,partopsep=0pt}

\titleformat{\section}%
  {\Large\bfseries\color{accent}}{}{0em}{}%
  [{\vspace{-0.2em}{\color{rule}\titlerule[0.5pt]}}]
\titlespacing*{\section}{0pt}{1.2em}{0.3em}

\titleformat{\subsection}%
  {\normalsize\bfseries\color{accent}}{}{0em}{}
\titlespacing*{\subsection}{0pt}{0.8em}{0.2em}

\newcommand{\cvheader}[6]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \renewcommand{\arraystretch}{1.1}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    {\LARGE\bfseries\color{accent}#1} & {\small\color{muted} #4}\\
    {\large #2}                       & {\small\color{muted} #5}\\
    {\normalsize\itshape\color{muted} #3} & {\small\color{muted} #6}\\
  \end{tabularx}%
  \par\vspace{0.4em}
  \endgroup
}

\newcommand{\cventry}[5]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#2} & \textit{\color{muted} #3}\\
    #1 & \textit{\color{muted} #4}\\
  \end{tabularx}%
  \ifstrempty{#5}{\vspace{0.15em}}{%
    \begin{itemize}#5\end{itemize}%
  }%
  \vspace{0.3em}
  \endgroup
}

\newcommand{\cvedu}[6]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#1} & \textit{\color{muted} #2}\\
    #3 & \textit{\color{muted} #5}\\
  \end{tabularx}%
  \ifstrempty{#4}{}{\hspace{1.3em}{\itshape\color{muted} #4}\par}%
  \ifstrempty{#6}{\vspace{0.15em}}{%
    \begin{itemize}#6\end{itemize}%
  }%
  \vspace{0.3em}
  \endgroup
}

% #1 talk title (bold, top-left; gets most of the width because right col is just the date)
% #2 venue / event series (muted, second-line-left)
% #3 host institution (muted, second-line-left, joined to venue with a bullet)
% #4 date (italic muted, top-right)
\newcommand{\cvtalk}[4]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#1} & \textit{\color{muted} #4}\\
    \ifstrempty{#2#3}{\relax}{%
      {\color{muted}%
        \ifstrempty{#2}{}{#2\ifstrempty{#3}{}{ \textperiodcentered{} }}%
        #3%
      }%
    } & \\
  \end{tabularx}%
  \vspace{0.35em}
  \endgroup
}

% #1 award name (bold, top-left)
% #2 granting institution (muted, second-line-left)
% #3 dollar amount (bold, second-line-right) — may be empty
% #4 year (italic muted, top-right)
\newcommand{\cvaward}[4]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#1} & \textit{\color{muted} #4}\\
    {\color{muted}#2} & \ifstrempty{#3}{\relax}{\textbf{#3}}\\
  \end{tabularx}%
  \vspace{0.3em}
  \endgroup
}

% #1 course code (bold, top-left)
% #2 course title (follows code after em-dash on top-left)
% #3 institution (small muted, second line)
% #4 role (small muted, second line, after institution)
% #5 term(s) (italic muted, top-right)
\newcommand{\cvcourse}[5]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#1}\ifstrempty{#2}{}{ \textendash{} #2} & \textit{\color{muted} #5}\\
    \ifstrempty{#3#4}{\relax}{%
      {\color{muted}#3\ifstrempty{#3}{}{\ifstrempty{#4}{}{ \textperiodcentered{} }}#4}%
    } & \\
  \end{tabularx}%
  \vspace{0.3em}
  \endgroup
}

% #1 advisee name (bold, top-left)
% #2 degree program (muted, second-line-left)
% #3 role/committee (muted, second-line-left, after degree with bullet)
% #4 research topic or thesis (italic muted, third line)
% #5 dates (italic muted, top-right)
\newcommand{\cvadvisee}[5]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#1} & \textit{\color{muted} #5}\\
    \ifstrempty{#2#3}{\relax}{%
      {\color{muted}%
        \ifstrempty{#2}{}{#2\ifstrempty{#3}{}{ \textperiodcentered{} }}%
        #3%
      }%
    } & \\
  \end{tabularx}%
  \ifstrempty{#4}{}{{\itshape\color{muted}#4}\par}%
  \vspace{0.3em}
  \endgroup
}

% #1 role held (muted, second-line-left)
% #2 organization / venue (bold, top-left)
% #3 URL (muted link, second-line-left, after role with bullet) — may be empty
% #4 dates (italic muted, top-right)
\newcommand{\cvservice}[4]{%
  \begingroup
  \setlength{\tabcolsep}{0pt}
  \begin{tabularx}{\textwidth}{@{}X r@{}}
    \textbf{#2} & \textit{\color{muted} #4}\\
    \ifstrempty{#1#3}{\relax}{%
      {\color{muted}%
        \ifstrempty{#1}{}{#1\ifstrempty{#3}{}{ \textperiodcentered{} }}%
        \ifstrempty{#3}{}{\href{#3}{\color{accent}#3}}%
      }%
    } & \\
  \end{tabularx}%
  \vspace{0.3em}
  \endgroup
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
  \par\vspace{1pt}{\small\color{muted}\textit{Award}~\textperiodcentered~#1}}
\newcommand{\pubcoverage}[1]{%
  \par\vspace{1pt}{\small\color{muted}\textit{Coverage}~\textperiodcentered~#1}}

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
