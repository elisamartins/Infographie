zip -r INF2705_remise_tp3.zip *.cpp *.h *.glsl makefile *.txt  && echo "fichier INF2705_remise_tp3.zip fait avec zip"
IF %ERRORLEVEL% EQU 0 GOTO Fin

echo "Ne sait pas comment faire INF2705_remise_tp3..."

:Fin
