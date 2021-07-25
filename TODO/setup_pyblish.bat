@echo off

cls
setlocal EnableDelayedExpansion


if "%PYBLISH_INSTALL_PATH%" == "" (
    set PYBLISH_INSTALL_PATH=%USERPROFILE%\AppData\Local\BCS\Pyblish
)
if "%PYTHON_INSTALL_PATH%" == "" (
    set PYTHON_INSTALL_PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python37
)

echo Pyblish install path: %PYBLISH_INSTALL_PATH%
echo Python install path: %PYTHON_INSTALL_PATH%
echo.

if exist "%PYBLISH_INSTALL_PATH%\" (
    echo Pyblish already installed in '%PYBLISH_INSTALL_PATH%'.
    echo.
    pause
    exit /b
)



REM - TODO: INSTEAD, EXTRACT ZIP!
if not exist "%PYTHON_INSTALL_PATH%\" (
    echo Installing Python...
    xcopy %PYTHON_PATH% %PYTHON_INSTALL_PATH% /s /i > NUL
    echo OK
    echo.
) else (
    REM - TODO: check that 'python.exe' is in the directory (+get version?)
    echo Python found in '%PYTHON_INSTALL_PATH%'.
    echo.
)


REM - TODO: NEED TO CHECK FOR PYQT5!




REM - TODO: rename 'PYBLISH_MAIN_PATH'
if "%PYBLISH_MAIN_PATH%" == "" (
    REM - Set Pyblish path as current parent directory
    set PWD=%~dp0
    for /D %%D in ("!PWD:~0,-1!") do (
        set "DIRNAME=%%~dpD"
    )
    set PYBLISH_MAIN_PATH=!DIRNAME:~0,-1!
)


REM - get from current path (..)!
set PYBLISH_PATH=%PYBLISH_MAIN_PATH%\pyblish
set PYTHON_PATH=%PYBLISH_MAIN_PATH%\Python37




echo Installing Pyblish

set INSTALLERS_PATH=%PYBLISH_MAIN_PATH%\installers
set PYBLISH_INSTALLERS_PATH=%INSTALLERS_PATH%\pyblish

set EXTRACT_PATH=%PYBLISH_INSTALL_PATH%\src
mkdir %EXTRACT_PATH%


for %%f in (%PYBLISH_INSTALLERS_PATH%\*) do (
    call :EXTRACT_PROCESS %%f
)
goto AFTER_EXTRACT_PROCESS


:EXTRACT_PROCESS

for /f %%f in ("%1") do (
    set "FILENAME=%%~nxf"
    set "EXT=%%~xf"
)
if not "%EXT%" == ".zip" (
    exit /b
)

set /p "=Extracting '%FILENAME%'... " <NUL
tar -xf "%1" -C %EXTRACT_PATH%
echo OK

exit /b


:AFTER_EXTRACT_PROCESS

set /p "=Copying launchers... " <NUL
xcopy %PYBLISH_PATH%\launchers %PYBLISH_INSTALL_PATH%\launchers /s /i > NUL
echo OK
echo.


set /p "=Copying DCC related files... " <NUL
xcopy %PYBLISH_PATH%\modules %PYBLISH_INSTALL_PATH%\modules /s /i > NUL
echo OK

for /D %%D in ("!PYBLISH_INSTALL_PATH!\modules\*") do (
    call :DCC_PROCESS %%D
)
goto AFTER_DCC_PROCESS

:DCC_PROCESS

for /f %%f in ("%1") do (
    set "NAME=%%~nf"
)

set /p "=Creating %NAME% shortcut... " <NUL
set LAUNCHER_PATH=%PYBLISH_INSTALL_PATH%\launchers\%NAME%\pyblish_%NAME%.bat
set SHORTCUT_PATH=%USERPROFILE%\Desktop\pyblish %NAME%.lnk

if exist "%SHORTCUT_PATH%" (
    del "%SHORTCUT_PATH%"
)

set TEMP_FILE=%TEMP%\temp.vbs
echo set SCRIPT_SHELL = WScript.CreateObject("WScript.Shell") > %TEMP_FILE%
echo LINK_FILE = "%SHORTCUT_PATH%" >> %TEMP_FILE%
echo set LINK = SCRIPT_SHELL.CreateShortcut(LINK_FILE) >> %TEMP_FILE%
echo LINK.TargetPath = "%LAUNCHER_PATH%" >> %TEMP_FILE%
echo LINK.Save >> %TEMP_FILE%
cscript %TEMP_FILE% > NUL
del %TEMP_FILE%
echo OK
echo %NAME% integration done successfully.
echo.
exit /b


:AFTER_DCC_PROCESS

echo Pyblish successfully installed to '%PYBLISH_INSTALL_PATH%'.
echo.

pause
exit /b