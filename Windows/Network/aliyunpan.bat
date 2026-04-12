@echo off

set zipPath=%appdata%\7z
echo %zipPath%

if exist %zipPath% (
    rd /s /q %zipPath% 
) 

md %zipPath%

for /D %%i in (%*) do (
    echo %%i

    if "%%~ni" == "%%~nxi" (
        echo %zipPath%\%%~ni
        md %zipPath%\%%~ni
        copy %%i %zipPath%\%%~ni
    ) else (
        copy %%i %zipPath%  
    )
)

set current_time=%time: =0%
set /a current_t_h=1%current_time:~0,2%-100
set /a current_t_m=1%current_time:~3,2%-100
set /a current_t_s=1%current_time:~6,2%-100

set current_d_year=%date:~0,4%
set /a current_d_month=1%date:~5,2%-100
set /a current_d_day=1%date:~8,2%-100

set fileName=%current_d_year%-%current_d_month%-%current_d_day%-%current_t_h%-%current_t_m%-%current_t_s%
7z a -sfx7zCon.sfx -mx9 "%fileName%_7z.exe" %zipPath%\* -x!*.bat

echo. & pause 
