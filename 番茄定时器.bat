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

if %end_s% GEQ 60 (
	set /a end_s=!end_s!-60
	set /a end_m=!end_m!+1
	echo ab=%end_h%:%end_m%:%end_s%
	if !end_m! GEQ 60 (
		set /a end_m=!end_m!-60
		set /a end_h=%end_h%+1
		echo abc=%end_h%:%end_m%:%end_s%
	)
) else if %end_m% GEQ 60 (
	set /a end_m=%end_m%-60
	set /a end_h=%end_h%+1
	echo abcd=%end_h%:%end_m%:%end_s%
)

set date_today_year=%date:~0,4%
set date_today_month=%date:~5,2%
set date_today_day=%date:~8,2%
echo %date_today_year%_%date_today_month%_%date_today_day%
set /a i_d_y_4=%date_today_year%%%4
set /a i_d_y_100=%date_today_year%%%100
set /a i_d_y_400=%date_today_year%%%400
echo i_d_y_4=%i_d_y_4%
echo i_d_y_100=%i_d_y_100%
echo i_d_y_400=%i_d_y_400%

if %i_d_y_4% equ 0 (
	if %i_d_y_100% neq 0 (
		if %i_d_y_400% equ 0 (
			echo run
			set year_=0
		)
	)
) else (
	echo ping
	set year_=1
)


if %date_today_month% equ 1 ( set current_month_day=31 )^
else if %date_today_month% equ 2 (
	if %year_% equ 0 (
		set current_month_day=29
	) else (
		set current_month_day=28
	)
)^
else if %date_today_month% equ 3 ( set current_month_day=31 )^
else if %date_today_month% equ 4 ( set current_month_day=30 )^
else if %date_today_month% equ 5 ( set current_month_day=31 )^
else if %date_today_month% equ 6 ( set current_month_day=30 )^
else if %date_today_month% equ 7 ( set current_month_day=31 )^
else if %date_today_month% equ 8 ( set current_month_day=31 )^
else if %date_today_month% equ 9 ( set current_month_day=30 )^
else if %date_today_month% equ 10 ( set current_month_day=31 )^
else if %date_today_month% equ 11 ( set current_month_day=30 )^
else if %date_today_month% equ 12 ( set current_month_day=31 )

echo %date_today_year%-%date_today_month%-%date_today_day%-%current_month_day%



rem 跨天
if %end_h% GEQ 24 (
	rem 计算跨过多少天
	set /a next_day=%end_h%/24
	echo next_day=!next_day!
	rem 计算当月取余天数
	set /a end_h=%end_h%%%24
	echo end_h=!end_h!
	rem 计算在当月的第几天
	set /a date_today_day=%date_today_day%+!next_day!
	echo date_today_day=!date_today_day!

	if !date_today_day! GTR %current_month_day% (
		rem 计算跨过多少月
		set /a date_today_month=!date_today_day!/%current_month_day%
		echo date_today_month=!date_today_month!
		rem 计算当月取余月数
		set /a date_today_day=!date_today_day!%%%current_month_day%
		echo date_today_day=!date_today_day!
		rem 计算在当年的第几个月
		set /a date_today_month=%date_today_month%+!date_today_month!
		echo date_today_month=!date_today_month!


		if !date_today_month! GTR 12 (
			rem 计算跨过多少月
			set /a next_year=!date_today_month!/12
			rem 计算当月取余月数
			set /a date_today_month=!date_today_month!%%12
			rem 计算在当年的第几个月
			set /a date_today_year=%date_today_year%+!next_year!

			set calc_date_time=!date_today_year!-!date_today_month!-!date_today_day! !end_h!:%end_m%:%end_s%
			echo calc_date_time=!calc_date_time!

		) else (
			rem 没有跨年
			set calc_date_time_no_year=%date_today_year%-!date_today_month!-!date_today_day! !end_h!:%end_m%:%end_s%
			echo calc_date_time_no_year=!calc_date_time_no_year!
		)
	) else (
	rem 没有跨月
		set calc_date_time_no_month=%date_today_year%-%date_today_month%-!date_today_day! !end_h!:%end_m%:%end_s%
		echo calc_date_time_no_month=!calc_date_time_no_month!
	)
) else (
	rem 没有跨天	
	set calc_date_time_no_day=%date_today_year%-%date_today_month%-%date_today_day% %end_h%:%end_m%:%end_s%
	echo calc_date_time_no_day=!calc_date_time_no_day!
)



:start
choice /t 1 /d y /n >nul

set current_time=%time: =0%
set /a current_t_h=1%current_time:~0,2%-100
set /a current_t_m=1%current_time:~3,2%-100
set /a current_t_s=1%current_time:~6,2%-100


set current_d_year=%date:~0,4%
set /a current_d_month=1%date:~5,2%-100
set /a current_d_day=1%date:~8,2%-100


echo current_year_month_day_hour_min_sec:%current_d_year%-%current_d_month%-%current_d_day% %current_t_h%:%current_t_m%:%current_t_s%
echo next_year_month_day_hour_min_sec:!date_today_year!-!date_today_month!-!date_today_day! %end_h%:%end_m%:%end_s%
echo.


if %current_d_year% GEQ !date_today_year! (
	if %current_d_month% GEQ !date_today_month! (
		if %current_d_day% GEQ !date_today_day! (
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

:over
msg * "game is over"


exit