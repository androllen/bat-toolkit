@echo off
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

echo %DATE.YEAR%-%DATE.MONTH%-%DATE.DAY% %DATE.HOUR%:%DATE.MINUTE%:%DATE.SECOND%.%DATE.FRACTIONS%


set current_year=%date:~0,4%
set current_month=%date:~5,2%
set current_day=%date:~8,2%

set /a current_d_day_=1%DATE.DAY%-100
set /a current_d_nonth_=1%DATE.MONTH%-100

echo %date%_%current_year%_%current_month%_%current_day%_%current_d_day_%_%current_d_nonth_%