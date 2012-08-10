let g:Tex_ViewRule_ps = 'gv'
let g:Tex_ViewRule_pdf = 'zathura'
let g:Tex_ViewRule_dvi = 'xdvi'
let g:Tex_FormatDependency_ps = 'dvi,ps'

" To compile with pdflatex, comment out the pdf dvi,pdf format dependency.
" Also, make only the pdflatex compile rule active.
"let g:Tex_FormatDependency_pdf = 'dvi,pdf'
"let g:Tex_CompileRule_pdf =  'dvipdf $*.dvi $*.pdf' "dvipdf does .ps well. Also hyperref
"let g:Tex_CompileRule_pdf =  'dvipdfm $*.dvi' "dvipdfm does hyperref well
let g:Tex_CompileRule_pdf =  'pdflatex $*' "pdflatex is fast & has no dependency, but doesn't do .ps

let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
