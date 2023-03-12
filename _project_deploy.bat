@echo off
echo "enter 32 to run script:"
set /p id=Enter ID: 
echo %id%

if %id% == 32 (
	mkdir "PMN-PT main"
	cd ./PMN-PT main/

	mkdir "PMN-PT 2023"
	mkdir "Ammeter class"
	mkdir "Lakeshore325"
	mkdir "LCR Keysight matlab"


	cd ./Ammeter class/
	git init
	git remote add origin https://github.com/AleksandrVakulenko/Ammeter_class.git
	git pull origin master

	cd ../Lakeshore325/
	git init
	git remote add origin https://github.com/AleksandrVakulenko/Lakeshore-325.git
	git pull origin master

	cd ../LCR Keysight matlab/
	git init
	git remote add origin https://github.com/AleksandrVakulenko/LCR-Keysight-E4980AL.git
	git pull origin master

	cd ../PMN-PT 2023/
	git init
	git remote add origin https://github.com/AleksandrVakulenko/PMN-PT-2023-measuring-proj.git
	git pull origin master
)