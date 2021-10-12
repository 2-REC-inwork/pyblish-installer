@echo off
cls
setlocal EnableDelayedExpansion

REM set PYBLISH_INSTALLER_PATH=%~dp0
set PYBLISH_INSTALLER_PATH=%~dp0
set PYBLISH_INSTALLER_PATH=%PYBLISH_INSTALLER_PATH:~0,-1%
REM - TODO: REMOVE!
set PYBLISH_INSTALLER_PATH=D:\data\TMP\BC\pyblish\pyblish_installer
REM echo PYBLISH_INSTALLER_PATH %PYBLISH_INSTALLER_PATH%


set MODULES_PATH=%PYBLISH_INSTALLER_PATH%\modules
REM echo MODULES_PATH %MODULES_PATH%


REM - Get modules
set "PYBLISH_MODULES="
for /D %%D in ("%MODULES_PATH%\*") do (
    set "DIRNAME=%%~nD"
    REM echo !DIRNAME!

    call :toUpper UPPER_VALUE !DIRNAME!

    set DISABLED_MODULE_NAME=NO_!UPPER_VALUE!
    REM echo DISABLED_MODULE_NAME !DISABLED_MODULE_NAME!


    call :getValue VALUE !DISABLED_MODULE_NAME! false
    REM echo !DISABLED_MODULE_NAME! !VALUE!

    REM - TODO: or should instead "!=YES"?
    if "!VALUE!" == "false" (
        set PYBLISH_MODULES=!PYBLISH_MODULES!;!DIRNAME!
    )
)
if not "%PYBLISH_MODULES%" == "" (
    set PYBLISH_MODULES=%PYBLISH_MODULES:~1%
)
REM echo PYBLISH_MODULES %PYBLISH_MODULES%






REM - Get Pyblish module versions
REM 'ON'? (or 'true'?)
REM if "%PYBLISH_LATEST%" == "ON" (
if "%PYBLISH_LATEST%" == "" (
    if "%PYBLISH_BASE_VERSION%" == "" (
        set PYBLISH_BASE_VERSION=master
    )
    if "%PYBLISH_QML_VERSION%" == "" (
        set PYBLISH_QML_VERSION=master
    )

    REM - Set a "PYBLISH_XXX_VERSION" variable for each found module
    REM set "MODULE_VERSIONS="
    for %%m in (%PYBLISH_MODULES%) do (
        call :toUpper UPPER_VALUE %%m

        set PYBLISH_MODULE_VERSION=PYBLISH_!UPPER_VALUE!_VERSION
        REM set "MODULE_VERSIONS=!MODULE_VERSIONS!;!PYBLISH_MODULE_VERSION!"
        call :getValue VALUE !PYBLISH_MODULE_VERSION! master
        call set "!PYBLISH_MODULE_VERSION!=!VALUE!"
    )



)

REM set MODULE_VERSIONS=%MODULE_VERSIONS:~1%
REM echo MODULE_VERSIONS %MODULE_VERSIONS%



REM - Display versions summary
echo The following modules will be downloaded:
echo pyblish-base %PYBLISH_BASE_VERSION%
echo pyblish-qml %PYBLISH_QML_VERSION%
for %%m in (%PYBLISH_MODULES%) do (
    call :toUpper UPPER_VALUE %%m

    set PYBLISH_MODULE_VERSION=PYBLISH_!UPPER_VALUE!_VERSION
    call :getValue VALUE !PYBLISH_MODULE_VERSION! master

    REM echo !PYBLISH_MODULE_VERSION! !VALUE!
    echo pyblish-%%m !VALUE!
)



REM - 32/64 BITS
REM - TODO!



REM - TODO: or 'not "NO_PYTHON" == "ON"'?
if "NO_PYTHON" == "" (
    REM - Python version
    if "PYTHON_EXECUTABLE" == "" (

        if "PYTHON_VERSION" == "" (
            REM - Look for local python ('python.exe' in PATH or in default dir: 'appdata/.../python)


!!!!!!!!!!!!
loop through all entries in PATH
=> TODO: make function
REM - Expand "PATH" values
for /f "delims=<" %%d in ('call echo "%PATH%"') do (
    set TEMP_PATH=%%d
)

REM - Remove quotes "
set TEMP_PATH=;%TEMP_PATH:"=%;

REM - Put every ; between quotes
set TEMP_PATH=%TEMP_PATH:;=";"%

REM - Remove "; prefix
set TEMP_PATH=%TEMP_PATH:~2%

REM - Remove ;" suffix
set TEMP_PATH=%TEMP_PATH:~0,-2%

REM - Remove empty values ""; (begin and in)
set TEMP_PATH=%TEMP_PATH:"";=%

REM - Remove other empty values ;"" (end)
set TEMP_PATH=%TEMP_PATH:;""=%

REM - Loop on each entry
for %%d in (%TEMP_PATH%) do (
    echo D %%d

    => check if exists with \python.exe suffix
    if exist %%d (
        echo EXISTS
    ) else (
        echo NOT EXISTS
    )
)
!!!!!!!!!!!!!


        )

    )
)



pause
exit /b



REM - TODO: downloads...

######## BEGIN
REM - repos
TODO: not working code..

set GIT_URL_PREFIX=https://github.com/pyblish/

for each module

REM - download git repo

REM - TODO: want? or always download zip?
REM - if 'git' installed
REM => download with git
git clone ...

REM - if not git
REM => download as zip


if master:
set GIT_URL_SUFFIX=/zipball/master
else:
...
(eg:
https://github.com/pyblish/pyblish-base/archive/refs/tags/1.8.8.zip
)


set GIT_ZIP_URL=%GIT_URL_PREFIX%%GIT_REPO%%GIT_URL_SUFFIX%

curl -L -o %GIT_REPO%.zip "%GIT_ZIP_URL%"
######## END




######## BEGIN
REM - download Python minimal
TODO: not working code..

set PYTHON_URL=https://www.python.org/ftp/python/3.7.9/python-3.7.9-embed-amd64.zip

curl -o %python%.zip "%PYTHON_URL%"

REM - extract python.zip
tar -xf ... -C ...

REM - download get-pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

REM - execute get-pip
c:\Users\2-REC\Documents\python-3.7.9-embed-win32\python.exe get-pip.py

REM - edit "python3._pth"
REM - TODO: instead: replace by an existing file (+keep backup of original)
REM - with content:
REM - Lib/site-packages
REM - python37.zip
REM - .
REM - 
REM - import site

set PTH_FILE=python37._pth

echo Lib/site-packages >> _tempfile
type "%PTH_FILE%" >> _tempfile
echo import site >> _tempfile
del %PTH_FILE%
ren _tempfile %PTH_FILE%
######## END




REM - download PyQt5
TODO: ...







echo.



pause
exit /b

REM ##########################################################################

REM - To Upper function
:toUpper <return_var> <str>
set "UPPER="
for /f "skip=2 delims=" %%I in ('tree "\%2"') do if not defined UPPER set "UPPER=%%~I"
set "%~1=%UPPER:~3%"
exit /b


REM - Get Value function
:getValue <return_var> <str> <default>
if "!%2!" == "" (
    set "%~1=%3"
) else (
    set "%~1=!%2!"
)
exit /b
