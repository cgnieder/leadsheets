% --------------------------------------------------------------------------
% the LEADSHEETS package
% 
%   typesetting leadsheets and songbooks
%
% --------------------------------------------------------------------------
% Clemens Niederberger
% E-Mail: contact@mychemistry.eu
% --------------------------------------------------------------------------
% Copyright 2014-2017 Clemens Niederberger
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Clemens Niederberger.
% --------------------------------------------------------------------------
\ProvidesClass{leadsheet}[2017/01/23 v0.5a leadsheets class (part of the leadsheets package)]
\LoadClassWithOptions{scrartcl}

\RequirePackage{leadsheets}

\RequirePackage{etoolbox}
\RequirePackage{translations}

\defleadsheetstranslation{Fallback}{page}{page}
\defleadsheetstranslation{Fallback}{of}{of}
\defleadsheetstranslation{Fallback}{music}{music}
\defleadsheetstranslation{Fallback}{text}{text}
\defleadsheetstranslation{Fallback}{as-played-by}{as played by}
\defleadsheetstranslation{Fallback}{choir}{choir}

\defleadsheetstranslation{German}{page}{Seite}
\defleadsheetstranslation{German}{of}{von}
\defleadsheetstranslation{German}{music}{Musik}
\defleadsheetstranslation{German}{text}{Text}
\defleadsheetstranslation{German}{as-played-by}{wie gespielt von}
\defleadsheetstranslation{German}{choir}{Chor}

\providecommand*\ls@songtitle{}
\providecommand*\ls@songinterpret{}

\definesongproperty{language}

\newbool{ls@comma}
\newrobustcmd*\ls@addcomma{%
  \ifbool{ls@comma}{, }{}%
  \boolfalse{ls@comma}%
}

\newrobustcmd*\ls@printproperty[2]{%
  \ifsongproperty{#1}{%
    \ls@addcomma
    #2%
    \booltrue{ls@comma}%
  }{}%
}

\definesongtitletemplate{leadsheet}{%
  \section*{%
    \songproperty{title}%
    \ifsongproperty{subtitle}{ (\songproperty{subtitle})}{}%
  }
  \xdef\ls@songtitle{\songproperty{title}}%
  \ifsongproperty{composer}
    {%
      \ifsongproperty{lyrics}
        {%
          \leadsheetstranslate{lyrics}:
          \printsongpropertylist{lyrics}{ \& }{, }{ \& },
          \booltrue{ls@comma}%
        }
        {}%
      \leadsheetstranslate{music}:
      \printsongpropertylist{composer}{ \& }{, }{ \& }%
      \booltrue{ls@comma}%
    }
    {%
      \ifsongproperty{lyrics}
        {%
          \leadsheetstranslate{lyrics}:
          \printsongpropertylist{lyrics}{ \& }{, }{ \& }%
          \ifsongproperty{music}{, }{}%
          \booltrue{ls@comma}%
        }
        {}%
      \ifsongproperty{music}
        {%
          \ifsongproperty{lyrics}
            {}
            {\leadsheetstranslate{lyrics} \& }%
          \leadsheetstranslate{music}:
          \printsongpropertylist{music}{ \& }{, }{ \& }%
          \booltrue{ls@comma}%
        }
        {}%
    }%
  \ifsongproperty{band}
    {%
      \ls@addcomma
      \leadsheetstranslate{as-played-by}:
      \songproperty{band}%
      \xdef\ls@songinterpret{\songproperty{band}}%
      \booltrue{ls@comma}%
    }{%
      \ifsongproperty{interpret}
        {%
          \ls@addcomma
          \leadsheetstranslate{as-played-by}:
          \songproperty{interpret}%
          \xdef\ls@songinterpret{\songproperty{interpret}}%
          \booltrue{ls@comma}%
        }
        {}%
    }%
  \ifsongproperty{key}
    {%
      \ls@addcomma
      \leadsheetstranslate{key}:
      \expandcode{\writechord{\songproperty{key}}}
    }
    {}%
  \ifsongproperty{language}
    {%
      \ifboolexpr{
        test {\leadsheetsifpackageloaded{babel}} or
        test {\leadsheetsifpackageloaded{poyglossia}}
      }{\expandcode{\noexpand\selectlanguage{\songproperty{language}}}}
      {}%
    }
    {}%
}

\setleadsheets{
  title-template = leadsheet ,
  bar-shortcuts ,
  verse/numbered ,
  verses-format = ,
  verses-label-format = \bfseries ,
  info/format = \itshape ,
  chorus/format = \itshape
}

\RequirePackage{scrlayer-scrpage,zref-totpages}
\pagestyle{scrheadings}
\rohead{}
\cohead{%
  \ifnum\ztotpages>1
    \ifnum\value{page}=1
    \else
      \ls@songtitle
      \ifdefvoid\ls@songinterpret{}{ (\ls@songinterpret)}%
    \fi
  \fi
}
\cofoot{%
  \ifnum\ztotpages>1
    \leadsheetstranslate{page}~\thepage~%
    \leadsheetstranslate{of}~\ztotpages
  \fi
}

\LeadsheetSurvive
\provideversetype{prechorus}[name=Prechorus]
\provideversetype*{prechorus*}[name=Prechorus]

\providerobustcmd*\lsenparen[1]{%
  \expandcode{\noexpand\mklsenparen\mklsenparens{\unexpanded{#1}}}%
}
\providecommand*\mklsenparens{[]}
\providecommand*\mklsenparen[3]{\textup{#1}#3\textup{#2}}

\providerobustcmd*\instruction[1]{\lsenparen{\mkinstruction{#1}}}
\providecommand*\mkinstruction[1]{\emph{#1}}

\providerobustcmd*\choir[1]{\null\qquad\mkchoir{#1}}
\providecommand*\mkchoir[1]{\instruction{\leadsheetstranslate{choir}: #1}}
\LeadsheetEndSurvive

\endinput
2016/08/17 - first version added to `leadsheets'
