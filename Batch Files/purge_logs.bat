@echo off
setlocal enabledelayedexpansion

REM Prompt for the folder
set /p folder="Enter the name of your Profile folder: "

REM Check if the folder exists
if not exist "%folder%" (
    echo Folder does not exist.
    pause
    exit /b
)

REM Prompt for the number of files to keep
set /p keep="Enter the number of files to keep: "

REM Validate the input for keep
if not defined keep (
    echo No number entered. Exiting...
    pause
    exit /b
)

REM Change to the specified directory
cd /d "%folder%"

REM Set the number of files to keep, for some reason it needs to be set for 1 more than you want
set /a keep+=1

REM Process log files
for %%t in (script info crash) do (
    set "count=0"
    for %%F in (%%t*.log) do (
        set /a count+=1
        set "file[!count!]=%%F"
    )
    
    if !count! gtr %keep% (
        set /a delete=!count!-%keep%
        echo Processing %%t*.log files...
        echo Found !count! %%t*.log files. Deleting !delete! files:
        for /l %%i in (%keep%+1,1,!count!) do (
            echo Deleting: !file[%%i]!
            del "!file[%%i]!"
        )
    ) else (
        echo Processing %%t*.log files...
        echo Found only !count! %%t*.log files. No deletion necessary.
    )
)

REM Define the file extensions to process
for %%T in (RPT ADM) do (
    echo Processing *.%%T files...

    REM Reset the count for each file type
    set "count=0"

    REM Get the list of files sorted by date (newest first) and store in an array
    for /f "delims=" %%F in ('dir /b /a-d /o-d *.%%T') do (
        set /a count+=1
        set "file[!count!]=%%F"
    )

    REM Delete files if count exceeds the number to keep
    if !count! gtr !keep! (
        set /a delete=!count!-!keep!
        echo Found !count! *.%%T files. Deleting !delete! oldest files:
        for /l %%i in (1,1,!delete!) do (
            if /i "!file[%%i]!" neq "DayZServer_x64.ADM" (
                echo Deleting: !file[%%i]!
                del "!file[%%i]!"
            ) else (
                echo Skipping: !file[%%i]!
            )
        )
    ) else (
        echo Found only !count! *.%%T files. No deletion necessary.
    )
)

REM Process directories
set /a keep-=1
set "directories=CommunityOnlineTools\Logs EventManagerLog ExpansionMod\Logs WebApiLog ZomBerry"
for %%D in (%directories%) do (
    echo Processing .\%%D\*.log files in directory .\%%D...
    set "count=0"
    for %%F in (.\%%D\*.log) do (
        set /a count+=1
        set "file[!count!]=%%F"
    )

    if !count! gtr %keep% (
        set /a delete=!count!-%keep%
        echo Found !count! .\%%D\*.log files. Deleting !delete! files:
        set "index=0"
        for /f "tokens=*" %%i in ('dir /b /o-d .\%%D\*.log') do (
            set /a index+=1
            if !index! gtr %keep% (
                echo Deleting: .\%%D\%%i
                del ".\%%D\%%i"
            )
        )
    ) else (
        echo Found only !count! .\%%D\*.log files in directory .\%%D. No deletion necessary.
    )
)

pause
