@echo off

cd /D "%cd%\node_modules"
echo %cd%

set   CurTime=%time%
set   mm=%CurTime:~3,2%
set   ss=%CurTime:~6,2%
set   beforeDateTime=%mm%:%ss%


for /d %%i in (*.*) do (
  echo %%i
  rd /s /q "%%i"
)


for  %%i in (*.*) do (
  del /s /q "%%i"
)

set   CurTime=%time%
set   mm=%CurTime:~3,2%
set   ss=%CurTime:~6,2%
set   afterDateTime=%mm%:%ss%
set   beforeDateTime
set   afterDateTime

cd ..
echo Clear OVER!
echo. & pause 
