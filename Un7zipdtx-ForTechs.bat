
REM You need 7zip 64 bit installed.
REM Set where you Diags/Archive/Downloads are Stored
REM set diagdir=%USERPROFILE%\Desktop
set diagdir=D:
set diagarchive=%diagdir%\Diagnostics\Archive
set diagdownload=%USERPROFILE%\Downloads

if not exist "%diagdir%\Diagnostics" mkdir %diagdir%\Diagnostics
if not exist "%diagarchive%" mkdir %diagarchive%
if not exist "%diagdir%\Support Bundles" mkdir %diagdir%\"Support Bundles"
rem if not exist "%diagdir%\OneBloxDiags\" mkdir "%diagdir%\OneBloxDiags\"

REM taskkill /im 7zFM.exe
"C:\Program Files\7-Zip\7z.exe" x -aoa -o%diagdir%\Diagnostics\* %diagdownload%\dtx_*.7z
move %USERPROFILE%\Downloads\dtx_*.7z "%diagarchive%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o%diagdir%\Diagnostics\* %diagdownload%\????????_dtx_*.7z
move %diagdownload%\????????_dtx_*.7z "%diagarchive%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o%diagdir%\Diagnostics\* %diagdownload%\dtx_*.tar.gz
move %diagdownload%\dtx_*.tar.gz "%diagarchive%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o%diagdir%\Diagnostics\* %diagdownload%\????????_dtx_*.tar.gz
move %diagdownload%\????????_dtx_*.tar.gz "%diagarchive%"
REM "C:\Program Files\7-Zip\7z.exe" x "%diagdownload%\oneblox*" -so | 7z x -aoa -si -ttar -o"%diagdir%\Diagnostics\*"
REM "C:\Program Files\7-Zip\7z.exe" x - aoa -o%diagdir%\OneBloxDiags\* %diagdownload%\oneblox*
REM "C:\Program Files\7-Zip\7z.exe" e -aoa -o%diagdir%\OneBloxDiags\* %diagdir%\OneBloxDiags\*\oneblox*
move %diagdownload%\oneblox* "%diagarchive%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o"%diagdir%\Support Bundles\*" %diagdownload%\stc-support-bundle*.zip
move %diagdownload%\stc-support-bundle*.zip "%diagarchive%"
for /F "DELIMS=" %%I IN ('dir /b /s "%diagdir%\Support Bundles\*.zip"') DO (
    "C:\Program Files\7-Zip\7z.exe" x -aoa -o"%%~dpnI" "%%I"
)
FOR /R "%diagdir%\Support Bundles\" %%I IN (*.zip) DO del /f "%%I"
)
for /F "DELIMS=" %%I IN ('dir /b /a-d /s "%diagdir%\Diagnostics\*.tar"') DO "C:\Program Files\7-Zip\7z.exe" x -aos -o"%%~dpnI" "%%I"
for /F "DELIMS=" %%I IN ('dir /b /a-d /s "%diagdir%\Diagnostics\*.tar"') DO  del /f "%%I"
REM FOR /R "%diagdir%\Support Bundles\" %%I IN (*.zip) DO del /f "%%I"
@echo off
Echo Done!

