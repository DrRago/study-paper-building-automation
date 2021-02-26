# filename of base file
BASE  = bericht

LATEX     = pdflatex -file-line-error
BIBTEX    = biber
MAKEINDEX = makeindex -s $(BASE).ist

# BIBTEX-Style files (*.bst)
export BSTINPUTS := .//:$(BSTINPUTS)

# BIBTEX databases (*.bib)
export BIBINPUTS := .//:$(BIBINPUTS)

# LaTeX styles and classes (*.sty, *.cls)
export TEXINPUTS := .//:$(TEXINPUTS)

# determine remove command for OS
ifdef OS
	RM = del /Q /f /s
else
	RM = rm -f
endif

all: $(BASE).pdf

$(BASE).pdf: *.tex *.bib Makefile
	$(MAKE) clean
	$(LATEX)  $(BASE).tex
	- grep -q "Warning: Citation " $*.log && $(BIBTEX)    $(BASE)
	- [ -f $(BASE).idx ] && $(MAKEINDEX) $(BASE)
	$(LATEX)  $(BASE).tex
	- grep -q "Warning: Citation " $*.log && $(BIBTEX)    $(BASE)
	- [ -f $(BASE).idx ] && $(MAKEINDEX) $(BASE)
	$(BIBTEX) $(BASE)
	$(LATEX)  $(BASE).tex

pdf:
	$(LATEX)  $(BASE)

index:
	$(MAKEINDEX) $(BASE)

bib:
	$(BIBTEX) $(BASE)

# print only error messages
check: $(BASE).pdf
	@echo; echo "*******************************"; echo; echo;
	$(LATEX) -interaction=nonstopmode $(BASE).tex 2>&1  | egrep "LaTeX Warning";	\
	if [ $$? -ne 0 ]; then exit 0; else exit 1; fi

# remove build files
clean:
	$(RM) *.toc *.dvi *.aux *.log *.blg *.bbl *.out *.for   \
	      *.lof *.lol *.lot *.bcf *.run.xml *-blx.bib *.idx \
	      *.ind *.ilg *.blg *.tdo				\
	      *~

# the other one just pretended to clean, this does for sure
realclean: clean
	$(RM) $(BASE).pdf

# create tar archive of project
tar: $(BASE).pdf
	$(MAKE) clean
	D=`pwd`; D=`basename $$D`;		\
	cd ..; 					\
	tar --exclude "*.tar.gz" --exclude RCS  \
	    --exclude Pakete 			\
	    --dereference			\
	    -czvf $$D/latex-vorlage-`date "+%Y-%m-%d"`.tar.gz $$D
