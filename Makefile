SRC = Abstract.tex Conclusions.tex  Future.tex  Introduction.tex  Overview.tex  Problems.tex  Crossplane.tex  main.tex

bib = references.bib
dvi = 
bbl = $(SRC:%.tex=%.bbl)
TARGET = main.pdf
NAME = $(TARGET:%.pdf=%)
LATEX = pdflatex
GLOSSARY = Glossary.gdf

.PHONY: view figs clean all

all: $(TARGET) 

$(dvi): %.dvi: %.tex $(SRC:%.tex=%.bbl)
	latex $< && latex $<

$(NAME).aux: %.aux: %.tex
	@echo "Doing AUX"
	$(LATEX) $<

$(NAME).glx: $(GLOSSARY) $(TARGET:%.pdf=%.aux)
	glosstex $(NAME) $<
	makeindex $(NAME).gxs -o $@ -s glosstex.ist

$(TARGET): %.pdf: %.tex figs $(NAME).aux $(NAME).bbl $(SRC)
	$(LATEX) $<
	$(LATEX) $<

#evince $@ &

view: $(TARGET)
	 evince $< &


gv: $(ps)
	gv $<

$(SRC:%.tex=%.bbl): %.bbl: %.tex $(bib) $(TARGET:%.pdf=%.aux)
	@echo "Doing bib"
	$(LATEX) $<
	bibtex $(NAME)

$(patsubst %.eps,%.pdf,$(wildcard *.eps)): %.pdf: %.eps
	epstopdf --nocompress  $<

pdf:

figs:
#cd images && $(MAKE) all

clean:
	rm -f *~ $(NAME).dvi $(NAME).ps $(NAME).pdf $(NAME).aux $(NAME).toc $(NAME).log $(NAME).out *.bbl *.blg *.glx *.ilg
#	cd figs && make clean
