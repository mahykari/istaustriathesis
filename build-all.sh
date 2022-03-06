#!/bin/sh
# Copyright (C) 2020-2022 by Thomas Auzinger <thomas@auzinger.name>

CLASS=istaustriathesis
SOURCE=example
# Set a standard executable if no executable is supplied as argument.
PDFLATEX=${1:-pdflatex}

# Build istaustriathesis documentation
$PDFLATEX $CLASS.dtx
$PDFLATEX $CLASS.dtx
makeindex -s gglo.ist -o $CLASS.gls $CLASS.glo
makeindex -s gind.ist -o $CLASS.ind $CLASS.idx
$PDFLATEX $CLASS.dtx
$PDFLATEX $CLASS.dtx
$PDFLATEX $CLASS.dtx

# Build the istaustriathesis class file
$PDFLATEX $CLASS.ins

# Build the istaustriathesis example document
$PDFLATEX $SOURCE
bibtex   $SOURCE
$PDFLATEX $SOURCE
$PDFLATEX $SOURCE
makeindex -t $SOURCE.glg -s $SOURCE.ist -o $SOURCE.gls $SOURCE.glo
makeindex -t $SOURCE.alg -s $SOURCE.ist -o $SOURCE.acr $SOURCE.acn
makeindex -t $SOURCE.ilg -o $SOURCE.ind $SOURCE.idx
$PDFLATEX $SOURCE
$PDFLATEX $SOURCE
$PDFLATEX $SOURCE

echo
echo
echo Class file and example document compiled.
