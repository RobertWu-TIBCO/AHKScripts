#Persistent
#SingleInstance force
#UseHook
#InstallKeybdHook
#ErrorStdOut	;�رմ��󱨸�
;Ԥ���ȼ�
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
;Ԥ����Ϣ
D_MY=Habit	;�ű���	����ͼ����ʾ������
D_bb=1542	;�汾��
D_QQ=4845514	;����QQ
D_bx=�°���ܣ�`n�޸ģ��س��л�Ϊ���ּ���С�س�`n������Ĭ�����뷨���ù���`n�����������۹���	;�汾��Ϣ
D_url=http://www.rrsyycm.com/habit.html	;�ű�������ַ
D_qiniu=http://7xnfay.dl1.z0.glb.clouddn.com/update.txt?fakeParam=%A_Now%	��������Ϣ�ļ�
;��ȡ���뷨
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
;�������ݿ�
sDatabaseName = %A_MyDocuments%\Habit.MDB
sTableName := "Habit"
adOpenStatic := 3, adLockOptimistic := 3, adUseClient := 3
AttributeString := FileExist(sDatabaseName)
if not AttributeString {
	TrayTip,,���ڴ������ݿ�
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
;����MENU
;if (A_OSVersion="WIN_7")
;Menu,Tray,Icon,shell32.dll,174,1
Menu,Tray,Click,1
Menu,Tray,Add,%D_MY%,Menu
Menu,Tray,Add
Menu,Tray,Add,��ϵ����
Menu,Tray,Add,������Ϣ
Menu,D_Set,Add,��������
Menu,D_Set,Add,��������
Menu,D_Set,Add,�س��л�
Menu,D_Set,Add,�����ȼ�
Menu,D_Set,Add,���Կ���
Menu,D_Set,Add,�������
Menu,Tray,Add,�ű�����,:D_Set
Menu,D_Hotkey,Add,����/�ر�
Menu,Tray,Add,�ȼ�����,:D_Hotkey
for index, element in Array{
	RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%element%,Layout Text
RegRead,D_Method,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitMethod
Menu,D_Method,Add,%IMEName%,S_Method
if (D_Method=element)
	Menu,D_Method,ToggleCheck,%IMEName%
}
Menu,Tray,Add,Ĭ������,:D_Method
Menu,Tray,Add
Menu,Tray,Add,�����ű�
Menu,Tray,Add,�˳��ű�
Menu,Tray,Default,%D_MY%
Menu,Tray,NoStandard
Menu,Tray,Tip,��ǰ�汾:%D_bb%`n�����ȥ%D_MY%����
if (A_OSVersion="WIN_7"){
	Menu,Tray,Icon,%D_MY%,shell32.dll,157,18
	Menu,Tray,Icon,��ϵ����,shell32.dll,282,18
	Menu,Tray,Icon,������Ϣ,shell32.dll,285,18
	Menu,Tray,Icon,�ű�����,shell32.dll,288,18
	Menu,Tray,Icon,�ȼ�����,shell32.dll,290,18
	Menu,Tray,Icon,Ĭ������,shell32.dll,289,18
	Menu,Tray,Icon,�����ű�,shell32.dll,287,18
	Menu,Tray,Icon,�˳��ű�,shell32.dll,283,18
}
;�˵����
IfExist ,%A_Startup%\%A_ScriptName%.lnk
	Menu,D_Set,ToggleCheck,��������
RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
if D_Enter{
	Menu,D_Set,ToggleCheck,�س��л�
	Hotkey,NumpadEnter,Toggle
}
RegRead,D_windows,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitwindows
if D_windows{
	Menu,D_Set,ToggleCheck,�����ȼ�
	Hotkey,!q,Toggle
	Hotkey,!w,Toggle
	Hotkey,!e,Toggle
	Hotkey,!r,Toggle
}
RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitBoss
if D_Boss{
	Menu,D_Hotkey,ToggleCheck,����/�ر�
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
	Menu,D_Set,ToggleCheck,��������
	if A_TickCount<20000
		SetTimer,�������,90000
	else
		gosub,�������
}
TrayTip,,Habit������
;�����ű�
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
				TrayTip,,%D_Name%`n����:%D_Value%-%D_Big%
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
					TrayTip,,%D_Name%`nд��:%Layout%-%J_Layout%`n%A_PriorKey%	;--------
				oRecordset.Fields[Layout]:= J_Layout
				oRecordset.MoveNext()
				X_Name=%D_Name%
			}
	Sleep, 100
}
return
;�˵����
������Ϣ:
	Gui,D_about:New
	Gui,D_about:+AlwaysOnTop -MinimizeBox -MinimizeBox +Owner
	Gui,D_about:Add,Pic,w30 h-1 Icon222 Section,shell32.dll
	Gui,D_about:Add,Text,x+10 ys+5 ,�汾��Ϣ��%D_bb%`n�������ԣ�AutoHotkey_L 11.22.06
	Gui,Font,s12,Arial
	Gui,D_about:Add,Edit,xs w300 R5 ReadOnly,%D_bx%
	Gui,Font
	Gui,D_about:Add,Link,xs,�ű����ۣ� <a href="%D_url%">�������߲����˽����</a>
	Gui,D_about:Show,AutoSize,������Ϣ
return
Menu:
	Run http://www.rrsyycm.com/habit.html
return
��������:
	Menu,D_Set,ToggleCheck,��������
	IfExist,%A_Startup%\%A_ScriptName%.lnk
		FileDelete,%A_Startup%\%A_ScriptName%.lnk
	else
		FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%\%A_ScriptName%.lnk
return
��������:
	Menu,D_Set,ToggleCheck,��������
	RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate
	if D_update
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate,To update
return
�س��л�:
	Menu,D_Set,ToggleCheck,�س��л�
	Hotkey,NumpadEnter,Toggle
	RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
	if D_Enter
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter,Switch
return
�����ȼ�:
	Menu,D_Set,ToggleCheck,�����ȼ�
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
���Կ���:
	Menu,D_Set,ToggleCheck,���Կ���
	D_TX:=!D_TX
return
����/�ر�:
	Menu,D_Hotkey,ToggleCheck,����/�ر�
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
��ϵ����:
	Run tencent://message/?uin=%D_QQ%
return
�������:
	MsgBox,4,�������,����һ�����������`nȷ��Ҫ���������
	IfMsgBox Yes
	{
		oRecordset.Close()
		oConnection.Close()
		FileDelete,%sDatabaseName%
		Reload
	}
�����ű�:
	oRecordset.Close()
	oConnection.Close()
	Reload
�˳��ű�:
	ExitApp
	;��������
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
S_Hotkey:	;ɾ���ϰ��
	gosub,D_cx
	StringLeft,S_Hotkey,A_ThisMenuItem,2
	H_Hotkeys = Hotkeys = '%S_Hotkey%'
	oRecordset.Find(H_Hotkeys,,,1)
	oRecordset.Fields["Hotkeys"]:= "0"
	oRecordset.MoveNext()
	Menu,D_Hotkey,Delete,%A_ThisMenuItem%
	StringReplace,S_pid,A_ThisMenuItem,%S_Hotkey%-, , All
	TrayTip,,%S_pid%���ȼ�`n"%S_Hotkey%"�Ѿ�ɾ��
return
D_Alt:	;�ϰ��
	gosub,D_cx
	H_Hotkeys = Hotkeys = '%A_ThisHotkey%'
	oRecordset.Find(H_Hotkeys,,,1)
	if oRecordset.EOF{
		oRecordset.Find(sSearchCriteria,,,1)
		X_Route:=oRecordset.Fields["Route"].Value
		IfInString, X_Route, C:\Windows
		{
			TrayTip,,��ֹΪϵͳĿ¼�³��������ȼ�`n%X_Route%
			return
		}
		oRecordset.Fields["Hotkeys"]:= A_ThisHotkey
		oRecordset.MoveNext()
		Menu,D_Hotkey,Add,%A_ThisHotkey%-%D_Name%,S_Hotkey
		TrayTip,,��Ϊ%D_Name%`n�����ϰ��"%A_ThisHotkey%"
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
Ente:	;�س��л�
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
	;TrayTip,,%D_Name%`n����:%D_Value%-%D_Big%
	SwitchIME(D_Value)
return
;���ڲ���
WinMinimize: 	 ;������С��
	WinMinimize A
return
WinMaximize:	;�������
	WinMaximize A
return
Temporary:	;��ʱ�ϰ��
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
WinMove:	;�ѵ�ǰ���ڻ�ԭ���Ƶ���Ļ���м�!
	D_Width:=(A_ScreenWidth/2)
	D_Height:=(A_ScreenHeight/2)
	WinGetPos,X,Y,Width,Height,A
	if not D_window {
		WinMove,A,,A_ScreenWidth/8,A_ScreenHeight/8,(A_ScreenWidth/8)*6,(A_ScreenHeight/8)*6
		D_window=1
		return
	}
	if (X<D_Width) and (Y<D_Height-200)	;����
		WinMove,A,,D_Width,,D_Width,D_Height
	if (X>D_Width-200) and (Y<D_Height-200)	;����
		WinMove,A,,,D_Height,D_Width,D_Height
	if (X>D_Width-200) and (Y>D_Height-200)	;����
		WinMove,A,,0,D_Height,D_Width,D_Height
	if (X<D_Width-200) and (Y>D_Height-200){	;����
		WinMove,A,,,0,D_Width,D_Height
		D_window=
	}
;���ú���
GetThread(){	;��ȡ��ǰ�������뷨
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
SwitchIME(dwLayout){	;�޸ĵ�ǰ�������뷨
	HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A
}
D_CX:	;��ѯ���ݿ�
	oRecordset := ComObjCreate("ADODB.Recordset")
	oRecordset.CursorLocation := adUseClient
	oRecordset.Open("SELECT * FROM Habit ORDER BY pid DESC, Hotkeys DESC", oConnection, adOpenStatic, adLockOptimistic)
return
;���¹���
�������:
	SetTimer,�������,Off
	SplitPath,D_qiniu,,,,,OutDrive
	update:=W_InternetCheckConnection(OutDrive)
	if not update
		return
	D_Array := StrSplit(DownloadToString(D_qiniu,"cp936"),"`n")
	D_Edit := D_Array[1] ;��ȡ��һ�а汾��
	D_link := D_Array[2] ;��ȡ�ڶ��������ļ�����
	D_Name := D_Array[3] ;���ļ���
	D_xing := D_Array[4] ;������Ϣ
	StringReplace, D_Edit, D_Edit, `r, , All
	StringReplace, D_link, D_link, `r, , All
	StringReplace, D_Name, D_Name, `r, , All
	StringReplace, D_xing, D_xing, `r, , All
	if D_Edit is not number
	{
		TrayTip,,��ȡ����ʧ��,10, 1
		return
	}
	if (D_Edit > D_bb)
	{
		MsgBox,4,��⵽�°汾,�Ƿ������:%D_Edit%`n%D_xing%
		IfMsgBox Yes
			gosub,D_Label
	}
return
D_Label:
	D_kb := InternetFileGetSize(D_link)
	Progress,1,%S_kb%/%D_kb%,���ڸ���...,AHK����
	FileDelete,%A_Temp%\%D_Name%
	SetTimer,S_Label,500
	URLDownloadToFile,%D_link%,%A_Temp%\%D_Name%
	SetTimer,S_Label,Off
	if ErrorLevel{
		TrayTip,,�����ļ����س���,10, 1
		return
	}
	else{
		Progress,100
		gosub,ExitSub
	}
return
S_Label: ;��ȡ������ʱ�ļ��Ĵ�С���½���
	FileGetSize,S_kb,%A_Temp%\%D_Name%
	D_xz := S_kb/D_kb
	D_xz := D_xz*100
	StringLeft,D_xz,D_xz,2
	Progress,%D_xz%,%S_kb%/%D_kb%,���ڸ���...,AHK����
return
ExitSub:
	if (A_IsCompiled) ;��ɱ���򿪸��º�ĳ���
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
W_InternetCheckConnection(lpszUrl){ ;���FTP�����Ƿ������
	FLAG_ICC_FORCE_CONNECTION := 0x1
	dwReserved := 0x0
	return, DllCall("Wininet.dll\InternetCheckConnection", "Ptr", &lpszUrl, "UInt", FLAG_ICC_FORCE_CONNECTION, "UInt", dwReserved, "Int")
}
InternetFileGetSize(URL:=""){  ;��ȡ�����ļ���С
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
DownloadToString(URL, encoding="utf-8")	;�����ļ�������
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