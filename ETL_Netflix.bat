@echo off

setlocal enabledelayedexpansion

:: Definir los nombres de los archivos de entrada y salida
set "input_file=C:\Users\LENOVO\Documents\Business Intelligence Specialist\Netflix\netflix_titles.csv"
set "temp_file=temp.csv"


:: Limpiar el archivo de salida anterior si existe
if exist %temp_file% del %temp_file%


:: Definir las columnas a renombrar ya que contiene un nombre que no se debe usar como columna en una BD
set "old_column=cast"
set "new_column=casting"

:: Usar PowerShell para renombrar la columna en un archivo temporal y selecciono las columnas que debo utilizar 


powershell -Command "Import-Csv '%input_file%' | Select-Object @{Name='show_id';Expression={$_.show_id}}, @{Name='type';Expression={$_.type}}, @{Name='title';Expression={$_.title}}, @{Name='director';Expression={$_.director}}, @{Name='%new_column%';Expression={$_.%old_column%}},@{Name='country';Expression={$_.country}}, @{Name='date_added';Expression={$_.date_added}}, @{Name='release_year';Expression={$_.release_year}}, @{Name='rating';Expression={$_.rating}}, @{Name='duration';Expression={$_.duration}}, @{Name='listed_in';Expression={$_.listed_in}},  @{Name='description';Expression={$_.description}} | Export-Csv -Path '%temp_file%' -NoTypeInformation"

:: Reemplazar el archivo original con el archivo temporal
move /y "%temp_file%" "%input_file%"

echo La columna '%old_column%' ha sido renombrada a '%new_column%' en el archivo '%input_file%'.


echo el archivo ya esta listo: 1 -> Se renombraron Columnas 2-> Se eliminaron columnas sin nombre y vacias, se dejan las que se trabajaran 3.-> Se eliminaron Saltos de linea

:: Se creo un usuario Import en postgresql con password= 123456 para cargar automaticamente el archivo a nuestra BD en postgresql (BD_PT_BI_MG)

:: creo una Carpeta (postgresql) en la siguiete ruta "C:\Users\LENOVO\AppData\Roaming" 

:: creo un archivo con extension (.conf) con 2 lineas linea1->hostname:port:database:username:password linea2->localhost:5432:BD_PT_BI_MG:Import:123456

set ejecutable='C:\Program Files\PostgreSQL\17\bin>psql.exe'
set usuario=Import
set db=BD_PT_BI_MG
set copy="COPY tb_contenido FROM 'C:\Users\LENOVO\Documents\Business Intelligence Specialist\Netflix\netflix_titles1.csv' WITH (FORMAT csv, HEADER TRUE,DELIMITER ',',ENCODING 'UTF8');"

echo inicia la importacion.

%ejecutable% -U %usuario% -d %db% -c %copy%

echo finaliza la importacion.

echo Este archivo se puede programar en una tarea programada del equipo, configurando su periodicidad(Diario,Semanal, Mensual...) incluyendo una hora para su ejecucion.


echo La tabla (tb_contenido)en la BD (BD_PT_BI_MG) ya se encuentra lista; se recomienda revisar duplicados sin tener encuenta el campo (show_id) ya que este es un campo identity que es secuencial e incrementa su valor.

echo La visualizacion se genero en power BI alli se trataron los duplicados y cambios en la columna (date_added) para su debido analisis.


pause


