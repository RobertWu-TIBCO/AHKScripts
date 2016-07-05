; Pulover's Clipboard History  
; Modified By sixtyone at April 8,2016
;热键：F6
;更新历史
/*
2016.4.11 :
	1.弹出菜单增加"停止收录";
	2.弹出菜单选项增加快捷键选定;
	3.托盘菜单添加重载及编辑命令;
	4.增加托盘关于菜单:显示版本号


*/

#NoEnv
#SingleInstance force
#InstallKeybdHook

Menu, Tray, Add, 剪贴板记录, ShowHistory
Menu, Tray, Add
Menu, Tray, Add,关于,About
Menu, Tray, Add,停止收录,Togshoulu
Menu, Tray, Add, 选项(&Option), Options
Menu, Tray, Add, 编辑(&Edit), Edit
Menu, Tray, Add, 重载(&Reload), Reload
Menu, Tray, Add
Menu, Tray, Add, 暂停(&PauseScript), PauseScript
Menu, Tray, Add, 退出(E&xit), Exit
Menu, Tray, NoStandard
Menu, Tray, Default, 剪贴板记录
Menu, Tray, Icon, Shell32.dll, 261

ClipArray := Object()
ClipMax := 50
MenuMax := 10
NoChange := 1
PopTog:="UnCheck"

OnClipboardChange:
If NoChange = 1
{
	SetTimer, Change, -100
	return
}
if Togshoulu																										;启停收录标志
	return
If Clipboard =
	return
TotalItems2 := ClipArray.MaxIndex()
Loop, %TotalItems2%																						;如果已有相同项,则不收录
{
	ThisMenu := SubStr(ClipArray[A_Index], 1)
	If  ThisMenu=%Clipboard%
		return
}
ClipArray.Insert(1, Clipboard)
Goto, Update
return

Change:
NoChange := 0
return


Togshoulu:
Menu,Tray,ToggleCheck,停止收录
PopTog :=(Tog :=!Tog) ?  "Check" :  "UnCheck"
Togshoulu:=!Togshoulu																									;启停收录
return


ShowHistory:
Gui 1:+LastFoundExist
IfWinExist
{
	WinActivate
	Goto, Update
}
Gui +Resize +AlwaysOnTop
Gui, Add, Button, Default gCopy, 复制
Gui, Add, Button, x+10 gDelete, 删除
Gui, Add, Button, x+10 gClear, 清空
Gui, Add, Button, x+10 gOptionsButton, 选项
Gui, Add, ListView, xm r21 w300 -Multi vClipHistory gClipHistory, 序号|内容
GuiControl, -Redraw, ClipHistory 
for index, element in ClipArray
	LV_Add("", Index, Element)
GuiControl, +Redraw, ClipHistory
LV_ModifyCol(1, 40)
LV_ModifyCol(2, 240)
Gui, Show,, Clipboard History
return

OptionsButton:
Gui, 2:+owner1
Gui, 1:Default
Gui +Disabled
Options:
Gui, 2:Add, Text,, Maximum number of Clips:
Gui, 2:Add, Edit, xp+130 yp-2 Limit Number W80
Gui, 2:Add, UpDown, 0x80 Range0-999999 vClipMax, %ClipMax%
Gui, 2:Add, Text, xm, Maximum Clips in Menu:
Gui, 2:Add, Edit, xp+130 yp-2 Limit Number W80
Gui, 2:Add, UpDown, 0x80 Range0-999999 vMenuMax, %MenuMax%
Gui, 2:Add, Button, Section Default xm W60 H22 gOptOK, OK
Gui, 2:Add, Button, ys W60 H22 gOptCancel, Cancel
Gui, 2:Show,, Options
return

OptOK:
Gui, 2:Submit, NoHide
2GuiClose:
2GuiEscape:
OptCancel:
Gui 1:+LastFoundExist
IfWinExist
	Gui, 1:-Disabled
Gui, 2:Destroy
return

ShowPasteMenu:
TotalItems := ClipArray.MaxIndex()
Loop, %MenuMax%
{
	ThisMenu := SubStr(ClipArray[A_Index], 1, 50)
	If ThisMenu =
		break
	Menu, ClipHistory, Add, %A_Index%: %ThisMenu%, Paste
}
Menu, ClipHistory, Add
Menu, ClipHistory, Add, &A 粘贴全部, PasteAll
Menu, ClipHistory, Add, &R 反序, Reverse
Menu, ClipHistory, Add, &C 清空, Clear
Menu, ClipHistory, Add
Menu, ClipHistory, Add, &X 显示全部(%TotalItems%), ShowHistory
Menu,ClipHistory,Add,&Z 停止收录,Togshoulu
menu,ClipHistory,%PopTog%,&Z 停止收录
Menu, ClipHistory, Show
Menu, ClipHistory, DeleteAll
return


Paste:
NoChange := 1
SelectedClip := RTrim(SubStr(A_ThisMenuItem, 1, 2), ":")
Clipboard := ClipArray[SelectedClip]
Clipwait
Send ^v
return

PasteAll:
NoChange := 1
AllClip := ""
For Index, Value in ClipArray
	AllClip .= Value
If AllClip =
{
	NoChange := 0
	return
}
Clipboard := AllClip
Clipwait
Send ^v
return

Copy:
NoChange := 1
Gui, Submit, NoHide
If LV_GetCount("Selected") = 0
	return
RowNumber := LV_GetNext(0)
LV_GetText(ArrayId, RowNumber, 1)
Clipboard := ClipArray[ArrayId]
return

Delete:
Gui, Submit, NoHide
If LV_GetCount("Selected") = 0
	return
RowNumber := LV_GetNext(0)
ClipArray.Remove(RowNumber)
GoSub, Update
return

Clear:
ClipArray := Object()
ClipAllArray := Object()



Update:
ClipCount := ClipArray.MaxIndex()
If (ClipCount > ClipMax)
	ClipArray.Remove(ClipCount, ClipCount)
LV_Delete()
GuiControl, -Redraw, ClipHistory
For Index, Element in ClipArray
	LV_Add("", Index, Element)
GuiControl, +Redraw, ClipHistory
return

Reverse:
ReverseArray(ClipArray)
GoSub, Update
return

ReverseArray(ByRef Array)
{
	Count := Array.MaxIndex() +1
	For Index, Value in Array
		Value%A_Index% := Array[Index]
	For Index, Value in Array
		Array[Count - Index] := Value%A_Index%
}

GuiClose:
GuiEscape:
Gui, Destroy
return

GuiSize:
If A_EventInfo = 1
	return

GuiWidth := A_GuiWidth
GuiHeight := A_GuiHeight

GuiControl, Move, ClipHistory, % "W" GuiWidth-20 "H" GuiHeight-45
return

ClipHistory:
If A_GuiEvent = DoubleClick
	GoSub, Copy
return

PauseScript:
Suspend
Pause
return

Reload:
Reload
return

Edit:
Edit
return

About:
msgbox,版本号:   2016.4.11
return

Exit:
ExitApp

;        修改热键
$F6::
goto,ShowPasteMenu
return

^F6::F6

