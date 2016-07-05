;====================================
; ����Сѩ ��Ʒ
; http://wwww.snow518.cn/
;====================================

#Persistent
#SingleInstance force
#Include ..\includes\LibINI.ahk

SetKeyDelay, -1
app := SubStr(A_ScriptName, 1, StrLen(A_ScriptName) - 4)
iniFile = %app%.ini
ini_Load(src,iniFile)
sec:=ini_GetSections(src)
Menu,Tray,NoIcon
Loop,Parse,sec,`n
{
    _Menu:=A_LoopField
	key:=ini_GetKeys(src,A_LoopField)
	Loop,Parse,key,`n
		Menu,%_Menu%,Add,%A_LoopField%,MenuHandler
	Menu,Tray,Add,%_Menu%,:%_Menu%
}
Menu,Tray,NoStandard
Menu,Tray,Add
Menu,Tray,Add, �༭(&E), Menu_Edit
Menu,Tray,Add, ˢ��(&R), Menu_Refresh
Menu,Tray,Add, �˳�(&X), Menu_Exit
return

#Z::
WinGet, old_win, ID, A
Menu,Tray, Show
Return

MenuHandler:
WinActivate ahk_id %old_win%
links:=ini_Read(src,A_ThisMenu,A_ThisMenuItem)
StringReplace, links, links, \n, `r`n, All
_SendRaw(links)
return

Menu_Exit:
ExitApp
Return

Menu_Edit:
Run, edit %A_ScriptDir%\%app%.ini
Return

Menu_Refresh:
Reload
Return

_SendRaw(Keys)
{
    Len := StrLen(Keys) ; �õ��ַ����ĳ��ȣ�ע��һ�������ַ��ĳ�����2
    KeysInUnicode := "" ; ��Ҫ���͵��ַ�����
    Char1 := "" ; �ݴ��ַ�1
    Code1 := 0 ; �ַ�1��ASCII�룬ֵ���� 0x0-0xFF (��1~255)
    Char2 := "" ; �ݴ��ַ�2
    Index := 1 ; ����ѭ��
    Loop
    {
		Code2 := 0 ; �ַ�2��ASCII��
		Char1 := SubStr(Keys, Index, 1) ; ��һ���ַ�
		Code1 := Asc(Char1) ; �õ���ASCIIֵ
		if(Code1 >= 129 And Code1 <= 254 And Index < Len) ; �ж��Ƿ������ַ��ĵ�һ���ַ�
		{
			Char2 := SubStr(Keys, Index+1, 1) ; �ڶ����ַ�
			Code2 := Asc(Char2) ; �õ���ASCIIֵ
			if(Code2 >= 64 And Code2 <= 254) ; ������������˵���������ַ�
			{
				Code1 <<= 8 ; ��һ���ַ�Ӧ�ŵ���8λ��
				Code1 += Code2 ; �ڶ����ַ����ڵ�8λ��
			}
			Index++
		}
		if(Code1 <= 255) ; �����ֵ��<=255��˵���Ƿ������ַ������򾭹�����Ĵ����Ȼ����255
			Code1 := "0" . Code1
		KeysInUnicode .= "{ASC " . Code1 . "}"
		if(Code2 > 0 And Code2 < 64)
		{
			Code2 := "0" . Code2
			KeysInUnicode .= "{ASC " . Code2 . "}"
		}
		Index++
		if(Index > Len)
			Break
    }
Send % KeysInUnicode
}
