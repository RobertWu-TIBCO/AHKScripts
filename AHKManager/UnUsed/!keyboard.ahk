Gui, Add, GroupBox, x6 y4 w230 h10 , �Ѱ�װ�����뷨(˫���л�)
Gui, Add, ListView, r20 x6 y24 w230 h120 vListIME gSetIME ,���|���̲���|����
Gui, Add, Button, x6 y144 w80 h30 gPreIME, ��һ���뷨
Gui, Add, Button, x156 y144 w80 h30 gNextIME, ��һ���뷨
Gui, Add, Button, x86 y144 w70 h30 gStateIME, ��ǰ״̬
; Generated using SmartGUI Creator 4.0
Gui, Show, x397 y213 h190 w247,���뷨�л�
Gosub,ReadIME
Return
GuiClose:
ExitApp
ReadIME:
LV_ModifyCol(3,300)
Loop,HKEY_USERS,.DEFAULT/Keyboard Layout/Preload, 1, 1
{
    RegRead,Layout
    RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM/CurrentControlSet/Control/Keyboard Layouts/%Layout%,Layout Text
    RegRead,Layout
     ListContent=%A_LoopRegName%ح%IMEName%ح %Layout%
    LV_Insert(1,"Vis",A_LoopRegName,Layout,IMEName)
}
Return
StateIME:
Result:=DllCall("GetKeyboardLayout","int",0,UInt)
SetFormat, integer, hex
Result += 0
SetFormat, integer, D
MsgBox ��ǰ���̲���Ϊ %Result%
return

SetIME:
If (A_GuiEvent<>"DoubleClick")
{
    Return
}
Gui,Submit,Nohide
LV_GetText(Layout,A_EventInfo,2)
;~ MsgBox %Layout%

SwitchIME(Layout)
Return

SwitchIME(dwLayout)
{
    DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1))
}

NextIME:
DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("ActivateKeyboardLayout", UInt, 1, UInt, 256))
;-- �Ե�ǰ���ڼ�����һ���뷨
Return
PreIME:
DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("ActivateKeyboardLayout", UInt, 0, UInt, 256))
;-- �Ե�ǰ���ڼ�����һ���뷨
Return