echo off

for /f "delims=" %%x in (.version) do set Build=%%x
:continue

set "Build=%Build%"
set "Directory=%cd%"

echo Build: %Build%
echo Directory: %Directory%

set "TurtleFilename=DisenchanterPlus-Turtle-v%Build%"

del "%Directory%Releases\%TurtleFilename%.zip"

7z a -x@packagerExclusions-Turtle.lst -xr@packagerExclusions-Turtle.lst -tzip ".\Releases\%TurtleFilename%.zip" "%Directory%" -aoa
