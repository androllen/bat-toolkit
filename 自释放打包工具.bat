@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: 脚本名称: 智能打包为自释放7z文件
:: 功能描述:
::   1. 自动查找 7z.exe (先查PATH, 再查注册表)
::   2. 等待用户拖放文件/文件夹
::   3. 根据拖放内容智能选择打包方式
::   4. 生成带时间戳的自释放 .exe 文件
:: ============================================================================

:: --- 步骤 1: 查找 7z.exe ---
:: 定义注册表路径和要查询的值名
set "regPath=HKEY_LOCAL_MACHINE\SOFTWARE\7-Zip"
set "valueName=Path1"
set "value64Name=Path64"

set "SEVEN_ZIP_CMD="
echo [步骤 1/4] 正在查找 7z.exe...

:: 方法一: 在系统环境变量 PATH 中查找
for /f "delims=" %%i in ('where 7z.exe 2^>nul') do (
    set "SEVEN_ZIP_CMD=%%i"
    goto :found_seven_zip
)

:: 方法二: 如果 PATH 中没找到，则查询注册表
echo   - 在系统PATH中未找到，正在查询注册表...
:: 查询注册表获取Path值
for /f "skip=2 tokens=2*" %%a in ('reg query "%regPath%" /v "%valueName%" 2^>nul') do (
    set "SEVEN_ZIP_PATH=%%b"
)

:: 检查 64 位注册表路径是否成功
if defined SEVEN_ZIP_PATH (
    set "SEVEN_ZIP_CMD=!SEVEN_ZIP_PATH!\7z.exe"
    if exist "!SEVEN_ZIP_CMD!" (
        goto :found_seven_zip
    ) else (
        goto :no_found_seven_zip
    )
)

:: 方法三: 如果上一步失败，尝试 32 位应用的注册表路径 (WOW6432Node)
for /f "skip=2 tokens=2*" %%a in ('reg query "%regPath%" /v "%value64Name%" 2^>nul') do (
    set "SEVEN_ZIP_PATH=%%b"
)

:: 检查 32 位注册表路径是否成功
if defined SEVEN_ZIP_PATH (
    set "SEVEN_ZIP_CMD=!SEVEN_ZIP_PATH!\7z.exe"
    if exist "!SEVEN_ZIP_CMD!" (
        goto :found_seven_zip
    ) else (
        goto :no_found_seven_zip
    )
)

:no_found_seven_zip
:: 如果所有方法都失败，则报错退出
echo.
echo [错误] 未能找到 7z.exe。
echo 请确保 7-Zip 已正确安装，或者其安装目录已添加到系统环境变量 PATH 中。
echo.
pause
exit /b 1

:found_seven_zip
echo   - 成功找到: !SEVEN_ZIP_CMD!
echo.


:: --- 步骤 2: 等待用户拖放文件/文件夹 ---
echo [步骤 2/4] 请将一个或多个文件/文件夹拖放到此窗口，然后按 Enter:
set "DropItems=%*"

echo [信息] 准备添加到压缩包的路径: %DropItems%
echo.
:: --- 步骤 3: 分析拖放内容并准备打包参数 ---
echo [步骤 3/4] 开始分析您拖放的内容...

:: 根据项目数量进行不同处理
echo [模式] 检测到项目，将直接打包所有项目。
:: 多个项目时，直接使用用户输入的列表
set "FilesToAdd=%DropItems%"

:: --- 步骤 4: 生成时间戳并执行打包命令 ---
echo [步骤 4/4] 正在准备打包...

:: 生成 yyyyMMddhhmmss 格式的时间戳
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set "mydate=%%c%%a%%b"
for /f "tokens=1-3 delims=:." %%a in ('time /t') do set "mytime=%%a%%b"
:: 处理小时数小于10的情况，确保是两位数 (例如 " 9" -> "09")
set "mytime=%mytime: =0%"
set "SFX_NAME=%mydate%%mytime%_7z.exe"

echo - 将创建自释放文件: "%SFX_NAME%
:: 根据项目数量和类型，决定如何打包
echo.
echo 正在执行压缩命令...
"!SEVEN_ZIP_CMD!" a -sfx7zCon.sfx -mx9 "%SFX_NAME%" %DropItems%

:: --- 检查执行结果 ---
echo.
if %errorlevel% equ 0 (
    echo.
    echo ================================================================
    echo [成功] 自释放压缩包已成功创建！
    echo 文件位置: "%cd%\%SFX_NAME%"
    echo ================================================================    
) else (
    echo.
    echo [失败] 压缩过程中发生错误，7z.exe 执行过程中发生错误，请检查7z返回的信息。
)

echo.
echo 操作完成，按任意键退出。
pause >nul
endlocal
