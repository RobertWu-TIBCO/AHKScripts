#SingleInstance force  ; force reloading

Menu scripts_edit, Add, �����ĵ�, Menu_Tray_Exit
Menu scripts_edit, ToggleEnable, �����ĵ�
Menu scripts_edit, Default, �����ĵ�
Menu scripts_edit, Add
Menu, scripts_edit, NoStandard

Menu txt_edit, Add, �����ĵ�, Menu_Tray_Exit
Menu txt_edit, ToggleEnable, �����ĵ�
Menu txt_edit, Default, �����ĵ�
Menu txt_edit, Add
Menu, txt_edit, NoStandard

Menu folder_edit, Add, ����·��, Menu_Tray_Exit
Menu folder_edit, ToggleEnable, ����·��
Menu folder_edit, Default, ����·��
Menu folder_edit, Add

Menu openfiles_edit, Add, Ahk Open�ĵ�, Menu_Tray_Exit
Menu openfiles_edit, ToggleEnable, Ahk Open�ĵ�
Menu openfiles_edit, Default, Ahk Open�ĵ�
Menu openfiles_edit, Add

Menu ahk_edit, Add, Ahk Open�ĵ�, Menu_Tray_Exit
Menu ahk_edit, ToggleEnable, Ahk Open�ĵ�
Menu ahk_edit, Default, Ahk Open�ĵ�
Menu ahk_edit, Add


; ���ӹ���ť
Menu, Tray, Icon, F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\gahk1.ico ;if only filename , it fails sometimes
Menu, Tray, Tip, Ahk Help Files
Menu, Tray, Add, Ahk Help Files, Menu_Tray_Show
Menu, Tray, ToggleEnable, Ahk Help Files
Menu, Tray, Default, Ahk Help Files
Menu, Tray, Add, �����ĵ�(&1)`tWin+ 1, :scripts_edit
Menu, Tray, Add
Menu, Tray, Add, �����ĵ�(&2)`tWin &+ 2, :txt_edit
Menu, Tray, Add
Menu, Tray, Add, ����·��(&3)`tWin &+ 3, :folder_edit
Menu, Tray, Add
Menu, Tray, Add, Ahk Open�ĵ�(&4)`tWin &+ 4, :openfiles_edit
Menu, Tray, Add
Menu, Tray, Add, Ahk Learn(&6)`tWin &+ 4, :ahk_edit
Menu, Tray, Add
Menu, Tray, Add, �򿪰���Ŀ¼(&D)`t%A_ScriptDir%, Menu_Tray_OpenDir
Menu, Tray, Add
Menu, Tray, Add, �����ű�(&R), Menu_Tray_Reload
Menu, Tray, Add
Menu, Tray, Add, �༭����(&E), Menu_Tray_Edit
Menu, Tray, Add
Menu, Tray, NoStandard
;Menu, Tray, Standard

scriptCount = 0
; ����scriptsĿ¼�µ�ahk�ļ�
Loop, F:\Program Files\AutoHotkey\Scripts\chm\*.*
{
    StringRePlace menuName, A_LoopFileName, .chm

    scriptCount += 1
    scripts%scriptCount%0 := A_LoopFileName
	
    Menu scripts_edit, add, %menuName%, tsk_edit
}

/*
scriptCount = 0
Loop, F:\Program Files\AutoHotkey\Scripts\chm\*.*
{
    ;StringRePlace menuName, A_LoopFileName, .chm

    scriptCount += 1
    scripts%scriptCount%0 := A_LoopFileName
	
    Menu txt_edit, add, %menuName%, tsk_edit
}
return
*/

scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\folderLinkFiles.xml
{
    Menu txt_edit, add, %A_LoopReadLine%, txt_edit
}

scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\folderLinkOpenFiles.xml
{
    Menu openfiles_edit, add, %A_LoopReadLine%, openfile_edit
}

scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\folderLink.xml
{
    Menu folder_edit, add, %A_LoopReadLine%, txt_edit
}

scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\Good\ListViewFolder\AllAhkLearn.xml
{
    IfNotInString, #@#@,  %A_LoopReadLine% ;this uses #@#@ to comment ignore lines in the file list files ! good !
	{
	;IfNotInString, Manager, %A_LoopReadLine%  ;Fails to control more
    Menu ahk_edit, add, %A_LoopReadLine%, openfile_edit
	}
}

;return
	
Menu_Tray_OpenDir:
	Run %A_ScriptDir%
Return

Menu_Tray_Reload:
	Reload
Return

Menu_Tray_Edit:
	Edit
Return

tsk_edit:
;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
Run,  F:\Program Files\AutoHotkey\Scripts\chm\%A_ThisMenuItem%.chm
return

txt_edit:
Run, %A_ThisMenuItem%
return

openfile_edit:
openfile(A_ThisMenuItem)
return

Menu_Tray_Exit:
	ExitApp
Return

Menu_Tray_Show:
    Menu, Tray, Show
Return

Menu_Script_show:
Menu, scripts_edit, Show
return

Menu_Txt_show:
Menu, txt_edit, Show
return


#g::
#1::
gosub Menu_Script_show
return

#t::
#2::
gosub Menu_Txt_show
return


#3::
Menu, folder_edit, Show
return

#4::
Menu, openfiles_edit, Show
return

#m::
#5::
gosub Menu_Tray_Show
return