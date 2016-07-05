#Persistent
#SingleInstance force
#UseHook
#InstallKeybdHook
#ErrorStdOut	;关闭错误报告
;预设热键
Hotkey,NumpadEnter,Ente
Hotkey,NumpadEnter,off
Loop,9{
	Hotkey,!%A_Index%,D_Alt
	Hotkey,!%A_Index%,off
}
Hotkey,!q,WinMinimize
Hotkey,!w,WinMaximize
Hotkey,!e,WinMove
Hotkey,!r,Temporary
Hotkey,!q,off
Hotkey,!w,off
Hotkey,!e,off
Hotkey,!r,off
;预设信息
D_MY=Habit	;脚本名	托盘图标显示的名字
D_bb=1542	;版本号
D_QQ=4845514	;作者QQ
D_bx=新版介绍：`n修改：回车切换为数字键盘小回车`n新增：默认输入法设置功能`n开启博客讨论功能	;版本信息
D_url=http://www.rrsyycm.com/habit.html	;脚本分享网址
D_qiniu=http://7xnfay.dl1.z0.glb.clouddn.com/update.txt?fakeParam=%A_Now%	；更新信息文件
;获取输入法
Array := Object()
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
	Layout=%Layout%
	SetFormat,IntegerFast,d
	Array.Insert(Layout)
}
;创建数据库
sDatabaseName = %A_MyDocuments%\Habit.MDB
sTableName := "Habit"
adOpenStatic := 3, adLockOptimistic := 3, adUseClient := 3
AttributeString := FileExist(sDatabaseName)
if not AttributeString {
	TrayTip,,正在创建数据库
	oCatalog := ComObjCreate("ADOX.Catalog")
	oCatalog.Create("Provider='Microsoft.Jet.OLEDB.4.0';Data Source=" sDatabaseName)
	oTable := ComObjCreate("ADOX.Table")
	oTable.Name := sTableName
	oTable.Columns.Append("pid",202,50)
	for index, element in Array{
		oTable.Columns.Append(element,202,50)
}
oTable.Columns.Append("Hotkeys",202,50)
oTable.Columns.Append("Route",202,200)
oCatalog.Tables.Append(oTable)
oTable := ""
oCatalog := ""
}
oConnection := ComObjCreate("ADODB.Connection")
sConnectionString := "provider=Microsoft.Jet.OLEDB.4.0;Data Source=" . sDatabaseName
oConnection.Open(sConnectionString)
;创建MENU
;if (A_OSVersion="WIN_7")
;Menu,Tray,Icon,shell32.dll,174,1
Menu,Tray,Click,1
Menu,Tray,Add,%D_MY%,Menu
Menu,Tray,Add
Menu,Tray,Add,联系作者
Menu,Tray,Add,帮助信息
Menu,D_Set,Add,开机启动
Menu,D_Set,Add,启动更新
Menu,D_Set,Add,回车切换
Menu,D_Set,Add,窗口热键
Menu,D_Set,Add,调试开关
Menu,D_Set,Add,清除数据
Menu,Tray,Add,脚本设置,:D_Set
Menu,D_Hotkey,Add,开启/关闭
Menu,Tray,Add,热键设置,:D_Hotkey
for index, element in Array{
	RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%element%,Layout Text
RegRead,D_Method,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitMethod
Menu,D_Method,Add,%IMEName%,S_Method
if (D_Method=element)
	Menu,D_Method,ToggleCheck,%IMEName%
}
Menu,Tray,Add,默认输入,:D_Method
Menu,Tray,Add
Menu,Tray,Add,重启脚本
Menu,Tray,Add,退出脚本
Menu,Tray,Default,%D_MY%
Menu,Tray,NoStandard
Menu,Tray,Tip,当前版本:%D_bb%`n点击进去%D_MY%博客
if (A_OSVersion="WIN_7"){
	Menu,Tray,Icon,%D_MY%,shell32.dll,157,18
	Menu,Tray,Icon,联系作者,shell32.dll,282,18
	Menu,Tray,Icon,帮助信息,shell32.dll,285,18
	Menu,Tray,Icon,脚本设置,shell32.dll,288,18
	Menu,Tray,Icon,热键设置,shell32.dll,290,18
	Menu,Tray,Icon,默认输入,shell32.dll,289,18
	Menu,Tray,Icon,重启脚本,shell32.dll,287,18
	Menu,Tray,Icon,退出脚本,shell32.dll,283,18
}
;菜单项开关
IfExist ,%A_Startup%\%A_ScriptName%.lnk
	Menu,D_Set,ToggleCheck,开机启动
RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
if D_Enter{
	Menu,D_Set,ToggleCheck,回车切换
	Hotkey,NumpadEnter,Toggle
}
RegRead,D_windows,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitwindows
if D_windows{
	Menu,D_Set,ToggleCheck,窗口热键
	Hotkey,!q,Toggle
	Hotkey,!w,Toggle
	Hotkey,!e,Toggle
	Hotkey,!r,Toggle
}
RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitBoss
if D_Boss{
	Menu,D_Hotkey,ToggleCheck,开启/关闭
	gosub,D_cx
	Loop,9{
		Hotkey,!%A_Index%,Toggle
		K_Hotkeys=!%A_Index%
		H_Hotkeys = Hotkeys = '%K_Hotkeys%'
		oRecordset.Find(H_Hotkeys,,,1)
		if !oRecordset.EOF{
			X_pid:=oRecordset.Fields["pid"].Value
			Menu,D_Hotkey,Add,!%A_Index%-%X_pid%,S_Hotkey
		}
	}
}
RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate
if D_update{
	Menu,D_Set,ToggleCheck,启动更新
	if A_TickCount<20000
		SetTimer,立即检查,90000
	else
		gosub,立即检查
}
TrayTip,,Habit已启动
;启动脚本
Loop{
	IfWinNotActive,ahk_exe %D_Name%
	{
		WinGet,D_Name,ProcessName,A
		if not D_Name
			continue
		gosub,D_cx
		sSearchCriteria = pid = '%D_Name%'
		oRecordset.Find(sSearchCriteria,,,1)
		if oRecordset.EOF{
			oRecordset.AddNew()
			for index, element in Array
			{
				oRecordset.Fields[element]:="1"
			}
			WinGet,D_Route,ProcessPath,A
			oRecordset.Fields["pid"]:= D_Name
			oRecordset.Fields["Hotkeys"]:= "0"
			oRecordset.Fields["Route"]:= D_Route
			oRecordset.Update()
		}else{
			D_Big=1
			D_Value=
			for index, element in Array
			{
				A_element:=oRecordset.Fields[element].Value
				if (A_element>D_Big){
					D_Big=%A_element%
					D_Value=%element%
				}
				if (A_element=D_Big)
					RegRead,D_Value,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitMethod
			}
			if D_TX
				TrayTip,,%D_Name%`n配置:%D_Value%-%D_Big%
			SwitchIME(D_Value)
		}
		X_Name=
	}
	if A_TimeIdlePhysical<200
		if A_PriorKey in q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,
			if (X_Name<>D_Name)
			{
				SetFormat,integer,hex
				HKL:=DllCall("GetKeyboardLayout","int",GetThRead(),UInt)
				StringTrimLeft,Layout,HKL,2
				Layout:= HKL=0x8040804 ? "00000804" : Layout
				Layout:= HKL=0x4090409 ? "00000409" : Layout
				SetFormat,IntegerFast,d
				;-----------------------------
				gosub,D_cx
				D_SS = pid = '%D_Name%'
				oRecordset.Find(D_SS,,,1)
				A_Layout:=oRecordset.Fields[Layout].Value
				J_Layout:=A_Layout+1
				if D_TX
					TrayTip,,%D_Name%`n写入:%Layout%-%J_Layout%`n%A_PriorKey%	;--------
				oRecordset.Fields[Layout]:= J_Layout
				oRecordset.MoveNext()
				X_Name=%D_Name%
			}
	Sleep, 100
}
return
;菜单项功能
帮助信息:
	Gui,D_about:New
	Gui,D_about:+AlwaysOnTop -MinimizeBox -MinimizeBox +Owner
	Gui,D_about:Add,Pic,w30 h-1 Icon222 Section,shell32.dll
	Gui,D_about:Add,Text,x+10 ys+5 ,版本信息：%D_bb%`n开发语言：AutoHotkey_L 11.22.06
	Gui,Font,s12,Arial
	Gui,D_about:Add,Edit,xs w300 R5 ReadOnly,%D_bx%
	Gui,Font
	Gui,D_about:Add,Link,xs,脚本讨论： <a href="%D_url%">进入作者博客了解更多</a>
	Gui,D_about:Show,AutoSize,帮助信息
return
Menu:
	Run http://www.rrsyycm.com/habit.html
return
开机启动:
	Menu,D_Set,ToggleCheck,开机启动
	IfExist,%A_Startup%\%A_ScriptName%.lnk
		FileDelete,%A_Startup%\%A_ScriptName%.lnk
	else
		FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%\%A_ScriptName%.lnk
return
启动更新:
	Menu,D_Set,ToggleCheck,启动更新
	RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate
	if D_update
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate,To update
return
回车切换:
	Menu,D_Set,ToggleCheck,回车切换
	Hotkey,NumpadEnter,Toggle
	RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
	if D_Enter
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter,Switch
return
窗口热键:
	Menu,D_Set,ToggleCheck,窗口热键
	Hotkey,!q,Toggle
	Hotkey,!w,Toggle
	Hotkey,!e,Toggle
	Hotkey,!r,Toggle
	RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitwindows
	if D_Enter
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitwindows
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitwindows,windows
return
调试开关:
	Menu,D_Set,ToggleCheck,调试开关
	D_TX:=!D_TX
return
开启/关闭:
	Menu,D_Hotkey,ToggleCheck,开启/关闭
	Loop,9
		Hotkey,!%A_Index%,Toggle
	RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitBoss
	if D_Boss
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitBoss
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitBoss,Boss
return
GuiClose:
	Gui,Cancel
return
联系作者:
	Run tencent://message/?uin=%D_QQ%
return
清除数据:
	MsgBox,4,清除数据,这是一个不可逆操作`n确定要清除数据吗？
	IfMsgBox Yes
	{
		oRecordset.Close()
		oConnection.Close()
		FileDelete,%sDatabaseName%
		Reload
	}
重启脚本:
	oRecordset.Close()
	oConnection.Close()
	Reload
退出脚本:
	ExitApp
	;附属功能
S_Method:
	for index, element in Array{
		RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%element%,Layout Text
	if (A_ThisMenuItem=IMEName){
		Menu,D_Method,ToggleCheck,%A_ThisMenuItem%
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitMethod,%element%
	}else{
		Menu,D_Method,Uncheck,%IMEName%
	}
	}
return
S_Hotkey:	;删除老板键
	gosub,D_cx
	StringLeft,S_Hotkey,A_ThisMenuItem,2
	H_Hotkeys = Hotkeys = '%S_Hotkey%'
	oRecordset.Find(H_Hotkeys,,,1)
	oRecordset.Fields["Hotkeys"]:= "0"
	oRecordset.MoveNext()
	Menu,D_Hotkey,Delete,%A_ThisMenuItem%
	StringReplace,S_pid,A_ThisMenuItem,%S_Hotkey%-, , All
	TrayTip,,%S_pid%的热键`n"%S_Hotkey%"已经删除
return
D_Alt:	;老板键
	gosub,D_cx
	H_Hotkeys = Hotkeys = '%A_ThisHotkey%'
	oRecordset.Find(H_Hotkeys,,,1)
	if oRecordset.EOF{
		oRecordset.Find(sSearchCriteria,,,1)
		X_Route:=oRecordset.Fields["Route"].Value
		IfInString, X_Route, C:\Windows
		{
			TrayTip,,禁止为系统目录下程序设置热键`n%X_Route%
			return
		}
		oRecordset.Fields["Hotkeys"]:= A_ThisHotkey
		oRecordset.MoveNext()
		Menu,D_Hotkey,Add,%A_ThisHotkey%-%D_Name%,S_Hotkey
		TrayTip,,已为%D_Name%`n创建老板键"%A_ThisHotkey%"
	}else{
		X_Route:=oRecordset.Fields["Route"].Value
		X_pid:=oRecordset.Fields["pid"].Value
		IfWinActive ,ahk_exe %X_pid%
			WinMinimize
		else
			IfWinExist ,ahk_exe %X_pid%
				WinActivate
			else
				Run %X_Route%
	}
return
Ente:	;回车切换
	Send {NumpadEnter}
	gosub,D_cx
	oRecordset.Find(sSearchCriteria,,,1)
	D_Big=
	D_Value=
	for index, element in Array
	{
		A_element:=oRecordset.Fields[element].Value
		if (A_element>D_Big){
			D_Big=%A_element%
			D_Value=%element%
		}
	}
	;TrayTip,,%D_Name%`n配置:%D_Value%-%D_Big%
	SwitchIME(D_Value)
return
;窗口操作
WinMinimize: 	 ;窗口最小化
	WinMinimize A
return
WinMaximize:	;窗口最大化
	WinMaximize A
return
Temporary:	;临时老板键
	if (win_cs > 0){
		win_cs += 1
		return
	}
	win_cs = 1
	SetTimer, KeyAlt, 300
return
KeyAlt:
	SetTimer, KeyAlt, off
	if (win_cs = 1){
		IfWinActive ,ahk_id %win_id%
		{
			WinMinimize
			win_cs = 0
		}else{
			WinActivate ,ahk_id %win_id%
			win_cs = 0
		}
		return
	}
	if (win_cs = 2){
		WinGet,win_id,id,A
		WinMinimize A
	}else if (win_cs > 2){
		WinClose,ahk_id %win_id%
		win_id =
	}
	win_cs = 0
return
WinMove:	;把当前窗口还原后移到屏幕正中间!
	D_Width:=(A_ScreenWidth/2)
	D_Height:=(A_ScreenHeight/2)
	WinGetPos,X,Y,Width,Height,A
	if not D_window {
		WinMove,A,,A_ScreenWidth/8,A_ScreenHeight/8,(A_ScreenWidth/8)*6,(A_ScreenHeight/8)*6
		D_window=1
		return
	}
	if (X<D_Width) and (Y<D_Height-200)	;左上
		WinMove,A,,D_Width,,D_Width,D_Height
	if (X>D_Width-200) and (Y<D_Height-200)	;右上
		WinMove,A,,,D_Height,D_Width,D_Height
	if (X>D_Width-200) and (Y>D_Height-200)	;右下
		WinMove,A,,0,D_Height,D_Width,D_Height
	if (X<D_Width-200) and (Y>D_Height-200){	;左下
		WinMove,A,,,0,D_Width,D_Height
		D_window=
	}
;调用函数
GetThread(){	;获取当前窗口输入法
	ResultID:=0
	hWnd:=WinExist("A")
	VarSetCapacity( thE, 28, 0 )
	NumPut( 28, thE )
	WinGet,processID,pid,ahk_id %hWnd%
	hProcessSnap := DllCall("CreateToolhelp32Snapshot","uint",4, "uint",processID)
	If (DllCall("Thread32First","uint",hProcessSnap, "uint",&thE )=0)
		Return 0
	Loop{
		If (NumGet(thE,12) = processID){
			DllCall("CloseHandle","uint",hProcessSnap)
			ResultID:=NumGet(thE,8)
			Return ResultID
		}
		NumPut( 28, thE )
		if( DllCall("Thread32Next","uint",hProcessSnap, "uint",&thE )=0){
			DllCall("CloseHandle","uint",hProcessSnap)
			Return 0
		}
	}
}
SwitchIME(dwLayout){	;修改当前窗口输入法
	HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A
}
D_CX:	;查询数据库
	oRecordset := ComObjCreate("ADODB.Recordset")
	oRecordset.CursorLocation := adUseClient
	oRecordset.Open("SELECT * FROM Habit ORDER BY pid DESC, Hotkeys DESC", oConnection, adOpenStatic, adLockOptimistic)
return
;更新功能
立即检查:
	SetTimer,立即检查,Off
	SplitPath,D_qiniu,,,,,OutDrive
	update:=W_InternetCheckConnection(OutDrive)
	if not update
		return
	D_Array := StrSplit(DownloadToString(D_qiniu,"cp936"),"`n")
	D_Edit := D_Array[1] ;读取第一行版本号
	D_link := D_Array[2] ;读取第二行下载文件连接
	D_Name := D_Array[3] ;新文件名
	D_xing := D_Array[4] ;更新信息
	StringReplace, D_Edit, D_Edit, `r, , All
	StringReplace, D_link, D_link, `r, , All
	StringReplace, D_Name, D_Name, `r, , All
	StringReplace, D_xing, D_xing, `r, , All
	if D_Edit is not number
	{
		TrayTip,,获取更新失败,10, 1
		return
	}
	if (D_Edit > D_bb)
	{
		MsgBox,4,检测到新版本,是否更新至:%D_Edit%`n%D_xing%
		IfMsgBox Yes
			gosub,D_Label
	}
return
D_Label:
	D_kb := InternetFileGetSize(D_link)
	Progress,1,%S_kb%/%D_kb%,正在更新...,AHK更新
	FileDelete,%A_Temp%\%D_Name%
	SetTimer,S_Label,500
	URLDownloadToFile,%D_link%,%A_Temp%\%D_Name%
	SetTimer,S_Label,Off
	if ErrorLevel{
		TrayTip,,更新文件下载出错,10, 1
		return
	}
	else{
		Progress,100
		gosub,ExitSub
	}
return
S_Label: ;获取下载临时文件的大小更新进度
	FileGetSize,S_kb,%A_Temp%\%D_Name%
	D_xz := S_kb/D_kb
	D_xz := D_xz*100
	StringLeft,D_xz,D_xz,2
	Progress,%D_xz%,%S_kb%/%D_kb%,正在更新...,AHK更新
return
ExitSub:
	if (A_IsCompiled) ;自杀并打开更新后的程序
	{
		bat=
		(LTrim
:start
	ping 127.0.0.1 -n 2>nul
	del `%1
	if exist `%1 goto start
	copy %A_Temp%\%D_Name% %A_ScriptDir%
	start %D_Name%
	del `%0
	)
	batfilename=Delete.bat
	IfExist %batfilename%
		FileDelete %batfilename%
	FileAppend, %bat%, %batfilename%
	Run,%batfilename% "%A_ScriptFullPath%", , Hide
	ExitApp
	}
ExitApp
W_InternetCheckConnection(lpszUrl){ ;检查FTP服务是否可连接
	FLAG_ICC_FORCE_CONNECTION := 0x1
	dwReserved := 0x0
	return, DllCall("Wininet.dll\InternetCheckConnection", "Ptr", &lpszUrl, "UInt", FLAG_ICC_FORCE_CONNECTION, "UInt", dwReserved, "Int")
}
InternetFileGetSize(URL:=""){  ;获取网络文件大小
	Static LIB="WININET\", CL="00000000000000", N=""
	QRL := 16
	if ! DllCall( "GetModuleHandle", Str,"wininet.dll" )
		DllCall( "LoadLibrary", Str,"wininet.dll" )
	if ! hIO:=DllCall( LIB "InternetOpenA", Str,N, UInt,4, Str,N, Str,N, UInt,0 )
		return -1
	if ! (( hIU:=DllCall( LIB "InternetOpenUrlA", UInt,hIO, Str,URL, Str,N, Int,0, UInt,F, UInt,0 ) ) || ErrorLevel )
		return "",0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 2
	if ! ( RB  )
		if ( SubStr(URL,1,4) = "ftp:" )
			CL := DllCall( LIB "FtpGetFileSize", UInt,hIU, UIntP,0 )
		else if ! DllCall( LIB "HttpQueryInfoA", UInt,hIU, Int,5, Str,CL, UIntP,QRL, UInt,0 )
			return "",0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIU ) )-( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 4
	return CL
}
DownloadToString(URL, encoding="utf-8")	;下载文件到变量
{
	static a := "AutoHotkey/" A_AhkVersion
	if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen","str",a,"uint",1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
		return 0
	c:=s:=0,o:=""
	if(f:=DllCall("wininet\InternetOpenUrl","ptr",h,"str",url,"ptr",0,"uint",0,"uint",0x80003000,"ptr",0,"ptr"))
	{
		while (DllCall("wininet\InternetQueryDataAvailable","ptr",f,"uint*",s,"uint",0,"ptr",0) &&s>0)
		{
			VarSetCapacity(b,s,0)
			DllCall("wininet\InternetReadFile","ptr",f,"ptr",&b,"uint",s,"uint*",r)
			o.= StrGet(&b,r>>(encoding="utf-16"||encoding="cp1200"),encoding)
		}
		DllCall("wininet\InternetCloseHandle","ptr", f)
}
DllCall("wininet\InternetCloseHandle","ptr",h)
return o
}