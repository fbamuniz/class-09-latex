#### makefile, 2021/01/05
#### Copyright (C) 2021 Luiz E. M. Lima (luizeduardomlima@gmail.com)
##
## This makefile provides commands to make compiling LaTeX source files.

## Source and base name
src :=	fatec-article.tex
ifeq ($(strip $(src)),)
  src :=	$(shell read -p "Enter source filename with 3-digits extension: " src; echo $$src)
endif
base_name =	$(basename $(src))

## Command lines: texfot, latex, pdflatex, xelatex, lualatex, dvips, and ps2pdf
cmd_texfot       =	texfot --quiet
cmd_ps2pdf       =	ps2pdf ${base_name}.ps ${base_name}.pdf
cmd_dvips        =	dvips -q -P pdf ${base_name}.dvi -o ${base_name}.ps
cmd_latex        =	${cmd_texfot} latex -file-line-error -draftmode ${src}
cmd_latex_end    =	${cmd_texfot} latex -file-line-error ${src}
cmd_pdflatex     =	${cmd_texfot} pdflatex -file-line-error -draftmode ${src}
cmd_pdflatex_end =	${cmd_texfot} pdflatex -file-line-error ${src}
cmd_xelatex      =	${cmd_texfot} xelatex -file-line-error -no-pdf ${src}
cmd_xelatex_end  =	${cmd_texfot} xelatex -file-line-error ${src}
cmd_lualatex     =	${cmd_texfot} lualatex -file-line-error -draftmode ${src}
cmd_lualatex_end =	${cmd_texfot} lualatex -file-line-error ${src}

## biber or bibtex command line
prg_bib :=	biber
ifeq ($(strip $(prg_bib)),)
  cmd_bib =	@echo "Warning: no biber or bibtex execution."
  ifneq "$(findstring biber, $(MAKECMDGOALS))" ""
    prg_bib =	biber
    cmd_bib =	${prg_bib} ${base_name}
    biber:
			@echo "Info: pdf done using biber."
  endif
  ifneq "$(findstring bibtex, $(MAKECMDGOALS))" ""
    prg_bib =	bibtex
    cmd_bib =	${prg_bib} ${base_name}
    bibtex:
			@echo "Info: pdf done using bibtex."
  endif
else
  cmd_bib =	${prg_bib} ${base_name}
endif

## makeindex command line
prg_mkidx :=
ifeq ($(strip $(prg_mkidx)),)
  cmd_mkidx =	@echo "Warning: no makeindex execution."
  ifneq "$(findstring mkidx, $(MAKECMDGOALS))" ""
    prg_mkidx =	makeindex
    cmd_mkidx =	${prg_mkidx} ${base_name}.idx
    mkidx:
			@echo "Info: pdf done using makeindex."
  endif
else
  cmd_mkidx =	${prg_mkidx} ${base_name}.idx
endif

## Checks for errors
check:
	chktex ${src} || true

## Removes intermediate files
inter_files=	*.aux *.log *.out *.bbl *.bcf *.blg *.brf \
	*.lo? *.tdo *.toc \
	*.gst *.gl? *.ist *.ilg *.idx *.ind \
	*.acn *.acn? *.acr *.acr? *.alg *.alg? *.nl? \
	*.nav *.snm *.mw *.run.xml \
	${base_name}.xdv ${base_name}.dvi ${base_name}*.ps
clean:
	rm -f ${inter_files}
	rm -f `find . -name "*.aux"`
	rm -f `find . -name "*.log"`

## Creates dvi file
dvi:
	${cmd_latex}
	${cmd_bib}
	${cmd_mkidx}
	${cmd_latex}
	clear
	${cmd_latex_end}

## Creates ps file
ps:	dvi
	${cmd_dvips}

## Creates pdf file using latex, pdflatex, xelatex, and lualatex
pdf1:	ps
	${cmd_ps2pdf}
pdf2:
	${cmd_pdflatex}
	${cmd_bib}
	${cmd_mkidx}
	${cmd_pdflatex}
	clear
	${cmd_pdflatex_end}
pdf3:
	${cmd_xelatex}
	${cmd_bib}
	${cmd_mkidx}
	${cmd_xelatex}
	clear
	${cmd_xelatex_end}
pdf4:
	${cmd_lualatex}
	${cmd_bib}
	${cmd_mkidx}
	${cmd_lualatex}
	clear
	${cmd_lualatex_end}

## Creates pdf file and removes intermediate files
all1:	pdf1 clean
all2:	pdf2 clean
all3:	pdf3 clean
all4:	pdf4 clean

## Shows help
help:
	@echo "##############################################################################"
	@echo "# Commands to make compiling LaTeX source files"
	@echo "##############################################################################"
	@echo "# make check:     checks for errors using chktex."
	@echo "# make clean:     removes intermediate files."
	@echo "# make dvi:       creates dvi, converts tex-dvi."
	@echo "# make ps:        creates ps, converts tex-dvi-ps."
	@echo "# make pdf1:      creates pdf using latex, converts tex-dvi-ps-pdf."
	@echo "# make pdf2:      creates pdf using pdflatex, converts tex-pdf."
	@echo "# make pdf3:      creates pdf using xelatex, converts tex-pdf."
	@echo "# make pdf4:      creates pdf using lualatex, converts tex-pdf."
	@echo "# make all1:      creates pdf using latex and removes intermediate files."
	@echo "# make all2:      creates pdf using pdflatex and removes intermediate files."
	@echo "# make all3:      creates pdf using xelatex and removes intermediate files."
	@echo "# make all4:      creates pdf using lualatex and removes intermediate files."
	@echo "# make 1 biber:   uses biber to generate references with option 1."
	@echo "# make 1 bibtex:  uses bibtex to generate references with option 1."
	@echo "# make 1 2 mkidx: uses makeindex to generate index with options 1 and 2."
	@echo "# make help:      shows help."
	@echo "# option 1:       dvi, ps, pdf1, pdf2, pdf3, pdf4, all1, all2, all3, or all4."
	@echo "# option 2:       biber or bibtex."
	@echo "##############################################################################"
