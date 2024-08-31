@echo off
setlocal enabledelayedexpansion

:: Ask for the profile folder name
set /p folderName="Enter the Profile folder name: "

REM Check if the folder exists
if not exist "%folderName%" (
    echo Folder does not exist.
    pause
    exit /b
)

:: Process each file path
call :delete_files ".\%folderName%\PermissionsFramework\Players\*.json"
call :delete_files ".\%folderName%\ExpansionMod\ATM\*.json"
call :delete_files ".\%folderName%\ExpansionMod\Groups\*.json"
call :delete_files ".\%folderName%\ExpansionMod\Hardline\PlayerData\*.bin"
call :delete_files ".\%folderName%\ExpansionMod\Quests\PlayerData\*.bin"
call :delete_files ".\%folderName%\ExpansionMod\Quests\GroupData\*.bin"

:: Set the base path (e.g., .\mpmissions)
set "base_path=.\mpmissions"

:: Find folders matching the pattern storage_* in all subdirectories of base_path
for /d %%A in ("%base_path%\*") do (
    echo Checking directory %%A
    for /d %%B in ("%%A\storage_*") do (
        set "folder_to_delete=%%B"
        echo Found folder: !folder_to_delete!
        set /p delete_folder="Do you want to delete the folder !folder_to_delete!? (y/n): "

        if /i "!delete_folder!"=="y" (
            rmdir /s /q "!folder_to_delete!"
            echo Folder !folder_to_delete! deleted.
        ) else (
            echo Deletion of folder !folder_to_delete! canceled.
        )
    )
)

endlocal
pause
exit /b

:delete_files
set "file_path=%~1"
echo Do you want to delete the files %file_path%? (y/n):
set /p delete_file=""
if /i "%delete_file%"=="y" (
    if exist "%file_path%" (
        del /q "%file_path%"
        echo Files deleted.
    ) else (
        echo Files do not exist.
    )
) else (
    echo File deletion canceled.
)
exit /b
