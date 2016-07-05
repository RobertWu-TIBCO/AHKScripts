#SingleInstance force  ; force reloading
Gui +LastFound
hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")
Return
ShellMessage( wParam,lParam ) {
  If ( wParam = 1 )
  {
    WinGetclass, WinClass, ahk_id %lParam%
	Sleep 1000
    If Winclass in Notepad2U,OpusApp,XLMAIN,CabinetWClass,Chrome_WidgetWin_1,EVERYTHING
    {
		winget,WinID,id,ahk_class %WinClass%
		SetLayout("00000409",WinID)         ;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts
		TrayTip,AHK, 自动切换到英文输入法
		SoundBeep, 1000, 100
		return
	}
	If Winclass in TXGuiFoundation,WordPadClass
	{
		winget,WinID,id,ahk_class %WinClass%
		SetLayout("00000804",WinID)         ;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts
		;MsgBox zzz
		TrayTip,AHK, 自动切换到中文输入法
		SoundBeep, 1000, 100
		return
	}
	If Winclass in Photoshop
	{
		winget,WinID,id,ahk_class %WinClass%
		SetLayout("4090409",WinID)         ;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts
		;TrayTip,AHK, 自动切换到拼音输入法
		return
	}
  }
}

SetLayout(Layout,WinID){
DllCall("SendMessage", "UInt", WinID, "UInt", "80", "UInt", "1", "UInt", (DllCall("LoadKeyboardLayout", "Str", Layout, "UInt", "257")))
}

::sq::
reload
return