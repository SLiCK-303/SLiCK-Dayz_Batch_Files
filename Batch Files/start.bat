@echo off
:start
::Server name (This is just for the bat file)
set serverName="CHANGE ME"
::Server files location
set serverLocation="D:\Games\SteamLibrary\steamapps\common\DayZServer"
::Server Port
set serverPort=2302
::Server config
set serverConfig=serverDZ.cfg
::Server profile
set serverProfiles=config
::Logical CPU cores to use (Equal or less than available)
set serverCPU=3
::Sets title for terminal (DONT edit)
title %serverName% batch
::DayZServer location (DONT edit)
cd "%serverLocation%"
echo (%time%) %serverName% started.
::Launch parameters (edit end: -config=|-port=|-profiles=|-doLogs|-adminLog|-netLog|-freezeCheck|-filePatching|-BEpath=|-cpuCount=)
start "DayZ Server" /min "DayZServer_x64.exe" -profiles=%serverProfiles% -config=%serverConfig% -port=%serverPort% -cpuCount=%serverCPU% "-mod=@CF;@Dabs-Framework;@Community-Online-Tools" "-servermod=@NoCollisionDamageIfEngineOff" -adminlog -netlog -freezecheck
::Time in seconds before kill server process (21600 = 6 hours), (14400 = 4 hours)
timeout 14390
taskkill /im DayZServer_x64.exe /F
::Time in seconds to wait before..
timeout 10
::Go back to the top and repeat the whole cycle again
goto start