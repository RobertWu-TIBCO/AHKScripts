;���ߣ�С����
;�ű���Habit-1625
;���ͣ�http://rrsyycm.com
;���ԣ�AutoHotkey1.1.22
;���ڣ�
;���Ե�Ŀ�ģ�׼ȷ�ı���
/*���л�ʵ��
 * Key/;:000[(ime_set:00000804-0)(Send_set:{;})(ime_set:00000804-1)(end_set:Enter-00000804-0)]
 * ����Key/;:000Ϊ�������뷨ʱ����;��ִ�к�[]�е����Ҳ����ָ�����뷨Key/;:00000804-1,��00000804-1���뷨ʱ����;��ִ��[]�����
 * һ��������()��������Ϊ��������
 * ime_setΪ�������뷨���ܹ�����������һ��00000804Ϊ���뷨��ţ�-���0Ϊ00000804���뷨��ime״̬��0ΪӢ��1Ϊ���ġ�
 * Send_setΪ���ͼ���һ��������Ҫ���͵��ȼ���{}��������ָ���ཨ��{H}{a}{b}{i}{t}{Enter}��
 * end_setΪ�ȴ��ȼ����º�ִ���л����뷨�������ĸ�������һ����Ϊ�����ȼ����ڶ�����Ϊ�����л����뷨�Ĳ��������ĸ�Ϊ�ȴ��������µ�ʱ��Ϊ0ʱ���޵ȴ���
 * ��������Ϊ���������뷨ʱ����;���л����뷨Ϊ��׼Ӣ��״̬���;�ַ����л����뷨Ϊ��׼���ģ��ȴ����»س����л����뷨Ϊ��׼Ӣ�ġ�
 * Hait���ṩ�Զ�������������ú���Ϊime_set Send_set end_set,������ú�����ο��ű�Ŀ¼��Habit-lib�ļ�����my.ahk
 * SQL="Key/;:000[(ime_set:00000804-0)(Send_set:{;})(ime_set:=00000804-1)(end_set:Enter-3-00000804-0)]"
 * D_CX("update habit set hot='" SQL "' where pid='gvim'",0)
*/ 
#Persistent
#SingleInstance force
#UseHook
#InstallKeybdHook
#Include %A_ScriptDir%\Habit-lib\
Menu, Tray, Icon, F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\eng.ico
D_TS:=	;���Կ���
global D_TS
;//Ԥ����Ϣ
D_KK:=1625	;��ǰ�汾
D_URL=http://ahk.rrsyycm.com/index.html?fakeParam=%A_Now%	;��ȡ��Ϣ��ַ
RegRead,D_edition,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter
RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,HabitEnter,%D_KK%
if D_edition
	if (D_edition<D_KK)
		MsgBox,�Ѵ�%D_edition%������%D_KK%
;//��ȡ���뷨																
Array := Object()
HKLnum:=DllCall("GetKeyboardLayoutList","uint",0,"uint",0)
VarSetCapacity( HKLlist,HKLnum*4,0)
DllCall("GetKeyboardLayoutList","uint",HKLnum,"uint",&HKLlist)
loop,%HKLnum%
{
	SetFormat,integer,hex
	HKL:=NumGet(HKLlist,(A_Index-1)*4)
	StringTrimLeft,Layout,HKL,2
	Layout:= Layout=8040804 ? "00000804" : Layout
	Layout:= Layout=4090409 ? "00000409" : Layout
	SetFormat,IntegerFast,d
	IME_ADD(Layout)
	Layout=%Layout%
	RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%Layout%,Layout Text
	D_BOX=%D_BOX%|%IMEName%
	Array.Insert(Layout)
}
StringTrimLeft,D_BOX,D_BOX,1
;//����MENU																	
;Menu,Tray,Click,1
Menu,Tray,Add,ShowHabit
Menu,Tray,Add,Habit,Menu
Menu,Tray,Add
Menu,Tray,Add,��ϵ����
Menu,Tray,Add,������Ϣ
Menu,D_Set,Add,��������
Menu,D_Set,Add,��������
Menu,D_Set,Add,���Կ���
Menu,D_Set,Add,�������
Menu,Tray,Add,�ű�����,:D_Set
Menu,Tray,Add
Menu,Tray,Add,Edit,edit
Menu,Tray,Add,�����ű�
Menu,Tray,Add,�˳��ű�
;Menu,Tray,Default,Habit
Menu,Tray,Default,ShowHabit
Menu,Tray,NoStandard
Gui +HwndMyGuiHwnd
Gui,Add,ListView,r14 w465 vMyListView gMyListView Grid -Multi,������|Ĭ�����뷨|���л�|�ϰ��
D_CX("SELECT * FROM habit","list")
Gui,Add,DropDownList ,Section AltSubmit Choose1 vG_COMBOX W200,%D_BOX%
Gui,Add,Edit,ys w50 vG_IME,0
Gui,Add,Hotkey,ys w120 vG_HOTKEY
Gui,Add,Button,ys,ȷ���޸�
Gui,Add,Edit,xs w465 vG_HOT,Key/;:000[(ime_set:00000804-0)(Send_set:{;})(ime_set:00000804-1)(end_set:Enter-00000804-0)]
Gui,Add,StatusBar,,
SB_SetText("ALT+F1��ȡ��ǰ���뷨״̬")
Gui,Show,AutoSize,Habit-1625
Gui,Hide
RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate
if D_update{
	Menu,D_Set,ToggleCheck,��������
	gosub,D_inspec
}
IfExist ,%A_Startup%\%A_ScriptName%.lnk
	Menu,D_Set,ToggleCheck,��������
;//��ʼ������                                                            
loop{
	;IfWinNotActive,ahk_exe %D_PID%.exe
	;IfWinNotActive,ahk_id %D_ID%
	WinWaitNotActive,ahk_id %D_ID%
	{
		;WinGet,D_PID,ProcessName,A
		WinGet,D_ID,ID,A
		WinGet,D_PID,ProcessName,A
		StringReplace,D_PID,D_PID,.exe,,All
		if not D_PID
			continue
		if D_CX("SELECT COUNT(*) FROM habit WHERE pid='" D_PID "'","result"){	;���ݿ��д��ڱ���
			D_MR:=D_CX("SELECT method FROM habit WHERE pid='" D_PID "'","result")
			if D_MR{
				StringSplit,var,D_MR,-
				ime_set(var1,var2)
			}else{
				D_LSDB:=
				for hot,method in Array
				{
					IME_ADD(method)
					if D_CX("SELECT h" method " FROM Habit WHERE pid='" D_PID "'","result")>D_LSDB{
						D_LSDB:=D_CX("SELECT h" method " FROM Habit WHERE pid='" D_PID "'","result")
						D_ZN:=method
					}
				}
				ime_set(D_ZN,"0")
			}
		}else{	;ע���в����ڴ˳�����ӱ�����
			WinGet,D_Route,ProcessPath,A
			TrayTip,����
			D_CX("Insert INTO habit (pid,method,hot,hotkey,Route) VALUES ('" D_PID "','0','0','0','" D_Route "')",0)
			for hot,method in Array	;Ϊ�����������뷨������ʼֵ
				D_CX("update habit set h" method "='1' where pid='" D_PID "'",0)
			D_CX("SELECT * FROM habit","list")
		}
		X_Name=
	}
	if A_TimeIdlePhysical<200
		if A_PriorKey in q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,
			if (X_Name<>D_PID){
				IME_ADD(GetThRead())
				D_CX("update habit set h" GetThRead() "=h" GetThRead() "+1 where pid='" D_PID "'",0)
				X_Name=%D_PID%
			}
}
return
;//��ǩ				
MyListView:
if (A_GuiEvent="DoubleClick"){
	LV_GetText(G_PID,LV_GetNext())
	GuiControl,,G_HOT,% D_CX("SELECT hot FROM Habit where pid='" G_PID "'","result")
	GuiControl,,G_HOTKEY,% D_CX("SELECT hotkey FROM Habit where pid='" G_PID "'","result")
}
return
Buttonȷ���޸�:
Gui,Submit,NoHide
LV_GetText(G_PID,LV_GetNext())
D_CX("update habit set method='" Array[G_COMBOX] "-" G_IME "' where pid='" G_PID "'",0)
if G_HOT
	D_CX("update habit set hot='" G_HOT "' where pid='" G_PID "'",0)
if G_HOTKEY
	D_CX("update habit set hotkey='" G_HOTKEY "' where pid='" G_PID "'",0)
D_CX("SELECT * FROM habit","list")
return
;//�ȼ�                                               
!^F1::
SB_LAYOU:=GetThread()
RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%SB_LAYOU%,Layout Text
SB_SetText("���뷨���ƣ�" IMEName " ���뷨��ţ�" GetThread() " IME״̬��" IME_Get())
return
D_HOTKEY:	;//���л�
RegExMatch(D_CX("SELECT hot FROM habit WHERE pid='" D_PID "'","result"),"(?<=/" A_ThisHotkey ":" GetThread() "-" IME_Get() ").*?\]",D_HOT)
if not D_HOT
	RegExMatch(D_CX("SELECT hot FROM habit WHERE pid='" D_PID "'","result"),"(?<=/" A_ThisHotkey ":000).*?\]",D_HOT)
if D_HOT
{
	D_COM:=RegExMatchAll(D_HOT,"\((.*?)\)",1)
	for k,v in D_COM
	{
		StringSplit,D_GOTO,v,:
		StringSplit,var,D_GOTO2,-
		D_ERR:=%D_GOTO1%(var1,var2,var3,var4)
		if D_ERR
			break
	}
}else{
	Send {%A_ThisHotkey%}
}
return
D_LBJ:	;//�ϰ��
X_PID:=D_CX("SELECT pid FROM habit WHERE hotkey='" A_ThisHotkey "'","result")
X_LUJ:=D_CX("SELECT Route FROM habit WHERE hotkey='" A_ThisHotkey "'","result")
X_PID=%X_PID%.exe
IfWinActive ,ahk_exe %X_PID%
	WinMinimize
else
	IfWinExist ,ahk_exe %X_PID%
		WinActivate
	else
		Run %X_LUJ%
return
D_inspec:
	D_GET:=D_GX(D_URL)
	result :=RegExMatchAll(D_GET,"<h3>(.*?)</h3>",1)	;���°汾
	D_BB:=result[1]
	if (D_KK<D_BB){
		result :=RegExMatchAll(D_GET,""" href=(.*?)target=""_blank"">",1)	;���ص�ַ
		D_DW:=result[1]
		StringReplace,D_DW,D_DW,",,All
		result :=RegExMatchAll(D_GET,"<ul>\n(.*?)\n</ul>",1)	;��������
		D_UL:=result[1]
		D_XX := RegExReplace(D_UL, "<li>(.*?)</li>", "$1")
		MsgBox,4,�汾����,���°汾��%D_BB%`n----------------------------------------`n%D_XX%
		IfMsgBox Yes
			gosub,D_DOW
	}else{
	;MsgBox,��ǰ�������°汾
	}
return
D_DOW:
	Gui,Add,Text,xm ym w233 vLabel1,���ڳ�ʼ��...
	Gui,Add,Text,xm y24 w140 vLabel2,
	Gui,Add,Text, x150 y24 w80 vLabel3,
	Gui,Add,Button, x260 y10 w50 h25 gCancel, ȡ��
	Gui,Add,Progress, x10 y45 w300 h20 vMyProgress -Smooth
	Gui, +ToolWindow +AlwaysOnTop
	SysGet, m, MonitorWorkArea,1
	x:=mRight-330
	y:=mBottom-110
	Gui,Show,w320 x%x% y%y% , �ļ�����
	Gui +LastFound
	URL=%D_DW%
	SplitPath, URL, FN,,,, DN
	FN:=(FN ? FN : DN)
	SAVE=%A_ScriptDir%\%FN%
	DllCall("QueryPerformanceCounter", "Int64*", T1)
	WP1=0
	T2=0
	WP2=0
	if ((E:=InternetFileRead( binData, URL, False, 1024)) > 0 && !ErrorLevel)
	{
		VarZ_Save(binData, SAVE)
		GuiControl, Text, Label1, ������ɡ�
		Sleep, 500
		D_history=%A_ScriptDir%\history\%D_BB%
		FileCreateDir,%D_history%
		SmartZip(SAVE,D_history)
		FileDelete,%SAVE%
		gosub,ExitSub
		ExitApp
	}else{
		ERR := (E<0) ? "����ʧ�ܣ��������Ϊ" . E : "���ع����г���δ��������ء�"
		GuiControl, Text, Label1, %ERR%
		Sleep, 500
		return
	}

	DllCall( "FreeLibrary", UInt,DllCall( "GetModuleHandle", Str,"wininet.dll") )
return

ExitSub:
bat=
		(LTrim
:start
	ping 127.0.0.1 -n 2>nul
	del `%1
	if exist `%1 goto start
	xcopy %D_history% %A_ScriptDir% /e
	start %A_ScriptFullPath%
	del `%0
	)
	batfilename=Delete.bat
	IfExist %batfilename%
		FileDelete %batfilename%
	FileAppend, %bat%, %batfilename%
	Run,%batfilename% "%A_ScriptFullPath%", , Hide
	ExitApp
return
;//MENU																					
Menu:
IfWinActive,ahk_id%MyGuiHwnd%
	WinMinimize,ahk_id %MyGuiHwnd%
else
	WinActivate,ahk_id %MyGuiHwnd%
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
	D_update:=!D_update
	RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\TestKey,Habitupdate,%D_update%
return
���Կ���:
	Menu,D_Set,ToggleCheck,���Կ���
	D_TS:=!D_TS
return
�������:
	D_CX("DELETE FROM Habit",0)
	D_CX("DELETE FROM ime",0)
	Reload
return
�����ű�:
	Reload
�˳��ű�:
	ExitApp
��ϵ����:
	Run tencent://message/?uin=4845514
return
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
;//���л����õĺ���																
ime_set(var1,var2){
	SwitchIME(var1)
	IME_SetConvMode(var2)
	return
}
Send_set(var1,var2){
	Send %var1%
	return
}
end_set(var1,var2,var3,var4){
	if not var4
		KeyWait,%var1%,D
	else
		KeyWait,%var1%,D T%var4%
	SwitchIME(var2)
	IME_SetConvMode(var3)
	return ErrorLevel
}
;//���ݿ��ѯ����																	
D_CX(SQL,MS){
	Recordset := ComObjCreate("ADODB.Recordset")
	if D_TS
	TrayTip,,%SQL%
	Recordset.Open(SQL,"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" . A_ScriptDir . "\habit.mdb")
	if (MS="result")
		return Recordset.Fields[0].Value
	if (MS="list"){	;�ؽ��б�
		GuiControl,-Redraw,MyListView
		LV_Delete()
		WinAll:= Object()
		ImageListID := IL_Create(WinAll)
		LV_SetImageList(ImageListID)
		while !Recordset.EOF
		{
			K_PID:=Recordset.Fields[0].Value
			K_MR:=Recordset.Fields[1].Value
			K_LB:=Recordset.Fields[3].Value
			K_LJ:=Recordset.Fields[4].Value
			if FileExist(K_LJ) and GetIconCount(K_LJ){
				K_ICON:=IL_Add(ImageListID,K_LJ,1)
				D_HOTKEY:=RegExMatchAll(Recordset.Fields[2].Value,"(?<=Key/)(.*?)(?=:)",1)
				L_HOT:=
				for k,v in D_HOTKEY{
					Hotkey,IfWinActive,ahk_exe %K_PID%.exe
					Hotkey,%v%,D_HOTKEY
					Hotkey,%v%,Off
					Hotkey,%v%,On
					L_HOT=%L_HOT%/%V%
				}
				StringSplit,K_MR,K_MR,-
				RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%K_MR1%,Layout Text
				if IMEName
					IMEName=%IMEName%|%K_MR2%
				Hotkey,IfWinActive
				if K_LB<>0
					Hotkey,%K_LB%,D_LBJ
				else
					K_LB:=
				LV_Add("Icon" . K_ICON,Recordset.Fields[0].Value,IMEName,L_HOT,K_LB)
			}else{	;ɾ�������ڵĳ���
				D_CX("DELETE FROM Habit WHERE pid='" K_PID "'",0)
			}
			Recordset.MoveNext()
		}
		GuiControl,+Redraw,MyListView
		LV_ModifyCol()
	}
}
Return
;//Ϊ�³��ֵ����뷨�������ݿ���
IME_ADD(Layout){
	if not D_CX("SELECT COUNT(*) FROM ime WHERE ime='" Layout "'","result"){
		D_CX("INSERT INTO ime VALUES ('" Layout "')",0)
		D_CX("ALTER TABLE habit ADD h" Layout " VARCHAR(50)",0)
	}
}
return
;//���õ�ǰ���뷨
SwitchIME(dwLayout){
	HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A
}
return
;//���õ�ǰ���뷨IME״̬
IME_SetConvMode(ConvMode){
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
		NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
		hwnd :=  NumGet(stGTI,8+PtrSize,"UInt")
		DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283      ;Message : WM_IME_CONTROL
          ,  Int, 0x002       ;wParam  : IMC_SETCONVERSIONMODE
          ,  Int, ConvMode)   ;lParam  : CONVERSIONMODE
}
return
;//��ȡ��ǰ���뷨IME״̬
IME_Get() {
 	PtrSize := !A_PtrSize ? 4 : A_PtrSize
	VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
	NumPut(CbSize, StGTI,  0, "UInt")
	DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
	HWND := NumGet(StGTI, 8+PtrSize, "UInt")
	Return DllCall("SendMessage"
		, "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", HWND)
		, "UInt", 0x0283
		,  "Int", 0x0005
		,  "Int", 0)
}
return
;//������ʽ
RegExMatchAll(ByRef Haystack, NeedleRegEx, SubPat="") {		
	arr := [], startPos := 1
	while ( pos := RegExMatch(Haystack, NeedleRegEx, match, startPos) ) {
	arr.push(match%SubPat%)
	startPos := pos + StrLen(match)
}
return arr.MaxIndex() ? arr : ""
}
return
;//��ȡ��ǰ�������뷨
GetThread(){
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
			SetFormat,integer,hex
			HKL:=DllCall("GetKeyboardLayout","int",ResultID,UInt)
			StringTrimLeft,Layout,HKL,2
			Layout:= HKL=0x8040804 ? "00000804" : Layout
			Layout:= HKL=0x4090409 ? "00000409" : Layout
			SetFormat,IntegerFast,d
			IME_ADD(Layout)
			Layout=%Layout%
			Return Layout
		}
		NumPut( 28, thE )
		if( DllCall("Thread32Next","uint",hProcessSnap, "uint",&thE )=0){
			DllCall("CloseHandle","uint",hProcessSnap)
			Return 0
		}
	}
}
return
SmartZip(s, o, t = 16)	;���ý�ѹ����
{
	IfNotExist, %s%
		return, -1
	oShell := ComObjCreate("Shell.Application")
	if InStr(FileExist(o), "D") or (!FileExist(o) and (SubStr(s, -3) = ".zip"))
	{
		if !o
			o := A_ScriptDir
		else ifNotExist, %o%
			FileCreateDir, %o%
		Loop, %o%, 1
			sObjectLongName := A_LoopFileLongPath
		oObject := oShell.NameSpace(sObjectLongName)
		Loop, %s%, 1
		{
			oSource := oShell.NameSpace(A_LoopFileLongPath)
			oObject.CopyHere(oSource.Items, t)
		}
	}
}
D_GX(K_URL){	;�첽��ȡHTML
	req := ComObjCreate("Msxml2.XMLHTTP")
	req.open("GET",K_URL,false)
	req.Send()
	return req.responseText
}
InternetFileRead( ByRef V, URL="", RB=0, bSz=1024, DLP="DLP", F=0x84000000 )
{
	SetBatchLines, -1
	Static LIB="WININET\", QRL=16, CL="00000000000000", N=""
	If ! DllCall( "GetModuleHandle", Str,"wininet.dll" )
		DllCall( "LoadLibrary", Str,"wininet.dll" )
	If ! hIO:=DllCall( LIB "InternetOpen", Str,N, UInt,4, Str,N, Str,N, UInt,0 )
		Return -1
	If ! ( ( hIU:=DllCall( LIB "InternetOpenUrl", UInt,hIO, Str,URL, Str,N, Int,0, UInt,F , UInt,0 ) ) || ErrorLevel )
		Return 0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 2
	If ! ( RB )
	If ( SubStr(URL,1,4) = "ftp:" )
		CL := DllCall( LIB "FtpGetFileSize", UInt,hIU, UIntP,0 )
	Else If ! DllCall( LIB "HttpQueryInfo", UInt,hIU, Int,5, Str,CL, UIntP,QRL, UInt,0 )
		Return 0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIU ) ) - ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 4
	VarSetCapacity( V,64 ), VarSetCapacity( V,0 )
	SplitPath, URL, FN,,,, DN
	FN:=(FN ? FN : DN), CL:=(RB ? RB : CL), VarSetCapacity( V,CL,32 ), P:=&V,
	B:=(bSz>CL ? CL : bSz), TtlB:=0, LP := RB ? "Unknown" : CL, %DLP%( True,CL,FN )
	Loop
	{
		If ( DllCall( LIB "InternetReadFile", UInt,hIU, UInt,P, UInt,B, UIntP,R ) && !R )
			Break
		P:=(P+R), TtlB:=(TtlB+R), RemB:=(CL-TtlB), B:=(RemB<B ? RemB : B), %DLP%( TtlB,LP )
		Sleep -1
	}
	TtlB<>CL ? VarSetCapacity( T,TtlB ) DllCall( "RtlMoveMemory", Str,T, Str,V, UInt,TtlB ) . VarSetCapacity( V,0 ) . VarSetCapacity( V,TtlB,32 ) . DllCall( "RtlMoveMemory", Str,V , Str,T, UInt,TtlB ) . %DLP%( TtlB, TtlB ) : N
	If ( !DllCall( LIB "InternetCloseHandle", UInt,hIU ) ) + ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) )
		Return -6
	Return, VarSetCapacity(V)+((ErrorLevel:=(RB>0 && TtlB<RB)||(RB=0 && TtlB=CL) ? 0 : 1)<<64)
}

DLP(WP=0, LP=0, MSG="")
{
	global INI,FN,T1,T2,WP1,WP2,SP
	GuiControl, Text, Label1, �������أ�%FN%
	GuiControl,, MyProgress, % Round(WP/LP*100)
	DllCall("QueryPerformanceCounter", "Int64*", T2)
	DllCall("QueryPerformanceFrequency", "Int64*", TI)
	WP2:=WP
	if ((T:=(T2-T1)/TI) >=1)
	{
		SP:=Round(((WP2-WP1)/1024)/T,2)
		T1:=T2
		WP1:=WP2
	}
	WP:= ((WP:= Round(WP/1024)) < 1024) ? WP . " KB" : Round(WP/1024, 2) . " MB"
	LP:= ((LP:= Round(LP/1024)) < 1024) ? LP . " KB" : Round(LP/1024, 2) . " MB"
	GuiControl, Text, Label2, %WP% / %LP%
	GuiControl, Text, Label3, %SP% KB/S
}

VarZ_Save( byRef V, File="" ) { ; www.autohotkey.net/~Skan/wrapper/FileIO16/FileIO16.ahk
Return ( ( hFile := DllCall( "_lcreat", AStr,File, UInt,0 ) ) > 0 )
 ? DllCall( "_lwrite", UInt,hFile, Str,V, UInt,VarSetCapacity(V) )
 + ( DllCall( "_lclose", UInt,hFile ) << 64 ) : 0
}
;//�ų�û��ͼ��ĳ���
GetIconCount(file){
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

GuiClose:
ExitApp

edit:
run,"F:\Program Files\Notepad++\notepad++.exe" %A_ScriptDir%\Habit-1621-LiuMeng.ahk
return

::rha::
::r3::
reload
return

::hepha::
gosub ������Ϣ
return

::hidha::
::hid3::
Gui,hide
return

::shha::
::sh3::
ShowHabit:
Gui,show
return
