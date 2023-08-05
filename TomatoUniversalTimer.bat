@echo off 
setlocal enabledelayedexpansion

set /p add_h=输入小时:
set /p add_m=输入分钟:
set /p add_s=输入秒针:
set /p input=输入提示:

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

if "%input%" neq "" (
	set input_=%input%
) else (
	set input_="game is over"
)

rem Get the time from WMI - at least that's a format we can work with
set X=
for /f "skip=1 delims=" %%x in ('wmic os get localdatetime') do if not defined X set X=%%x
echo.%X%

rem dissect into parts
set DATE.YEAR=%X:~0,4%
set DATE.MONTH=%X:~4,2%
set DATE.DAY=%X:~6,2%
set DATE.HOUR=%X:~8,2%
set DATE.MINUTE=%X:~10,2%
set DATE.SECOND=%X:~12,2%
set DATE.FRACTIONS=%X:~15,6%
set DATE.OFFSET=%X:~21,4%

echo %DATE.YEAR%-%DATE.MONTH%-%DATE.DAY% %DATE.HOUR%:%DATE.MINUTE%:%DATE.SECOND%

echo input_h=%input_h%
echo input_m=%input_m%
echo input_s=%input_s%


set init_time=%time: =0%
set init_h=%init_time:~0,2%
set init_m=%init_time:~3,2%
set init_s=%init_time:~6,2%
echo %init_h%:%init_m%:%init_s%


set /a end_h=1%init_h%-100+%input_h%
set /a end_m=1%init_m%-100+%input_m%
set /a end_s=1%init_s%-100+%input_s%
echo %end_h%:%end_m%:%end_s%

set current_year=%DATE.YEAR%
set current_month=%DATE.MONTH:~1,1%
set current_day=%DATE.DAY:~1,1%
echo %current_year%_%current_month%_%current_day%


if %end_s% GEQ 60 (
	set /a next_m=%end_s%/60
	echo a=!next_m!
	set /a end_s=!end_s!%%60
	echo aa=!end_s!
	set /a end_m=%end_m%+!next_m!
	echo aam=!end_m!
	echo ab=%end_h%:!end_m!:!end_s!
	if !end_m! GEQ 60 (
		set /a next_h=!end_m!/60
		set /a end_m=!end_m!%%60
		set /a end_h=%end_h%+!next_h!
		echo abc=!end_h!:!end_m!:!end_s!
	)
) else if %end_m% GEQ 60 (
	set /a next_h=!end_m!/60
	set /a end_m=!end_m!%%60
	set /a end_h=%end_h%+!next_h!
	echo abcd=!end_h!:!end_m!:!end_s!
)


rem 跨天
if %end_h% GEQ 24 (
	rem 计算跨过多少天
	set /a need_day=%end_h%/24
	echo need_day=!need_day!
	rem 计算当月取余天数
	set /a end_h=%end_h%%%24
	echo end_datetime=!end_h!:!end_m!:!end_s!
	set current_month=%current_month%
	echo current_month_=!current_month!

	call:monthcall
	echo !current_month! month has !current_month_day!
	set /a current_month_remain_day=!current_month_day!-%current_day%
	echo current_month_remain_day=!current_month_remain_day!

	goto listloop
) else (
	rem 没有跨天	
	set calc_date_time_no_day=%current_year%-%current_month%-%current_day% %end_h%:%end_m%:%end_s%
	echo calc_date_time_no_day=!calc_date_time_no_day!

	goto start

)



EXIT /B %ERRORLEVEL% 

:listloop

rem 没有跨月	
if !current_month_remain_day! GEQ !need_day! (
	goto endcall

) else (
	rem 有跨月	
	set /a current_month=%current_month%+1
	call:monthcall
	echo %current_month% month has_ !current_month_day!
	set /a current_month_remain_day=!current_month_remain_day!+!current_month_day!
	echo current_month_remain_day=!current_month_remain_day!
	if !current_month_remain_day! GEQ !need_day! (
		goto endcall

	) else (
		if !current_month! equ 12 (
			set current_month=0
			set /a current_year=%current_year%+1
			echo current_month=!current_month!
			
		)
		call:listloop
	)
)


goto:eof


:endcall
set /a remain_day=!current_month_remain_day!-!need_day!
set /a current_day=!current_month_day!-!remain_day!
echo Over_Datetime=%current_year%_%current_month%_!current_day!
goto start

goto:eof


:start
choice /t 1 /d y /n >nul

set current_time=%time: =0%
set /a current_t_h=1%current_time:~0,2%-100
set /a current_t_m=1%current_time:~3,2%-100
set /a current_t_s=1%current_time:~6,2%-100

set current_d_year=%DATE.YEAR%
set /a current_d_month=1%DATE.MONTH%-100
set /a current_d_day=1%DATE.DAY%-100


echo Current_Datatime:%current_d_year%_%current_d_month%_%current_d_day% %current_t_h%:%current_t_m%:%current_t_s%
echo Expiry_Datetime:%current_year%_%current_month%_!current_day! %end_h%:%end_m%:%end_s%
echo.

if %current_d_year% GEQ !current_year! (
	if %current_d_month% GEQ !current_month! (
		if %current_d_day% GEQ !current_day! (
			if %current_t_h% GEQ %end_h% (
				if %current_t_m% GEQ %end_m% (
					if %current_t_s% GEQ %end_s% (
						goto over
					)
				)
			)
		)
	)
)
goto start
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
echo %current_year%-%current_month%-%current_day%-%current_month_day%
goto:eof


:over
msg * /time 3600 "%input_%"
goto:eof


exit