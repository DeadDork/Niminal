let g:Tex_ViewRule_dvi = 'xdvi'
let g:Tex_ViewRule_ps = 'evince'
"let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_ViewRule_pdf = 'apvlv'
"let g:Tex_FormatDependency_pdf = 'dvi,pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'
let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf =  'dvipdf $*.dvi $*.pdf' "dvipdf does .ps well. Also hyperref
let g:Tex_CompileRule_pdf =  'pdflatex $*' "pdflatex is fast & has no dependency, but doesn't do .ps
"let g:Tex_CompileRule_pdf =  'dvipdfm $*.dvi' "dvipdfm does hyperref well
