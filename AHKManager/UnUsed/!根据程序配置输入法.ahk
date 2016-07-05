;--------------------------------------V1.1504A
;~ 修改排除配置文件的模式
;~ 修改功能为托盘图标
;~ 修改窗口样式为透明
;~ 修改可检测隐藏窗口如QQ
;~ 修改添加模式更直观
;~ 修改保存时出现的重复现象
;~ 修改一些笨方法的判断方式
;--------------------------------------需要先配置
#ErrorStdOut
#Persistent
#SingleInstance force
HKLnum:=DllCall("GetKeyboardLayoutList","uint",0,"uint",0)
VarSetCapacity( HKLlist, HKLnum*4, 0 )
DllCall("GetKeyboardLayoutList","uint",HKLnum,"uint",&HKLlist)
Loop,%HKLnum%
{
	SetFormat, integer, hex
	HKL:=NumGet( HKLlist,(A_Index-1)*4 )
	StringTrimLeft,Layout,HKL,2
	Layout:= Layout=8040804 ? "00000804" : Layout
	Layout:= Layout=4090409 ? "00000409" : Layout
	RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%Layout%,Layout Text
	SetFormat, integer, D
	if IMEName
	{
		输入法 = %IMEName%`n%Layout%| %输入法%
	}
}
Hotkey, Enter ,Ente
Hotkey, Enter ,off
;--------------------------------------Menu界面
Menu, Tray, Tip, By，小死猛
Menu, Tray, Add, By，小死猛, Menu_显示窗口
Menu, Tray, Add, 联系作者, Menu_联系作者
Menu, Tray, Add, 支持作者, Menu_支持作者
Menu, Tray, Add,
Menu, Tray, Add, 开启脚本, Menu_开启脚本
Menu, Tray, Add, 回车切换, Menu_回车切换
Menu, Tray, Add, 开机启动, Menu_开机启动
Menu, Tray, Add, 隐藏可见, Menu_隐藏可见
Menu, Tray, Add,
Menu, Tray, Add, 重启脚本, Menu_重启脚本
Menu, Tray, Add, 退出脚本, Menu_退出脚本
Menu, Tray, Default, By，小死猛
Menu, tray, NoStandard
;--------------------------------------Gui界面
CustomColor = EEAA99
Gui,+LastFound -AlwaysOnTop -Caption +ToolWindow ; changed AlwaysOnTop to false , Caption means title
Gui, Add, GroupBox, xm ym vBian w360 h165 cff0000,单击列表项配置输入法
Gui, Add, ListView, Checked -Hdr Multi Report AltSubmit  r7 x20 y22 w340 gMyListView vMyListView,进程ID|输入状态|中英|编号|路径
Gui, Add,DropDownList,x20 y145 w165 vColorChoice gColorChoice Choose1,%输入法%
Gui, Add,Button,x+23 h20 vqiehuan gqiehuan, Shift切换
Gui, Add,Button,x+23 h20 gbao, 刷新保存
Gui, Show, AutoSize
Gui, Hide ; add this to hide the window!
Gui,Color, %CustomColor%
GuiControl +Backgroundf6f6e8, MyListView
WinSet, TransColor, %CustomColor%
Gui +HwndMyGuiHwnd
;--------------------------------------出现界面后需要执行
GuiStart()
GuiControl, Disable,qiehuan
IfExist ,%A_Startup%\输入法.lnk
{
	gosub,Menu_开启脚本
	Menu, tray, rename, 开机启动, 关闭自启
	Gui,Cancel
}
return
;--------------------------------------Menu命令一
Menu_显示窗口:
	IfWinExist, ahk_id %MyGuiHwnd%
	{
		Gui,Cancel
		return
	}
	Gui,Show
	GuiControl,,bian,单击列表项配置输入法
	名称 =
return
Menu_联系作者:
	Run tencent://message/?uin=4845514
return
Menu_支持作者:
	SetTimer,ChangeButtonNames,50
	MsgBox,4,感谢支持本功能,感谢支持本功能`n小时候答应姐姐，她要老了牙口不好。`n给他换一口陶瓷牙，还剩22颗牙没换求赞助。
	IfMsgBox Yes
		MsgBox 支付宝帐号：skc2015@163.com`n户名：刘猛
return
ChangeButtonNames:
	IfWinNotExist,感谢支持本功能
		return
	SetTimer,ChangeButtonNames,off
	WinActivate
	ControlSetText,Button1,获取账号
	ControlSetText,Button2,残忍拒绝
return
;--------------------------------------Menu命令二段
Menu_开启脚本:
	if NewName <> 关闭脚本
	{
		SetTimer ,kik,250
		OldName = 开启脚本
		NewName = 关闭脚本
	}
	else
	{
		SetTimer ,kik,Off
		OldName = 关闭脚本
		NewName = 开启脚本
	}
	Menu, tray, rename, %OldName%, %NewName%
return
Menu_回车切换:
	Hotkey, Enter,Toggle
	if neww <> 关闭回车
	{
		name = 回车切换
		neww = 关闭回车
	}
	else
	{
		name = 关闭回车
		neww = 回车切换
	}
	Menu, tray, rename, %name%, %neww%
return
Menu_开机启动:
	IfExist ,%A_Startup%\输入法.lnk
	{
		Menu, tray, rename, 关闭自启, 开机启动
		FileDelete,%A_Startup%\输入法.lnk
	}
	else
	{
		Menu, tray, rename, 开机启动, 关闭自启
		FileCreateShortcut,%A_ScriptDir%\%A_ScriptName%,%A_Startup%\输入法.lnk
	}
return
Menu_隐藏可见:
	if winz <> 关闭可见
	{
		DetectHiddenWindows,On
		winc = 隐藏可见
		winz = 关闭可见
	}
	else
	{
		DetectHiddenWindows,Off
		winc = 关闭可见
		winz = 隐藏可见
	}
	Menu, tray, rename, %winc%, %winz%
return
;--------------------------------------Menu命令三段
Menu_重启脚本:
	Reload
Menu_退出脚本:
ExitApp
;--------------------------------------主要功能
kik:
	Loop % LV_GetCount()
	{
		RowNumber := LV_GetNext(RowNumber,"Checked")
		LV_GetText(进程, RowNumber, 1)
		WinGet, win_pc,ProcessName,A
		IfInString,win_pc, %进程%
		{
			LV_GetText(Layout, RowNumber, 4)
			SwitchIME(Layout)
			LV_GetText(shi, RowNumber, 3)
			if shi = Shift
			{
				Send {Shift}
			}
			WinWaitNotActive,ahk_exe %win_pc%
		}
	}
return
Ente:
	WinGet, win_cl, ProcessName, A
	Loop % LV_GetCount()
	{
		RowNumber := LV_GetNext(RowNumber,"Checked")
		LV_GetText(进程, RowNumber, 1)
		IfInString,win_cl, %进程%
		{
			LV_GetText(Layout, RowNumber, 4)
			SwitchIME(Layout)
			Send {Enter}
			LV_GetText(shi, RowNumber, 3)
			if shi = Shift
			{
				Send {Shift}
			}
			return
		}
	}
	Send {Enter}
return
;--------------------------------------单击控件
MyListView:
	if A_GuiEvent = Normal
	{
		win_xz := A_EventInfo
		if not win_xz
		{  ;避免点击列表中空白部分
			TrayTip,空白,请勿点击列表中空白部分, 10, 2
			return
		}
		LV_GetText(dier, win_xz, 2)
		if not dier
		{  ;判断2列是否含有信息 决定禁用或启用切换按钮
			GuiControl, Disable,qiehuan
		}
		else
		{
			GuiControl, Enable ,qiehuan
		}
		LV_GetText(disan, win_xz, 3)
		if not disan
		{  ;判断3列是否含有信息 决定更换按钮内容
			GuiControl,,qiehuan,Shift切换
			win_shi =Shift
		}
		else
		{
			GuiControl,,qiehuan,取消切换
			win_shi =
		}
		LV_GetText(名称, win_xz,1 ) ;更新外框信息
		GuiControl,,bian,为"%名称%"选择输入法
	}
return
;--------------------------------------添加保存
ColorChoice:
	if not 名称
	{
		TrayTip,未选择,请在列表中选择程序, 10, 1
		return
	}
	Gui, Submit,NoHide
	Loop, Parse,ColorChoice,`n,
	{
		if a_index = 1
		{
			LV_Modify(win_xz,,,A_LoopField)
		}
		if a_index = 2
		{
			LV_Modify(win_xz,,,,,A_LoopField)
		}
	}
	LV_Modify(win_xz,"Check")
	GuiControl, Enable ,qiehuan
return
qiehuan:
	if not 名称
	{
		TrayTip,未选择,请在列表中选择程序, 10, 1
		return
	}
	LV_GetText(dier, win_xz, 2)
	if not dier
	{
		TrayTip,未选择,清先配置%名称%输入法, 10, 1
		return
	}
	LV_GetText(disan, win_xz, 3)
	if not disan
	{
		GuiControl,,qiehuan,取消切换
		win_shi =Shift
	}
	else
	{
		GuiControl,,qiehuan,Shift切换
		win_shi =
	}
	LV_Modify(win_xz,,,,win_shi)
	LV_Modify(win_xz,"Check")
return
bao:
	FileSetAttrib, -R, %A_ScriptDir%\输入法设定.ini
	FileDelete,%A_ScriptDir%\输入法设定.ini
	IfExist ,%A_ScriptDir%\输入法设定.ini ;确保文件被删除
	{
		MsgBox,文件%A_ScriptDir%\输入法设定.ini`n未被删除请检查
		return
	}
	RowNumber =
	Loop % LV_GetCount()
	{
		RowNumber := LV_GetNext(RowNumber,"Checked")
		if not RowNumber
			break
		LV_GetText(进程, RowNumber, 1)
		LV_GetText(状态, RowNumber, 2)
		LV_GetText(中英, RowNumber, 3)
		LV_GetText(编号, RowNumber, 4)
		LV_GetText(路径, RowNumber, 5)
		IniWrite, %进程%, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%
		IniWrite, %进程%, %A_ScriptDir%\输入法设定.ini, %进程%, 进程
		IniWrite, %状态%, %A_ScriptDir%\输入法设定.ini, %进程%, 状态
		IniWrite, %中英%, %A_ScriptDir%\输入法设定.ini, %进程%, 中英
		IniWrite, %编号%, %A_ScriptDir%\输入法设定.ini, %进程%, 编号
		IniWrite, %路径%, %A_ScriptDir%\输入法设定.ini, %进程%, 路径
	}
	GuiStart()
	TrayTip,保存成功,如未刷新出隐藏至托盘的程序`n请开启隐藏可视, 10, 1
return
;--------------------------------------加载列表
GuiStart() {
	LV_Delete()
	WinGet,WinList,List
	WinAll:= Object()
	ImageListID := IL_Create(WinAll)
	LV_SetImageList(ImageListID)
	WinListPN:=
	Loop,%WinList% {
		id:=WinList%A_Index%
		WinGet,win_ll,ProcessName,ahk_id %id%
		WinListPN:=WinListPN win_ll "`n"
	}
	Sort,WinListPN,U ;排除类似IE 或文本文件编辑
	Loop
	{ ;排除配置文件中的项目
		IniRead, 排除, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%,%A_Space%
		if not 排除
		{
			break
		}
		StringReplace, WinListPN, WinListPN, %排除% ,UseErrorLevel ,
	}
	Sort,WinListPN,U ;继续避免重复
	WinList_Array:=StrSplit(RTrim(WinListPN,"`n"),"`n")
	win_A_Index = 1
	For index, 进程 in WinList_Array {
		WinGet,路径,ProcessPath,ahk_exe %进程%
	IfNotExist ,%路径%
	{ ;路径不存在则不添加
		continue
	}
	if (GetIconCount(路径)>0)
		IL_Add(ImageListID, 路径,1)
	else ;图标为空则不添加
		continue
	LV_Add("Icon" . win_A_Index,进程,,,,路径)
	win_A_Index++
}
RowNumber := LV_GetCount() 
Loop
{ ;添加配置文件中项目
	IniRead, win_dq, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%,%A_Space%
	if not win_dq
	{
		break
	}
	RowNumber++
	IniRead, 进程, %A_ScriptDir%\输入法设定.ini, %win_dq%, 进程,%A_Space%
	IniRead, 状态, %A_ScriptDir%\输入法设定.ini, %win_dq%, 状态,%A_Space%
	IniRead, 中英, %A_ScriptDir%\输入法设定.ini, %win_dq%, 中英,%A_Space%
	IniRead, 编号, %A_ScriptDir%\输入法设定.ini, %win_dq%, 编号,%A_Space%
	IniRead, 路径, %A_ScriptDir%\输入法设定.ini, %win_dq%, 路径,%A_Space%
	IfNotExist ,%路径%
	{
		continue
	}
	IL_Add(ImageListID, 路径,1)
	LV_Add("Icon" . RowNumber,进程,状态,中英,编号,路径)
	LV_Modify(RowNumber,"Check")
}
LV_ModifyCol(1,110)
LV_ModifyCol(2,159)
LV_ModifyCol(3,50)
LV_ModifyCol(2,"SortDesc")
LV_ModifyCol(4,0)
LV_ModifyCol(5,0)
}
;--------------------------------------调用与获取
GetImeLayout(_hWnd) { ;取指定窗口使用的输入法代号
	SetFormat, Integer, h
	ThReadID:=DllCall("GetWindowThReadProcessId", "UInt", _hWnd, "UInt", 0)
	InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThReadID, "UInt")
	SetFormat, integer, d
	return %InputLocaleID%
}
GetIconCount(file){ ;排除没有图标的程序
	Menu, test, add, test, handle
	Loop
	{
		try {
			id++
		Menu, test, Icon, test, % file, % id
	} catch error {
	break
}
}
return id-1
}
handle:
return
SwitchIME(dwLayout){ ;修改当前窗口输入法
	HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A
}
;--------------------------------------脚本结束