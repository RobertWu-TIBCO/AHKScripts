;���ߣ�С����
;�ű���AHK-Windows
;���ͣ�http://rrsyycm.com
;���ԣ�AutoHotkey1.1.22
;���ڣ�2016��4��9��08:43 �ڶ���
/*ʹ��˵��
��������һ�����ڱ���Ϊ"AutoHotkey ���İ���"��ô�㰴�¿ո񣨲�Ҫ�ɿ����ڵ��zwbz�ͻ��"AutoHotkey ���İ���"���ڼ�����ǰ��ʱ���ɿ��ո�
�ڰ��¿ո���һ���ַ���ʱ������ͼ�����ʾ��ƥ��Ĵ����б����ڱ���ǰ�������ֱ�ע���±����Ӧ�����ּ����
ע����ǰҪ��ô��Ǹ�����Ĵ��ڰ��¶�Ӧ���ַ� �ű���һ���ṩ���б����㰴�µ�һ���ַ���ƥ��Ĵ���
*/
#Persistent
#SingleInstance force
;Functions()
tcmatch := "Tcmatch.dll"
hModule := DllCall("LoadLibrary", "Str", tcmatch, "Ptr")
D_QZ=qwertyuiopasdfghjklzxcvbnm
Loop,Parse,D_QZ
	Hotkey,~Space & ~%A_LoopField%,D_HOTKEY
return
!q::
	WinMinimize,A
return
D_HOTKEY:
	D_LIS :=
	D_PP :=
	StringRight,D_KEY,A_ThisHotkey,1
	D_HOT = %D_HOT%%D_KEY%
	D_HOT := Trim(D_HOT)
	D_VAR := StrLen(D_HOT)
	WinGet,WinList,List
	Loop,%WinList% {
		id:=WinList%A_Index%
		WinGetTitle,D_Title,ahk_id %id%
		if (matched := DllCall("Tcmatch\MatchFileW","WStr",D_HOT,"WStr",D_Title)){
			D_PP++
			D_LIS=%D_LIS%`n%D_PP%-%D_Title%
		}
	}
	D_LIS := Trim(D_LIS,"`n")
	StringSplit,D_LS,D_LIS,`n
	TrayTip,%D_HOT%,%D_LIS%
	if (D_PP="1"){
		StringTrimLeft,D_LS1,D_LS1,2
		WinActivate,%D_LS1%
		gosub,D_WAIT
	}
	if (D_VAR="1"){
		Loop,9{
			Hotkey,%A_Index%,D_1
			Hotkey,%A_Index%,On
		}
		SetTimer,D_WAIT,100
	}
return
D_WAIT:
	KeyWait,Space,L
	Loop,9
	Hotkey,%A_Index%,off
	SetTimer,D_WAIT,Off
	TrayTip
	D_HOT:=
return
D_1:
	StringSplit,D_LS,D_LIS,`n
	StringTrimLeft,D_LS,D_LS%A_ThisHotkey%,2
	WinActivate,%D_LS%
	gosub,D_WAIT
return