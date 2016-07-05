#Persistent
#SingleInstance force
#UseHook
#InstallKeybdHook
#ErrorStdOut	;关闭错误报告
;
/*预设热键
预先注册热键 在后面让用户选择开启或关闭
*/

Menu, Tray, Icon, F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\eng.ico

Hotkey,Enter,Ente
Hotkey,Enter,off
loop,9{
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
/*预设信息
预设本脚本的 名称 版本 作者QQ 个性设置 与 定义获取更新信息的文件网络路径
*/
D_MY=Habit	;脚本名	托盘图标显示的名字
D_bb=1542	;版本号
D_QQ=4845514	;作者QQ
D_bx=1542版去除了界面`n使用数据库统计输入习惯`n更多脚本帮助信息请访问下方网址	;版本信息
D_url=http://www.rrsyycm.com/habit.html	;脚本分享网址
D_qiniu=http://7xnfay.dl1.z0.glb.clouddn.com/update.txt?fakeParam=%A_Now%	；更新信息文件
/*获取输入法
预设信息加载加载完毕后需要最重要的获取程序当前所安装的输入法为创建数据库列统计信息
将程序所有的输入法编号存在数组中 为后面对程序配置输入法使用
*/
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
sDatabaseName = %A_MyDocuments%Habit.MDB ;定义数据库位置
sTableName := "Habit"
adOpenStatic := 3, adLockOptimistic := 3, adUseClient := 3
AttributeString := FileExist(sDatabaseName)
if not AttributeString { ;判断数据库是否存在
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
Menu,Tray,Add
Menu,Tray,Add,重启脚本
Menu,Tray,Add,退出脚本
Menu,Tray,Default,%D_MY%
Menu,Tray,NoStandard
Menu,Tray,Tip,%D_MY%`n当前版本:%D_bb%
if (A_OSVersion="WIN_7"){ ;判断系统是否为WIN7对菜单添加图标
Menu,Tray,Icon,%D_MY%,shell32.dll,157,18
Menu,Tray,Icon,联系作者,shell32.dll,282,18
Menu,Tray,Icon,帮助信息,shell32.dll,285,18
Menu,Tray,Icon,脚本设置,shell32.dll,288,18
Menu,Tray,Icon,热键设置,shell32.dll,290,18
Menu,Tray,Icon,重启脚本,shell32.dll,287,18
Menu,Tray,Icon,退出脚本,shell32.dll,283,18
}
;菜单项开关
IfExist ,%A_Startup%%A_ScriptName%.lnk ;判断启动文件夹内是否存在本脚本的快捷方式
	Menu,D_Set,ToggleCheck,开机启动 ;当启动中存在本脚本快捷方式时将开机启动设置相反项也就是开启（对号）
RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter ;读取注册表中是否存在回车切换功能的注册表项
if D_Enter{
	Menu,D_Set,ToggleCheck,回车切换
	Hotkey,Enter,Toggle ;启用开启脚本时禁用的回车热键 开启回车切换功能
}
RegRead,D_windows,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitwindows	;与回车切换功能同理
if D_windows{
	Menu,D_Set,ToggleCheck,窗口热键
	Hotkey,!q,Toggle
	Hotkey,!w,Toggle
	Hotkey,!e,Toggle
	Hotkey,!r,Toggle
}
RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss
if D_Boss{
	Menu,D_Hotkey,ToggleCheck,开启/关闭
	gosub,D_cx ;查询数据库
	Loop,9{
		Hotkey,!%A_Index%,Toggle	;开启所有热键
		K_Hotkeys=!%A_Index%
		H_Hotkeys = Hotkeys = '%K_Hotkeys%'
		oRecordset.Find(H_Hotkeys,,,1) ;在数据库中查询是否有此热键名称
		if !oRecordset.EOF{	;查询到热键
			X_pid:=oRecordset.Fields["pid"].Value	;读取热键对应的程序名
			Menu,D_Hotkey,Add,!%A_Index%-%X_pid%,S_Hotkey	;创建热键菜单以便删除
		}
	}
}
RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate
if D_update{
	Menu,D_Set,ToggleCheck,启动更新
	if A_TickCount<20000	;判断是否已开机后20000毫秒 避免开机未联网状态获取更新
		SetTimer,立即检查,90000
	else
		gosub,立即检查
}
TrayTip,,Habit已启动
;启动脚本
Loop{
	IfWinNotActive,ahk_exe %D_Name% ;等待当前窗口消失 这是一个循环在后面会将
	{
		WinGet,D_Name,ProcessName,A ;获取当前窗口进程名
		if not D_Name	;当进程名为空时重新循环
		continue
		gosub,D_cx	;查询数据库
		sSearchCriteria = pid = '%D_Name%'
		oRecordset.Find(sSearchCriteria,,,1)	;在数据库中查询是否存在此窗口进程名的数据
		if oRecordset.EOF{	;如果不存在则创建数据
			oRecordset.AddNew()
			for index, element in Array
			{
				oRecordset.Fields[element]:="1"	;添加数组中数据预设值为1
			}
			WinGet,D_Route,ProcessPath,A	;获取当前窗口路径添加到数据库
			oRecordset.Fields["pid"]:= D_Name	;添加进程名
			oRecordset.Fields["Hotkeys"]:= "0"	;添加热键行 预设0
			oRecordset.Fields["Route"]:= D_Route	;添加进程路径
			oRecordset.Update()	;保存添加
		}else{	;如果存在进程项则为程序配置 数据中最长用的输入法
			D_Big= ;制空变量
			D_Value=
			for index, element in Array	;读取数组中的输入法编号
			{
				A_element:=oRecordset.Fields[element].Value ;在157行已经查询此进程的行 在此可以直接读取 窗口程序名行的输入法编号列的使用次数
				if (A_element>D_Big){	;只储存使用次数最多的输入法编号到变量
					D_Big=%A_element%
					D_Value=%element%
				}
			}
			if D_TX	;判断是否开启调试 开启后这里会显示脚本执行信息
			TrayTip,,%D_Name%`n配置:%D_Value%-%D_Big%
			SwitchIME(D_Value)	;切换输入法为上面取得到的程序使用次数最多的输入法
		}
		X_Name=	;避免在一个窗口中只要打字就添加记录 这样只记录当激活窗口或打第一个字母时使用的输入法
	}
	if A_TimeIdlePhysical<200	;判断距离上一次输入的时候是否为200毫秒内
	if A_PriorKey in q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,	;判断输入的是否为26字母 避免热键也记录
	if (X_Name<>D_Name){	;上面判断如果时新窗口则会制空 X_Name 这样只会在新窗口执行一次if内的代码
		SetFormat,integer,hex
		HKL:=DllCall("GetKeyboardLayout","int",GetThRead(),UInt)
		StringTrimLeft,Layout,HKL,2
		Layout:= HKL=0x8040804 ? "00000804" : Layout
		Layout:= HKL=0x4090409 ? "00000409" : Layout
		SetFormat,IntegerFast,d
		;上面一段是获取当前窗口输入法
		gosub,D_cx	;查询数据库
		D_SS = pid = '%D_Name%'
		oRecordset.Find(D_SS,,,1)
		A_Layout:=oRecordset.Fields[Layout].Value	;搜索刚刚使用输入法在记录中的次数
		J_Layout:=A_Layout+1	;次数+1
		if D_TX	;调试开关信息
		TrayTip,,%D_Name%`n写入:%Layout%-%J_Layout%`n%A_PriorKey%
		oRecordset.Fields[Layout]:= J_Layout	;写入+1的次数到输入法列
		oRecordset.MoveNext()	;移动游标
		X_Name=%D_Name%	;if (X_Name<>D_Name)这样就不会每输入一个字母就记录了
	}
	Sleep, 100	;做一下延迟不要拼命的运行
}
return
;菜单项功能
帮助信息:
Gui,D_about:New	;创建新窗口
Gui,D_about:+AlwaysOnTop -MinimizeBox -MinimizeBox +Owner	;新窗口的一些设置可以在ahk帮助gui中查询
Gui,D_about:Add,Pic,w30 h-1 Icon222 Section,shell32.dll
Gui,D_about:Add,Text,x+10 ys+5 ,版本信息：%D_bb%`n开发语言：AutoHotkey	;上面的预设信息在这里起作用
Gui,D_about:Add,Edit,xs w300 R5 ReadOnly,%D_bx%
Gui,D_about:Add,Link,xs,脚本讨论： <a href="%D_url%">%D_url%</a>
Gui,D_about:Show,AutoSize,帮助信息
return
Menu:
/*
	DetectHiddenWindows,off
	IfWinExist,ahk_id %MyGuiHwnd%
	{
		Gui,Cancel
		return
	}
	Gui,Show,AutoSize
	*/
return
开机启动:
	Menu,D_Set,ToggleCheck,开机启动	;当点击开机启动菜单时将菜单设置反向
	IfExist,%A_Startup%%A_ScriptName%.lnk	;判断是否在启动文件夹内存在本脚本快捷方式
		FileDelete,%A_Startup%%A_ScriptName%.lnk	;存在则删除
	else
		FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%%A_ScriptName%.lnk	;不存在则创建
return
启动更新:
	Menu,D_Set,ToggleCheck,启动更新	;设置反向
	RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate	;读取注册表更新项
	if D_update
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate	;存在则删除
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate,To update	;不存在则创建
return
回车切换:	;同上 附加了一个将热键设置相反
	Menu,D_Set,ToggleCheck,回车切换
	Hotkey,Enter,Toggle
	RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter
	if D_Enter
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter,Switch
return
窗口热键:
	Menu,D_Set,ToggleCheck,窗口热键
	Hotkey,!q,Toggle
	Hotkey,!w,Toggle
	Hotkey,!e,Toggle
	Hotkey,!r,Toggle
	RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitwindows
	if D_Enter
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitwindows
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitwindows,windows
return
调试开关:	;同理
	Menu,D_Set,ToggleCheck,调试开关
	D_TX:=!D_TX
return
开启/关闭:
	Menu,D_Hotkey,ToggleCheck,开启/关闭
	Loop,9
	Hotkey,!%A_Index%,Toggle
	RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss
	if D_Boss
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss,Boss
return
联系作者:
	Run tencent://message/?uin=%D_QQ%
return
清除数据:
	MsgBox,4,清除数据,这是一个不可逆操作`n确定要清除数据吗？	;创建一个询问
	IfMsgBox Yes	;是否选择了YES
	{
		oRecordset.Close()	;断开数据库
		oConnection.Close()	;断开数据库
		FileDelete,%sDatabaseName%	;删除数据库数据
		Reload	;重启脚本
	}
重启脚本:
	oRecordset.Close()
	oConnection.Close()
	Reload
退出脚本:
	ExitApp	;退出脚本
;附属功能
S_Hotkey:	;删除老板键
	gosub,D_cx	;查询数据库
	StringLeft,S_Hotkey,A_ThisMenuItem,2	;将点击菜单的前两个字符提出（热键名）
	H_Hotkeys = Hotkeys = '%S_Hotkey%'
	oRecordset.Find(H_Hotkeys,,,1)	;查询热建名
	oRecordset.Fields["Hotkeys"]:= "0"		;将热键列制空
	oRecordset.MoveNext()
	Menu,D_Hotkey,Delete,%A_ThisMenuItem%	;删除热键菜单
	StringReplace,S_pid,A_ThisMenuItem,%S_Hotkey%-, , All		;删除点击菜单中的热键剩下 进程名
	TrayTip,,%S_pid%的热键`n"%S_Hotkey%"已经删除
return
D_Alt:	;老板键 脚本最上面注册的alt+数字的热键统一指向这里 按下热键后运行此标签
	gosub,D_cx	;查询数据库
	H_Hotkeys = Hotkeys = '%A_ThisHotkey%'
	oRecordset.Find(H_Hotkeys,,,1)	;在数据库中查询刚刚按下热键对应的行
	if oRecordset.EOF{	;数据库中不存在此热键记录
		oRecordset.Find(sSearchCriteria,,,1)	;取主循环中现在应该被查询的进程
		X_Route:=oRecordset.Fields["Route"].Value	;获取进程的路径 如果进程路径时系统程序路径则不创建 不知道怎么的运行不了 系统中自带的程序
		IfInString, X_Route, C:Windows	;如果程序是系统自带功能则不添加 并提示用户
		{
			TrayTip,,禁止为系统目录下程序设置热键`n%X_Route%
			return
		}
		oRecordset.Fields["Hotkeys"]:= A_ThisHotkey	;将热键名写入到行中
		oRecordset.MoveNext()
		Menu,D_Hotkey,Add,%A_ThisHotkey%-%D_Name%,S_Hotkey	;在菜单中为此热键创建菜单
		TrayTip,,已为%D_Name%`n创建老板键"%A_ThisHotkey%"	;提示用户创建成功
	}else{	;数据库中存在此记录 则读取路径与程序名
		X_Route:=oRecordset.Fields["Route"].Value
		X_pid:=oRecordset.Fields["pid"].Value
		IfWinActive ,ahk_exe %X_pid%	;如果程序在前段则隐藏到任务栏
			WinMinimize
		else
			IfWinExist ,ahk_exe %X_pid%	;检查是否存在窗口
				WinActivate
			else
				Run %X_Route%	;不存在窗口则直接运行程序
	}
return
Ente:	;回车切换 回车后判断获取程序最多使用的输入法并切换 与主循环中同意
	Send {Enter}	;首先发送回车 很有必要
	gosub,D_cx	;查询数据库
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
Temporary:	;临时老板键 这里不讲了在www.ahk8.com中有很多一件多用的例子
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
WinMove:	;把当前窗口还原后移到屏幕正中间! 这是10月15日想起来修改的功能 会顺时针调整窗口位置 与居中
	D_Width:=(A_ScreenWidth/2)	;首先取得屏幕高度与宽度二分之一的尺寸 以判断窗口现在的位置
	D_Height:=(A_ScreenHeight/2)
	WinGetPos,X,Y,Width,Height,A	;获取当前窗口的大小与位置
	if not D_window {	;首先执行居中moce移动窗口与调整窗口的尺寸为屏幕的八分之一
		WinMove,A,,A_ScreenWidth/8,A_ScreenHeight/8,(A_ScreenWidth/8)*6,(A_ScreenHeight/8)*6
		D_window=1	;记录已经居中过
		return
	}
	if (X<D_Width) and (Y<D_Height-200)	;左上	一个判断判断窗口坐标是否在某个位置并移动窗口到下一个位置调整大小为 屏幕的四分之一
		WinMove,A,,D_Width,,D_Width,D_Height
	if (X>D_Width-200) and (Y<D_Height-200)	;右上
		WinMove,A,,,D_Height,D_Width,D_Height
	if (X>D_Width-200) and (Y>D_Height-200)	;右下
		WinMove,A,,0,D_Height,D_Width,D_Height
	if (X<D_Width-200) and (Y>D_Height-200){	;左下
		WinMove,A,,,0,D_Width,D_Height
		D_window=	;记录最后一次逆时针已经结束 在此按下窗口热键则首先执行居中
	}
;调用函数 这些函数都是我在www.ahk8.com中收集的 在论坛中搜索输入法数据库会有很多
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
	SetTimer,立即检查,Off	;首先结束定时器
	SplitPath,D_qiniu,,,,,OutDrive	;将更新文件路径拆分获得域名
	update:=W_InternetCheckConnection(OutDrive)	;检查域名是否可以访问
	if not update	;不能访问则获取不到更新信息文件结束
		return
	D_Array := StrSplit(DownloadToString(D_qiniu,"cp936"),"`n")	;用函数下载文件到变量不产生临时文件
	D_Edit := D_Array[1] ;读取第一行版本号
	D_link := D_Array[2] ;读取第二行下载文件连接
	D_Name := D_Array[3] ;新文件名
	D_xing := D_Array[4] ;更新信息
	StringReplace, D_Edit, D_Edit, `r, , All	;去除变量中的“`r”
	StringReplace, D_link, D_link, `r, , All
	StringReplace, D_Name, D_Name, `r, , All
	StringReplace, D_xing, D_xing, `r, , All
	if D_Edit is not number	;获取不到版本号则结束
	{
		TrayTip,,获取更新失败,10, 1
		return
	}
	if (D_Edit > D_bb)	;判断是否为新版本
	{
		MsgBox,4,检测到新版本,是否更新至:%D_Edit%`n%D_xing%	;询问用户是否更新并提示更新信息
		IfMsgBox Yes
			gosub,D_Label
	}
return
D_Label:
	D_kb := InternetFileGetSize(D_link)
	Progress,1,%S_kb%/%D_kb%,正在更新...,AHK更新
	FileDelete,%A_Temp%%D_Name%
	SetTimer,S_Label,500
	URLDownloadToFile,%D_link%,%A_Temp%%D_Name%
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
	FileGetSize,S_kb,%A_Temp%%D_Name%
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
	copy %A_Temp%%D_Name% %A_ScriptDir%
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
	return, DllCall("Wininet.dllInternetCheckConnection", "Ptr", &lpszUrl, "UInt", FLAG_ICC_FORCE_CONNECTION, "UInt", dwReserved, "Int")
}
InternetFileGetSize(URL:=""){  ;获取网络文件大小
	Static LIB="WININET", CL="00000000000000", N=""
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
	if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininetInternetOpen","str",a,"uint",1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
		return 0
	c:=s:=0,o:=""
	if(f:=DllCall("wininetInternetOpenUrl","ptr",h,"str",url,"ptr",0,"uint",0,"uint",0x80003000,"ptr",0,"ptr"))
	{
		while (DllCall("wininetInternetQueryDataAvailable","ptr",f,"uint*",s,"uint",0,"ptr",0) &&s>0)
		{
			VarSetCapacity(b,s,0)
			DllCall("wininetInternetReadFile","ptr",f,"ptr",&b,"uint",s,"uint*",r)
			o.= StrGet(&b,r>>(encoding="utf-16"||encoding="cp1200"),encoding)
		}
		DllCall("wininetInternetCloseHandle","ptr", f)
}
DllCall("wininetInternetCloseHandle","ptr",h)
return o
}