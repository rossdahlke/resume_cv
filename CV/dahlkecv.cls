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
\RequirePackage[style=apa,sorting=ydnt,backend=biber,defernumbers=true]{biblatex}

\definecolor{accent}{HTML}{414141}
\definecolor{muted}{HTML}{6F6F6F}
\definecolor{rule}{HTML}{BFBFBF}

\AtBeginDocument{\hypersetup{allcolors=accent}}

\IfFontExistsTF{STIX Two Text}{%
  \setmainfont{STIX Two Text}[Ligatures=TeX]%
}{%
  \IfFontExistsTF{Source Serif 4}{\setmainfont{Source Serif 4}[Ligatures=TeX]}{%
    \IfFontExistsTF{EB Garamond}{\setmainfont{EB Garamond}[Ligatures=TeX]}{%
      \setmainfont{Latin Modern Roman}}}%
}

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
%% Bibliography customization
%% --------------------------------------------------------------

% Custom fields `award` and `coverage` are declared in dahlkecv-datamodel.dbx
% and loaded via the biblatex `datamodel=` option above.

% Bold the family name "Dahlke" wherever it appears in author lists.
% Redefine \mkbibnamefamily to bold matching strings. Safe: doesn't affect sorting.
\renewcommand*{\mkbibnamefamily}[1]{%
  \ifboolexpr{
    test {\ifstrequal{#1}{Dahlke}}
    or test {\ifstrequal{#1}{Dahlke*}}
  }{\mkbibbold{#1}}{#1}%
}

% Render "Award" and "Coverage" sub-lines after each entry.
\renewbibmacro*{finentry}{%
  \finentry
  \iffieldundef{award}{}{%
    \par\vspace{1pt}\hspace*{2.3em}%
    {\small\color{muted}\textit{Award}~\textperiodcentered~\printfield{award}}%
  }%
  \iffieldundef{coverage}{}{%
    \par\vspace{1pt}\hspace*{2.3em}%
    {\small\color{muted}\textit{Coverage}~\textperiodcentered~\printfield{coverage}}%
  }%
}

% Bibliography environment: numbered hanging list with descending labels.
% Uses two-pass compilation: first pass records totals to aux; second pass reads them.
\newcounter{cvbibtotal}
\newcommand{\setcvbibtotal}[1]{\csdef{cvbibtotal@#1}{\number#1}}

\defbibenvironment{cvnumbered}
  {\list{%
     \cvbiblabel
   }%
   {\setlength{\labelwidth}{2em}%
    \setlength{\labelsep}{0.6em}%
    \setlength{\leftmargin}{2.6em}%
    \setlength{\itemindent}{0pt}%
    \setlength{\itemsep}{0.55em}%
    \setlength{\parsep}{0pt}%
    \renewcommand{\makelabel}[1]{##1\hss}}%
   \sloppy}
  {\endlist}
  {\item}

% Descending label: highest number at top.
% `cvbibsectiontotal` is set by the caller via \cvbibsection before \printbibliography.
\newcounter{cvbibidx}
\newcommand{\cvbibsectiontotal}{0}
\newcommand{\cvbibsection}[1]{\renewcommand{\cvbibsectiontotal}{#1}\setcounter{cvbibidx}{0}}

\newcommand{\cvbiblabel}{%
  \stepcounter{cvbibidx}%
  \makebox[2em][r]{\textbf{\the\numexpr\cvbibsectiontotal-\value{cvbibidx}+1\relax.}}%
}

\endinput
