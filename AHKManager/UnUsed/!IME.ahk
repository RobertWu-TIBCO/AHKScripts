#SingleInstance force  ; force reloading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK�汾��		1.1.23.01
; ���ԣ�		����
; ���ߣ�		lspcieee <lspcieee@gmail.com>
; ��վ��		http://www.lspcieee.com/
; �ű����ܣ�	�Զ��л����뷨
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Menu, Tray, Icon, eng.ico

;#include F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\keyboard.ahk

;=====��������
;�������뷨�ķ���
GroupAdd,cn,ahk_exe QQ.exe
GroupAdd,cn,ahk_exe hh.exe
GroupAdd,cn,ahk_exe wordpad.exe 

;Ӣ�����뷨�ķ���
GroupAdd,en,ahk_exe autohotkey.exe 
GroupAdd,en,ahk_exe firefox.exe
GroupAdd,en,ahk_exe notepad++.exe
GroupAdd,en,ahk_class CabinetWClass
GroupAdd,en,ahk_exe FileLocatorPro.exe
GroupAdd,en,ahk_class ConsoleWindowClass
GroupAdd,en,ahk_exe BCompare.exe
GroupAdd,en,ahk_exe designer.exe

;�༭������
GroupAdd,editor,ahk_exe notepad.exe ;���±�
GroupAdd,editor,ahk_class Notepad++


;����
;�Ӽ��������뵽����
sendbyclip(var_string)
{
    ClipboardOld = %ClipboardAll%
    Clipboard =%var_string%
	ClipWait
    send ^v
    sleep 100
    Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
}


setChineseLayout()
{
SwitchIME(00000804)
;SwitchToCnIME()
}
setEnglishLayout()
{
SwitchIME(00000409)
;SwitchToEngIME()
}

;�����Ϣ�ص�ShellMessage�����Զ��������뷨
Gui +LastFound
hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
;MsgBox % MsgNum
OnMessage(MsgNum, "ShellMessage")
return
ShellMessage(wParam,lParam) {
;MsgBox % wParam
	;If ( wParam = 32772 or wParam = 6 )
	If ( wParam = 6)
	{
		WinGetclass, WinClass, ahk_id %lParam%
		WinActivate,ahk_class %Winclass%
		If Winclass in MozillaWindowClass,Notepad++,#32770,Notepad2U,OpusApp,XLMAIN,CabinetWClass,Chrome_WidgetWin_1,EVERYTHING
		{
			winget,WinID,id,ahk_class %WinClass%
			; SetLayout("E0200804",WinID)         ;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts
			setEnglishLayout()
			TrayTip,AHK, �Զ��л���English���뷨
			SoundBeep, 1000, 100
			return
		}
		IfWinActive,ahk_group en
		{
			setEnglishLayout()
			TrayTip,AHK, ���Զ��л���Ӣ�����뷨
			return
		}
		IfWinActive,ahk_group cn
		{
			setChineseLayout()
			TrayTip,AHK, ���Զ��л���group �������뷨
			return
		}
		If Winclass in TXGuiFoundation,WordPadClass
		{
			winget,WinID,id,ahk_class %WinClass%
			setChineseLayout()
			TrayTip,AHK, �Զ��л���Chinese���뷨
			return
		}
	;setChineseLayout()
	;TrayTip,AHK, ���Զ��л����������뷨
	;return
	}
}
;�����б༭�����Զ��л���Ӣ�����뷨
#IfWinActive,ahk_group editor
:*:// ::

	;//�ӿո� ʱ �л����������뷨
	setEnglishLayout()
	sendbyclip("//")
	setChineseLayout()
return
:Z*:///::
	;///ע��ʱ �л����������뷨��Ҳ��������///�ӿո�
	setEnglishLayout()
	sendbyclip("//")
	SendInput /
	setChineseLayout()
return
:*:" ::
	;���żӿո� ʱ �л����������뷨
	setEnglishLayout()
	SendInput "
	setChineseLayout()
return
:*:`;`n::
	;�ֺżӻس� ʱ �л���Ӣ�����뷨
	setEnglishLayout()
	sendbyclip(";")
	SendInput `n
return
:Z?*:`;`;::
	;�����ֺ�ʱ �л���Ӣ�����뷨
	setEnglishLayout()
return
:Z?*:  ::
	;���������ո� �л����������뷨
	setEnglishLayout()
	setChineseLayout()
return

#IfWinActive

::ri::
reload
return

::si::
suspend
return

#include F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\Core\Common.ahk