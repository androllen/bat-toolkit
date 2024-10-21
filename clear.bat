@echo off
set  find_dir=0
set "target_folder_name=node_modules"
for /d %%i in (*) do (
    if "%%i"=="%target_folder_name%" (
        set find_dir=1
        echo %%i
    )
)

if %find_dir% equ 1 (

  cd /D "%cd%\node_modules"
  echo %cd%

  for /d %%i in (*.*) do (
    echo %%i
    rd /s /q "%%i"
  )


  for  %%i in (*.*) do (
    del /s /q "%%i"
  )
)

set CurTime=%time: =0%
set curmm=%CurTime:~3,2%
set curss=%CurTime:~6,2%
echo beforeDateTime=%curmm%:%curss%

set current_time=%time: =0%
set mm=%current_time:~3,2%
set ss=%current_time:~6,2%
echo afterDateTime=%mm%:%ss%

cd ..
echo Clear OVER!
echo. & pause 
