@echo off 
setlocal enabledelayedexpansion

set /p add_h=输入小时:
set /p add_m=输入分钟:
set /p add_s=输入秒针:

if "%add_h%" neq "" (
	set input_h=%add_h%
) else (
	set input_h=0
)

if "%add_m%" neq "" (
	set input_m=%add_m%
) else (
	set input_m=0
)

if "%add_s%" neq "" (
	set input_s=%add_s%
) else (
	set input_s=0
)

@REM echo input_h=%input_h%
@REM echo input_m=%input_m%
@REM echo input_s=%input_s%

set /a input_t=(%input_h%*3600+%input_m%*60+%input_s%)
@REM echo input_t=%input_t%

set init=%time%
set /a init_h=%init:~0,2%
set /a init_m=%init:~3,2%
set /a init_s=%init:~6,2%
set /a end=(%init_h%*3600+%init_m%*60+%init_s%+%input_t%)
@REM echo end=%end%
set /a r_t_h=%end%/3600
set /a r_t_m=(%end%-%r_t_h%*3600)/60
set /a r_t_s=%end%%%60


:start
choice /t 1 /d y /n >nul

set mtime=%time%
set rtime=%mtime:~0,8%
echo 到点时间:%r_t_h%:%r_t_m%:%r_t_s%
echo 当前时间:%rtime%
echo.
set /a run_t_h=%rtime:~0,2%
set /a run_t_m=1%rtime:~3,2%-100
set /a run_t_s=1%rtime:~6,2%-100

if %run_t_h% GEQ %r_t_h% (
	if %run_t_m% GEQ %r_t_m% (
		if %run_t_s% GEQ %r_t_s% (
			goto over
		)
	)
)

goto start

:over
msg * "game is over"

exit