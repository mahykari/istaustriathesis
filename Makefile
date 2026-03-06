# Makefile for istaustriathesis LaTeX class
# Copyright (C) 2020-2024 by Thomas Auzinger <thomas@auzinger.name>

# Configuration
CLASS = istaustriathesis
SOURCE_MASTER = master
PDFLATEX = pdflatex
BIBTEX = bibtex
MAKEINDEX = makeindex
GS = gs
PDFA_ICC = /usr/share/texlive/texmf-dist/tex/generic/colorprofiles/sRGB.icc
SUBMISSION = 2026_Karimi_Mahyar_Thesis.pdf

# LaTeX auxiliary file extensions
AUX_EXTENSIONS = aux bbl blg log out toc lof lot loa \
                 acn acr alg glg glo gls glsdefs \
                 idx ilg ind ist mw tdo xmpdata

# All auxiliary files
AUX_FILES = $(foreach ext,$(AUX_EXTENSIONS),$(CLASS).$(ext) $(SOURCE_PHD).$(ext) $(SOURCE_MASTER).$(ext))

# Default target
.PHONY: all
all: class doc examples

# Build everything
.PHONY: build
build: all

# Build the class file
.PHONY: class
class: $(CLASS).cls

$(CLASS).cls: $(CLASS).ins $(CLASS).dtx
	$(PDFLATEX) $(CLASS).ins

# Build the class documentation
.PHONY: doc
doc: $(CLASS).pdf

$(CLASS).pdf: $(CLASS).dtx $(CLASS).cls
	$(PDFLATEX) $(CLASS).dtx
	$(PDFLATEX) $(CLASS).dtx
	$(MAKEINDEX) -s gglo.ist -o $(CLASS).gls $(CLASS).glo
	$(MAKEINDEX) -s gind.ist -o $(CLASS).ind $(CLASS).idx
	$(PDFLATEX) $(CLASS).dtx
	$(PDFLATEX) $(CLASS).dtx
	$(PDFLATEX) $(CLASS).dtx

# Build the master thesis
.PHONY: examples
examples: master

# Chapter and bibliography sources
CHAPTERS = $(wildcard chapters/*.tex)
FIGURES  = $(wildcard chapters/Figures/*/*.csv)
BIBS     = references.bib intro.bib

# Build the master thesis
.PHONY: master
master: $(SOURCE_MASTER).pdf

$(SOURCE_MASTER).pdf: $(SOURCE_MASTER).tex $(CLASS).cls $(CHAPTERS) $(FIGURES) $(BIBS) intro.tex
	$(PDFLATEX) $(SOURCE_MASTER)
	$(BIBTEX) $(SOURCE_MASTER)
	$(PDFLATEX) $(SOURCE_MASTER)
	$(PDFLATEX) $(SOURCE_MASTER)
	$(MAKEINDEX) -t $(SOURCE_MASTER).glg -s $(SOURCE_MASTER).ist -o $(SOURCE_MASTER).gls $(SOURCE_MASTER).glo
	$(MAKEINDEX) -t $(SOURCE_MASTER).alg -s $(SOURCE_MASTER).ist -o $(SOURCE_MASTER).acr $(SOURCE_MASTER).acn
	$(MAKEINDEX) -t $(SOURCE_MASTER).ilg -o $(SOURCE_MASTER).ind $(SOURCE_MASTER).idx
	$(PDFLATEX) $(SOURCE_MASTER)
	$(PDFLATEX) $(SOURCE_MASTER)
	$(PDFLATEX) $(SOURCE_MASTER)

# Clean auxiliary files (keeps PDFs)
.PHONY: clean
clean:
	@echo "Cleaning auxiliary files..."
	@rm -f $(CLASS).aux $(CLASS).bbl $(CLASS).blg $(CLASS).log $(CLASS).out \
	       $(CLASS).toc $(CLASS).lof $(CLASS).lot $(CLASS).loa \
	       $(CLASS).acn $(CLASS).acr $(CLASS).alg $(CLASS).glg $(CLASS).glo \
	       $(CLASS).gls $(CLASS).glsdefs $(CLASS).idx $(CLASS).ilg $(CLASS).ind \
	       $(CLASS).ist $(CLASS).mw $(CLASS).tdo $(CLASS).xmpdata $(CLASS).hd
	@rm -f $(SOURCE_MASTER).aux $(SOURCE_MASTER).bbl $(SOURCE_MASTER).blg \
	       $(SOURCE_MASTER).log $(SOURCE_MASTER).out $(SOURCE_MASTER).toc \
	       $(SOURCE_MASTER).lof $(SOURCE_MASTER).lot $(SOURCE_MASTER).loa \
	       $(SOURCE_MASTER).acn $(SOURCE_MASTER).acr $(SOURCE_MASTER).alg \
	       $(SOURCE_MASTER).glg $(SOURCE_MASTER).glo $(SOURCE_MASTER).gls \
	       $(SOURCE_MASTER).glsdefs $(SOURCE_MASTER).idx $(SOURCE_MASTER).ilg \
	       $(SOURCE_MASTER).ind $(SOURCE_MASTER).ist $(SOURCE_MASTER).mw \
	       $(SOURCE_MASTER).tdo $(SOURCE_MASTER).xmpdata
	@echo "Auxiliary files cleaned."

# Clean all artifacts including PDFs
.PHONY: cleanall
cleanall: clean
	@echo "Cleaning all generated files..."
	@rm -f $(CLASS).pdf $(CLASS).cls
	@rm -f $(SOURCE_MASTER).pdf $(SOURCE_MASTER)-pdfa2b.pdf
	@echo "All generated files cleaned."

# Post-process master.pdf into a PDF/A-2b compliant file via Ghostscript.
# Requires the full build (make master) to have been run first.
.PHONY: pdfa
pdfa: $(SOURCE_MASTER)-pdfa2b.pdf

$(SOURCE_MASTER)-pdfa2b.pdf: $(SOURCE_MASTER).pdf
	@echo "Converting $(SOURCE_MASTER).pdf to PDF/A-2b..."
	@cp /usr/share/ghostscript/$(shell gs --version)/lib/PDFA_def.ps /tmp/pdfa2b_def.ps
	@sed -i "s|/ICCProfile (srgb.icc)|/ICCProfile ($(PDFA_ICC))|" /tmp/pdfa2b_def.ps
	@sed -i "s|/Title (Title)|/Title (Privacy-Preserving Runtime Verification)|" /tmp/pdfa2b_def.ps
	@$(GS) -dBATCH -dNOPAUSE -dNOOUTERSAVE \
	  -sDEVICE=pdfwrite \
	  -dCompatibilityLevel=1.7 \
	  -dPDFA=2 \
	  -dPDFACompatibilityPolicy=1 \
	  -dEmbedAllFonts=true \
	  -dSubsetFonts=true \
	  -sColorConversionStrategy=sRGB \
	  -sOutputFile=$@ \
	  /tmp/pdfa2b_def.ps $<
	@echo "PDF/A-2b output written to $@"

# Copy master.pdf directly to the ISTA submission filename.
# pdflatex+pdfx already produces a valid PDF/A-2b file (sRGB.icc OutputIntent
# embedded, conformance claim in XMP).  The Ghostscript post-processing step
# strips the rich XMP metadata and produces an inferior result, so we bypass it.
.PHONY: submit
submit: $(SOURCE_MASTER).pdf
	cp $< $(SUBMISSION)
	@echo "Submission copy written to $(SUBMISSION)"
	git archive HEAD --format=zip -o $(SUBMISSION:.pdf=_src.zip)
	@echo "Source archive written to $(SUBMISSION:.pdf=_src.zip)"

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all            - Build class file, documentation, and example (default)"
	@echo "  build          - Same as 'all'"
	@echo "  class          - Build only the class file (.cls)"
	@echo "  doc            - Build only the class documentation"
	@echo "  examples       - Build the master thesis"
	@echo "  master         - Build the master thesis (use this for your thesis)"
	@echo "  pdfa           - Post-process master.pdf into master-pdfa2b.pdf (PDF/A-2b, via Ghostscript)"
	@echo "  submit         - Copy master-pdfa2b.pdf to $(SUBMISSION) and create source zip"
	@echo "  clean          - Remove auxiliary files (keep PDFs)"
	@echo "  cleanall       - Remove all generated files including PDFs"
	@echo "  help           - Show this help message"
