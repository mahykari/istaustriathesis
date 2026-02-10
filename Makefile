# Makefile for istaustriathesis LaTeX class
# Copyright (C) 2020-2024 by Thomas Auzinger <thomas@auzinger.name>

# Configuration
CLASS = istaustriathesis
SOURCE_PHD = example-phd
SOURCE_MASTER = example-master
PDFLATEX = pdflatex
BIBTEX = bibtex
MAKEINDEX = makeindex

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

# Build both example documents
.PHONY: examples
examples: example-master example-phd

# Build the master example
.PHONY: example-master
example-master: $(SOURCE_MASTER).pdf

$(SOURCE_MASTER).pdf: $(SOURCE_MASTER).tex $(CLASS).cls intro.tex intro.bib
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

# Build the PhD example
.PHONY: example-phd
example-phd: $(SOURCE_PHD).pdf

$(SOURCE_PHD).pdf: $(SOURCE_PHD).tex $(CLASS).cls intro.tex intro.bib
	$(PDFLATEX) $(SOURCE_PHD)
	$(BIBTEX) $(SOURCE_PHD)
	$(PDFLATEX) $(SOURCE_PHD)
	$(PDFLATEX) $(SOURCE_PHD)
	$(MAKEINDEX) -t $(SOURCE_PHD).glg -s $(SOURCE_PHD).ist -o $(SOURCE_PHD).gls $(SOURCE_PHD).glo
	$(MAKEINDEX) -t $(SOURCE_PHD).alg -s $(SOURCE_PHD).ist -o $(SOURCE_PHD).acr $(SOURCE_PHD).acn
	$(MAKEINDEX) -t $(SOURCE_PHD).ilg -o $(SOURCE_PHD).ind $(SOURCE_PHD).idx
	$(PDFLATEX) $(SOURCE_PHD)
	$(PDFLATEX) $(SOURCE_PHD)
	$(PDFLATEX) $(SOURCE_PHD)

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
	@rm -f $(SOURCE_PHD).aux $(SOURCE_PHD).bbl $(SOURCE_PHD).blg \
	       $(SOURCE_PHD).log $(SOURCE_PHD).out $(SOURCE_PHD).toc \
	       $(SOURCE_PHD).lof $(SOURCE_PHD).lot $(SOURCE_PHD).loa \
	       $(SOURCE_PHD).acn $(SOURCE_PHD).acr $(SOURCE_PHD).alg \
	       $(SOURCE_PHD).glg $(SOURCE_PHD).glo $(SOURCE_PHD).gls \
	       $(SOURCE_PHD).glsdefs $(SOURCE_PHD).idx $(SOURCE_PHD).ilg \
	       $(SOURCE_PHD).ind $(SOURCE_PHD).ist $(SOURCE_PHD).mw \
	       $(SOURCE_PHD).tdo $(SOURCE_PHD).xmpdata
	@echo "Auxiliary files cleaned."

# Clean all artifacts including PDFs
.PHONY: cleanall
cleanall: clean
	@echo "Cleaning all generated files..."
	@rm -f $(CLASS).pdf $(CLASS).cls
	@rm -f $(SOURCE_MASTER).pdf
	@rm -f $(SOURCE_PHD).pdf
	@echo "All generated files cleaned."

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all         - Build class file, documentation, and examples (default)"
	@echo "  build       - Same as 'all'"
	@echo "  class       - Build only the class file (.cls)"
	@echo "  doc         - Build only the class documentation"
	@echo "  examples    - Build both example documents"
	@echo "  example-master - Build the master thesis example"
	@echo "  example-phd    - Build the PhD thesis example"
	@echo "  clean       - Remove auxiliary files (keep PDFs)"
	@echo "  cleanall    - Remove all generated files including PDFs"
	@echo "  help        - Show this help message"
