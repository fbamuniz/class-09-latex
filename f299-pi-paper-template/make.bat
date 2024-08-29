@echo off
REM make.bat, 2021/01/05
REM Copyright (C) 2021 Luiz E. M. Lima (luizeduardomlima@gmail.com)
REM
REM This make.bat provides commands to make compiling LaTeX source files.

REM Sets local variables
setlocal EnableDelayedExpansion

REM Source and base name
set src=utfpr-article.tex
if [%src%] == [] set /p src="Enter source filename with 3-digits extension: "
set base_name=%src:~0,-4%

REM Title
title %base_name%

REM Command lines: texfot, latex, pdflatex, xelatex, lualatex, dvips, and ps2pdf
set "cmd_texfot=texfot --quiet"
set "cmd_ps2pdf=ps2pdf %base_name%.ps %base_name%.pdf"
set "cmd_dvips=dvips -q -P pdf %base_name%.dvi -o %base_name%.ps"
set "cmd_latex=%cmd_texfot% latex -file-line-error -draftmode %src%"
set "cmd_latex_end=%cmd_texfot% latex -file-line-error %src%"
set "cmd_pdflatex=%cmd_texfot% pdflatex -file-line-error -draftmode %src%"
set "cmd_pdflatex_end=%cmd_texfot% pdflatex -file-line-error %src%"
set "cmd_xelatex=%cmd_texfot% xelatex -file-line-error -no-pdf %src%"
set "cmd_xelatex_end=%cmd_texfot% xelatex -file-line-error %src%"
set "cmd_lualatex=%cmd_texfot% lualatex -file-line-error -draftmode %src%"
set "cmd_lualatex_end=%cmd_texfot% lualatex -file-line-error %src%"

REM biber or bibtex command line
set prg_bib=biber
if [%2] == [biber] set prg_bib=biber
if [%2] == [bibtex] set prg_bib=bibtex
if [%prg_bib%] == [] (
  set "cmd_bib=@echo Warning: no biber or bibtex execution."
) else (
  set "cmd_bib=%prg_bib% %base_name%"
)

REM makeindex command line
set prg_mkidx=
if [%3] == [mkidx] set prg_mkidx=makeindex
if [%prg_mkidx%] == [] (
  set "cmd_mkidx=@echo Warning: no makeindex execution."
) else (
  set "cmd_mkidx=%prg_mkidx% %base_name%.idx"
)

REM Checks for errors
if [%1] == [check] chktex %src%

REM Removes intermediate files
set inter_files=*.aux *.log *.out *.bbl *.bcf *.blg *.brf^
  *.lo? *.tdo *.toc^
  *.gst *.gl? *.ist *.ilg *.idx *.ind^
  *.acn *.acn? *.acr *.acr? *.alg *.alg? *.nl?^
  *.nav *.snm *.mw *.run.xml^
  %base_name%.xdv %base_name%.dvi %base_name%*.ps
set "cmd_clean=del /s %inter_files%"
if [%1] == [clean] %cmd_clean%

REM Creates dvi file
set "cmd_dvi=%cmd_latex% & %cmd_bib% & %cmd_mkidx% & %cmd_latex% & cls & %cmd_latex_end%"
if [%1] == [dvi] %cmd_dvi%

REM Creates ps file
set "cmd_ps=%cmd_dvi% & %cmd_dvips%"
if [%1] == [ps] %cmd_ps%

REM Creates pdf file using latex, pdflatex, xelatex, and lualatex
set "cmd_pdf1=%cmd_ps% & %cmd_ps2pdf%"
if [%1] == [pdf1] %cmd_pdf1%
set "cmd_pdf2=%cmd_pdflatex% & %cmd_bib% & %cmd_mkidx% & %cmd_pdflatex% & cls & %cmd_pdflatex_end%"
if [%1] == [pdf2] %cmd_pdf2%
set "cmd_pdf3=%cmd_xelatex% & %cmd_bib% & %cmd_mkidx% & %cmd_xelatex% & cls & %cmd_xelatex_end%"
if [%1] == [pdf3] %cmd_pdf3%
set "cmd_pdf4=%cmd_lualatex% & %cmd_bib% & %cmd_mkidx% & %cmd_lualatex% & cls & %cmd_lualatex_end%"
if [%1] == [pdf4] %cmd_pdf4%

REM Creates pdf file and removes intermediate files
if [%1] == [all1] %cmd_pdf1% & %cmd_clean%
if [%1] == [all2] %cmd_pdf2% & %cmd_clean%
if [%1] == [all3] %cmd_pdf3% & %cmd_clean%
if [%1] == [all4] %cmd_pdf4% & %cmd_clean%

REM Shows help
if [%1] == [help] (
  @echo ##############################################################################
  @echo # Commands to make compiling LaTeX source files
  @echo ##############################################################################
  @echo # make check:     checks for errors using chktex.
  @echo # make clean:     removes intermediate files.
  @echo # make dvi:       creates dvi, converts tex-dvi.
  @echo # make ps:        creates ps, converts tex-dvi-ps.
  @echo # make pdf1:      creates pdf using latex, converts tex-dvi-ps-pdf.
  @echo # make pdf2:      creates pdf using pdflatex, converts tex-pdf.
  @echo # make pdf3:      creates pdf using xelatex, converts tex-pdf.
  @echo # make pdf4:      creates pdf using lualatex, converts tex-pdf.
  @echo # make all1:      creates pdf using latex and removes intermediate files.
  @echo # make all2:      creates pdf using pdflatex and removes intermediate files.
  @echo # make all3:      creates pdf using xelatex and removes intermediate files.
  @echo # make all4:      creates pdf using lualatex and removes intermediate files.
  @echo # make 1 biber:   uses biber to generate references with option 1.
  @echo # make 1 bibtex:  uses bibtex to generate references with option 1.
  @echo # make 1 2 mkidx: uses makeindex to generate index with options 1 and 2.
  @echo # make help:      shows help.
  @echo # option 1:       dvi, ps, pdf1, pdf2, pdf3, pdf4, all1, all2, all3, or all4.
  @echo # option 2:       biber or bibtex.
  @echo ##############################################################################
)

REM Unsets local variables
endlocal
