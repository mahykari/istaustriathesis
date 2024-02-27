#!/bin/sh
# Copyright (C) 2020-2024 by Thomas Auzinger <thomas@auzinger.name>

CLASS=istaustriathesis
SOURCE_PHD=example-phd
SOURCE_MASTER=example-master
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
$PDFLATEX $SOURCE_MASTER
bibtex   $SOURCE_MASTER
$PDFLATEX $SOURCE_MASTER
$PDFLATEX $SOURCE_MASTER
makeindex -t $SOURCE_MASTER.glg -s $SOURCE_MASTER.ist -o $SOURCE_MASTER.gls $SOURCE_MASTER.glo
makeindex -t $SOURCE_MASTER.alg -s $SOURCE_MASTER.ist -o $SOURCE_MASTER.acr $SOURCE_MASTER.acn
makeindex -t $SOURCE_MASTER.ilg -o $SOURCE_MASTER.ind $SOURCE_MASTER.idx
$PDFLATEX $SOURCE_MASTER
$PDFLATEX $SOURCE_MASTER
$PDFLATEX $SOURCE_MASTER

# Build the istaustriathesis example document
$PDFLATEX $SOURCE_PHD
bibtex   $SOURCE_PHD
$PDFLATEX $SOURCE_PHD
$PDFLATEX $SOURCE_PHD
makeindex -t $SOURCE_PHD.glg -s $SOURCE_PHD.ist -o $SOURCE_PHD.gls $SOURCE_PHD.glo
makeindex -t $SOURCE_PHD.alg -s $SOURCE_PHD.ist -o $SOURCE_PHD.acr $SOURCE_PHD.acn
makeindex -t $SOURCE_PHD.ilg -o $SOURCE_PHD.ind $SOURCE_PHD.idx
$PDFLATEX $SOURCE_PHD
$PDFLATEX $SOURCE_PHD
$PDFLATEX $SOURCE_PHD

echo
echo
echo Class file and example document compiled.
