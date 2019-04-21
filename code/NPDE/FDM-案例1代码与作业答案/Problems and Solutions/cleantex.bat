@echo off
echo clean started at (%TIME%)
del ctextemp*
del *.aux
del *.tex.bak
del *.log
del *.nav
del *.out
del *.djs
del *.out.bak
del *.snm
del *.ps
del *.dvi
del *.synctex.gz*
del *.idx
del *.toc
echo clean finished at (%TIME%)