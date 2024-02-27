rem Copyright (C) 2020-2023 by Thomas Auzinger <thomas@auzinger.name>

@echo off
set CLASS=istaustriathesis
set SOURCE_PHD=example-phd
set SOURCE_MASTER=example-master
@echo on

rem Build istaustriathesis documentation
pdflatex %CLASS%.dtx
pdflatex %CLASS%.dtx
makeindex -s gglo.ist -o %CLASS%.gls %CLASS%.glo
makeindex -s gind.ist -o %CLASS%.ind %CLASS%.idx
pdflatex %CLASS%.dtx
pdflatex %CLASS%.dtx
pdflatex %CLASS%.dtx

rem Build the istaustriathesis class file
pdflatex %CLASS%.ins

rem Build the istaustriathesis example document
pdflatex %SOURCE_MASTER%
bibtex   %SOURCE_MASTER%
pdflatex %SOURCE_MASTER%
pdflatex %SOURCE_MASTER%
makeindex -t %SOURCE_MASTER%.glg -s %SOURCE_MASTER%.ist -o %SOURCE_MASTER%.gls %SOURCE_MASTER%.glo
makeindex -t %SOURCE_MASTER%.alg -s %SOURCE_MASTER%.ist -o %SOURCE_MASTER%.acr %SOURCE_MASTER%.acn
makeindex -t %SOURCE_MASTER%.ilg -o %SOURCE_MASTER%.ind %SOURCE_MASTER%.idx
pdflatex %SOURCE_MASTER%
pdflatex %SOURCE_MASTER%
pdflatex %SOURCE_MASTER%

rem Build the istaustriathesis example document
pdflatex %SOURCE_PHD%
bibtex   %SOURCE_PHD%
pdflatex %SOURCE_PHD%
pdflatex %SOURCE_PHD%
makeindex -t %SOURCE_PHD%.glg -s %SOURCE_PHD%.ist -o %SOURCE_PHD%.gls %SOURCE_PHD%.glo
makeindex -t %SOURCE_PHD%.alg -s %SOURCE_PHD%.ist -o %SOURCE_PHD%.acr %SOURCE_PHD%.acn
makeindex -t %SOURCE_PHD%.ilg -o %SOURCE_PHD%.ind %SOURCE_PHD%.idx
pdflatex %SOURCE_PHD%
pdflatex %SOURCE_PHD%
pdflatex %SOURCE_PHD%

@echo off
echo.
echo.
echo Class file and example document compiled.
pause
