rem Copyright (C) 2020-2023 by Thomas Auzinger <thomas@auzinger.name>

@echo off
set CLASS=istaustriathesis
set SOURCE=example
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
pdflatex %SOURCE%
bibtex   %SOURCE%
pdflatex %SOURCE%
pdflatex %SOURCE%
makeindex -t %SOURCE%.glg -s %SOURCE%.ist -o %SOURCE%.gls %SOURCE%.glo
makeindex -t %SOURCE%.alg -s %SOURCE%.ist -o %SOURCE%.acr %SOURCE%.acn
makeindex -t %SOURCE%.ilg -o %SOURCE%.ind %SOURCE%.idx
pdflatex %SOURCE%
pdflatex %SOURCE%
pdflatex %SOURCE%

@echo off
echo.
echo.
echo Class file and example document compiled.
pause
