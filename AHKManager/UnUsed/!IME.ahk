#SingleInstance force  ; force reloading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.1.23.01
; 语言：		中文
; 作者：		lspcieee <lspcieee@gmail.com>
; 网站：		http://www.lspcieee.com/
; 脚本功能：	自动切换输入法
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Menu, Tray, Icon, eng.ico

;#include F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\keyboard.ahk

;=====分组配置
;中文输入法的分组
GroupAdd,cn,ahk_exe QQ.exe
GroupAdd,cn,ahk_exe hh.exe
GroupAdd,cn,ahk_exe wordpad.exe 

;英文输入法的分组
GroupAdd,en,ahk_exe autohotkey.exe 
GroupAdd,en,ahk_exe firefox.exe
GroupAdd,en,ahk_exe notepad++.exe
GroupAdd,en,ahk_class CabinetWClass
GroupAdd,en,ahk_exe FileLocatorPro.exe
GroupAdd,en,ahk_class ConsoleWindowClass
GroupAdd,en,ahk_exe BCompare.exe
GroupAdd,en,ahk_exe designer.exe

;编辑器分组
GroupAdd,editor,ahk_exe notepad.exe ;记事本
GroupAdd,editor,ahk_class Notepad++


;函数
;从剪贴板输入到界面
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

;监控消息回调ShellMessage，并自动设置输入法
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
			TrayTip,AHK, 自动切换到English输入法
			SoundBeep, 1000, 100
			return
		}
		IfWinActive,ahk_group en
		{
			setEnglishLayout()
			TrayTip,AHK, 已自动切换到英文输入法
			return
		}
		IfWinActive,ahk_group cn
		{
			setChineseLayout()
			TrayTip,AHK, 已自动切换到group 中文输入法
			return
		}
		If Winclass in TXGuiFoundation,WordPadClass
		{
			winget,WinID,id,ahk_class %WinClass%
			setChineseLayout()
			TrayTip,AHK, 自动切换到Chinese输入法
			return
		}
	;setChineseLayout()
	;TrayTip,AHK, 已自动切换到中文输入法
	;return
	}
}
;在所有编辑器中自动切换中英文输入法
#IfWinActive,ahk_group editor
:*:// ::

	;//加空格 时 切换到中文输入法
	setEnglishLayout()
	sendbyclip("//")
	setChineseLayout()
return
:Z*:///::
	;///注释时 切换到中文输入法（也可以输入///加空格）
	setEnglishLayout()
	sendbyclip("//")
	SendInput /
	setChineseLayout()
return
:*:" ::
	;引号加空格 时 切换到中文输入法
	setEnglishLayout()
	SendInput "
	setChineseLayout()
return
:*:`;`n::
	;分号加回车 时 切换的英文输入法
	setEnglishLayout()
	sendbyclip(";")
	SendInput `n
return
:Z?*:`;`;::
	;两个分号时 切换的英文输入法
	setEnglishLayout()
return
:Z?*:  ::
	;输入两个空格 切换的中文输入法
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