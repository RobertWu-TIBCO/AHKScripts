@echo off
title Kawvin Ahk�������

:start
setlocal enabledelayedexpansion
set ahk2exe="C:\Program Files\AutoHotkey\Compiler\ahk2exe.exe"
set ahku32b="C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin"
set ahku64b="C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"
set ahka32b="C:\Program Files\AutoHotkey\Compiler\ANSI 32-bit.bin"
FOR /F "delims==" %%i IN ('dir /b *.ico') DO set IcoName="%%~fi"
cls
color 2f
mode con cols=50 lines=20
echo.
echo.
echo.
echo.
echo                Kawvin Ahk�������
echo  ================================================
echo               [A] ANSI 32     �汾
echo               [B] Unicode 32  �汾
echo               [C] Unicode 64  �汾
echo               [D] ���� 32     �汾
echo               [E] ����Unicode �汾
echo               [F] ����        �汾
echo         -------------------------------
echo               [Q] �˳� 
echo  ================================================
echo         ��ѡ������[A/B/C/D/E/F/Q]:
set /p choice=
if /i %choice%==q goto menu_Q
if /i %choice%==f goto menu_F
if /i %choice%==e goto menu_E
if /i %choice%==d goto menu_D
if /i %choice%==c goto menu_C
if /i %choice%==b goto menu_B
if /i %choice%==a goto menu_A
goto start

:menu_A
FOR /F "delims==" %%i IN ('dir /b *.ahk') DO (
set ahkName="%%~dpi%%~ni.ahk"
set exeName="%%~dpi%%~ni"
%ahk2exe% /in !ahkName! /out !exeName!.exe /icon %IcoName% /bin %ahka32b%
)
goto start

:menu_B
FOR /F "delims==" %%i IN ('dir /b *.ahk') DO (
set ahkName="%%~dpi%%~ni.ahk"
set exeName="%%~dpi%%~ni"
%ahk2exe% /in !ahkName! /out !exeName!.exe /icon %IcoName% /bin %ahku32b%
)
goto start

:menu_C
FOR /F "delims==" %%i IN ('dir /b *.ahk') DO (
set ahkName="%%~dpi%%~ni.ahk"
set exeName="%%~dpi%%~ni"
%ahk2exe% /in !ahkName! /out !exeName!.exe /icon %IcoName% /bin %ahku64b%
)
goto start

:menu_D
FOR /F "delims==" %%i IN ('dir /b *.ahk') DO (
set ahkName="%%~dpi%%~ni.ahk"
set exeName="%%~dpi%%~ni"
%ahk2exe% /in !ahkName! /out !exeName!-A32.exe /icon %IcoName% /bin %ahka32b%
%ahk2exe% /in !ahkName! /out !exeName!-U32.exe /icon %IcoName% /bin %ahku32b%
)
goto start

:menu_E
FOR /F "delims==" %%i IN ('dir /b *.ahk') DO (
set ahkName="%%~dpi%%~ni.ahk"
set exeName="%%~dpi%%~ni"
%ahk2exe% /in !ahkName! /out !exeName!-U32.exe /icon %IcoName% /bin %ahku32b%
%ahk2exe% /in !ahkName! /out !exeName!-U64.exe /icon %IcoName% /bin %ahku64b%
)
goto start

:menu_F
FOR /F "delims==" %%i IN ('dir /b *.ahk') DO (
set ahkName="%%~dpi%%~ni.ahk"
set exeName="%%~dpi%%~ni"
%ahk2exe% /in !ahkName! /out !exeName!-A32.exe /icon %IcoName% /bin %ahka32b%
%ahk2exe% /in !ahkName! /out !exeName!-U32.exe /icon %IcoName% /bin %ahku32b%
%ahk2exe% /in !ahkName! /out !exeName!-U64.exe /icon %IcoName% /bin %ahku64b%
)
goto start

:menu_Q
Exit