@echo off
set "input_file=C:\Users\LENOVO\Documents\Business Intelligence Specialist\Netflix\netflix_titles.csv"
set "output_file=temp22.csv"

:: Ejecuta el script de PowerShell para eliminar los saltos de línea


powershell -Command "((Get-Content '%input_file%' -Raw) -replace '(?<!\"[^\r\n]*)\r?\n(?![^\r\n]*\")', ' ') | Set-Content '%output_file%'"

pause
:: Reemplazar el archivo original con el archivo temporal
move /y "%output_file%" "%input_file%"

echo Proceso completado. Archivo guardado como %output_file%.
pause


