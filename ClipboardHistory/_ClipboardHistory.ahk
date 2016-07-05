; Pulover's Clipboard History  
; Modified By sixtyone at April 8,2016
;�ȼ���F6
;������ʷ
/*
2016.4.11 :
	1.�����˵�����"ֹͣ��¼";
	2.�����˵�ѡ�����ӿ�ݼ�ѡ��;
	3.���̲˵�������ؼ��༭����;
	4.�������̹��ڲ˵�:��ʾ�汾��


*/

#NoEnv
#SingleInstance force
#InstallKeybdHook

Menu, Tray, Add, �������¼, ShowHistory
Menu, Tray, Add
Menu, Tray, Add,����,About
Menu, Tray, Add,ֹͣ��¼,Togshoulu
Menu, Tray, Add, ѡ��(&Option), Options
Menu, Tray, Add, �༭(&Edit), Edit
Menu, Tray, Add, ����(&Reload), Reload
Menu, Tray, Add
Menu, Tray, Add, ��ͣ(&PauseScript), PauseScript
Menu, Tray, Add, �˳�(E&xit), Exit
Menu, Tray, NoStandard
Menu, Tray, Default, �������¼
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
if Togshoulu																										;��ͣ��¼��־
	return
If Clipboard =
	return
TotalItems2 := ClipArray.MaxIndex()
Loop, %TotalItems2%																						;���������ͬ��,����¼
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
Menu,Tray,ToggleCheck,ֹͣ��¼
PopTog :=(Tog :=!Tog) ?  "Check" :  "UnCheck"
Togshoulu:=!Togshoulu																									;��ͣ��¼
return


ShowHistory:
Gui 1:+LastFoundExist
IfWinExist
{
	WinActivate
	Goto, Update
}
Gui +Resize +AlwaysOnTop
Gui, Add, Button, Default gCopy, ����
Gui, Add, Button, x+10 gDelete, ɾ��
Gui, Add, Button, x+10 gClear, ���
Gui, Add, Button, x+10 gOptionsButton, ѡ��
Gui, Add, ListView, xm r21 w300 -Multi vClipHistory gClipHistory, ���|����
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
Menu, ClipHistory, Add, &A ճ��ȫ��, PasteAll
Menu, ClipHistory, Add, &R ����, Reverse
Menu, ClipHistory, Add, &C ���, Clear
Menu, ClipHistory, Add
Menu, ClipHistory, Add, &X ��ʾȫ��(%TotalItems%), ShowHistory
Menu,ClipHistory,Add,&Z ֹͣ��¼,Togshoulu
menu,ClipHistory,%PopTog%,&Z ֹͣ��¼
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
msgbox,�汾��:   2016.4.11
return

Exit:
ExitApp

;        �޸��ȼ�
$F6::
goto,ShowPasteMenu
return

^F6::F6

