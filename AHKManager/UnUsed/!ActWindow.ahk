;作者：小死猛
;脚本：AHK-Windows
;博客：http://rrsyycm.com
;语言：AutoHotkey1.1.22
;日期：2016年4月9日08:43 第二版
/*使用说明
例如你有一个窗口标题为"AutoHotkey 中文帮助"那么你按下空格（不要松开）在点击zwbz就会把"AutoHotkey 中文帮助"窗口激活最前这时可松开空格
在按下空格与一个字符的时候托盘图标会显示所匹配的窗口列表，窗口标题前方有数字标注按下标题对应的数字激活窗口
注：提前要想好打开那个标题的窗口按下对应的字符 脚本第一次提供的列表是你按下第一个字符所匹配的窗口
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