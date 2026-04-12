@echo off
setlocal enabledelayedexpansion

@REM set CURRENT_DATE_STRING=%date:~0,4%%date:~5,2%%date:~8,2%
@REM echo CURRENT_DATE_STRING=%CURRENT_DATE_STRING%
@REM set TIME_STRING_FILL_ZREO=%time: =0%
@REM echo TIME_STRING_FILL_ZREO=%TIME_STRING_FILL_ZREO%


@REM set init_h=%TIME_STRING_FILL_ZREO:~0,2%
@REM set init_m=%TIME_STRING_FILL_ZREO:~3,2%
@REM set init_s=%TIME_STRING_FILL_ZREO:~6,2%
@REM echo %init_h%:%init_m%:%init_s%


@REM set CURRENT_TIME_STRING=%TIME_STRING_FILL_ZREO:~0,2%_%TIME_STRING_FILL_ZREO:~3,2%_%TIME_STRING_FILL_ZREO:~6,2%
@REM echo CURRENT_TIME_STRING=%CURRENT_TIME_STRING%
@REM set CURRENT_DATE_TIME_STRING=%CURRENT_DATE_STRING%_%CURRENT_TIME_STRING%
@REM echo CURRENT_DATE_TIME_STRING=%CURRENT_DATE_TIME_STRING%


@REM if %time:~0,2% LEQ 9 (
@REM 	set dtt=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%
@REM ) else (
@REM 	set dtt=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
@REM )
@REM echo %dtt%

set /p day_number=输入天数:
set current_year=%date:~0,4%
set current_day=%date:~8,2%
set /a current_month=1%date:~5,2%-100
echo current_month=%current_month%


call:monthcall
echo current_month=%current_month% month has %current_month_day%
set /a current_has_day=%current_month_day%-%current_day%
echo this_month_remain_day=%current_has_day%

goto:listloop

:listloop
set /a current_month=%current_month%+1
call:monthcall
echo current_month=%current_month% month has !current_month_day!
set /a current_has_day=!current_has_day!+!current_month_day!
echo this_month_plus_day=!current_has_day!

if !current_has_day! GEQ %day_number% (
	goto:endcall
) else (
	if !current_month! equ 12 (
		set current_month=0
		set /a current_year=%current_year%+1
		echo current_month=!current_month!
	)
	call:listloop
)
goto:eof

:endcall
set /a remain_day=!current_has_day!-%day_number%
set /a re_d=!current_month_day!-!remain_day!
echo over=%current_year%_%current_month%_%re_d%
goto:eof

:monthcall
if %current_month% equ 1 ( set current_month_day=31 )^
else if %current_month% equ 2 (
	@REM yp的值为1时即表示year为闰年，当yp的值为0是即表示year为平年
	set /a isleapyear="^!(current_year %% 4) & ^!(^!(current_year %% 100)) | ^!(current_year %% 400)"
	if !isleapyear! equ 1 (
		set current_month_day=29 
	) else (
		set current_month_day=28
	)
	echo current_month_day=%current_month_day%	
)^
else if %current_month% equ 3 ( set current_month_day=31 )^
else if %current_month% equ 4 ( set current_month_day=30 )^
else if %current_month% equ 5 ( set current_month_day=31 )^
else if %current_month% equ 6 ( set current_month_day=30 )^
else if %current_month% equ 7 ( set current_month_day=31 )^
else if %current_month% equ 8 ( set current_month_day=31 )^
else if %current_month% equ 9 ( set current_month_day=30 )^
else if %current_month% equ 10 ( set current_month_day=31 )^
else if %current_month% equ 11 ( set current_month_day=30 )^
else if %current_month% equ 12 ( set current_month_day=31 )
echo current_month_day_=!current_month_day!
goto:eof


pause >nul


