#Persistent
#SingleInstance force
#UseHook
#InstallKeybdHook
#ErrorStdOut	;�رմ��󱨸�
;
/*Ԥ���ȼ�
Ԥ��ע���ȼ� �ں������û�ѡ������ر�
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
/*Ԥ����Ϣ
Ԥ�豾�ű��� ���� �汾 ����QQ �������� �� �����ȡ������Ϣ���ļ�����·��
*/
D_MY=Habit	;�ű���	����ͼ����ʾ������
D_bb=1542	;�汾��
D_QQ=4845514	;����QQ
D_bx=1542��ȥ���˽���`nʹ�����ݿ�ͳ������ϰ��`n����ű�������Ϣ������·���ַ	;�汾��Ϣ
D_url=http://www.rrsyycm.com/habit.html	;�ű�������ַ
D_qiniu=http://7xnfay.dl1.z0.glb.clouddn.com/update.txt?fakeParam=%A_Now%	��������Ϣ�ļ�
/*��ȡ���뷨
Ԥ����Ϣ���ؼ�����Ϻ���Ҫ����Ҫ�Ļ�ȡ����ǰ����װ�����뷨Ϊ�������ݿ���ͳ����Ϣ
���������е����뷨��Ŵ��������� Ϊ����Գ����������뷨ʹ��
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
;�������ݿ�
sDatabaseName = %A_MyDocuments%Habit.MDB ;�������ݿ�λ��
sTableName := "Habit"
adOpenStatic := 3, adLockOptimistic := 3, adUseClient := 3
AttributeString := FileExist(sDatabaseName)
if not AttributeString { ;�ж����ݿ��Ƿ����
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
Menu,Tray,Add
Menu,Tray,Add,�����ű�
Menu,Tray,Add,�˳��ű�
Menu,Tray,Default,%D_MY%
Menu,Tray,NoStandard
Menu,Tray,Tip,%D_MY%`n��ǰ�汾:%D_bb%
if (A_OSVersion="WIN_7"){ ;�ж�ϵͳ�Ƿ�ΪWIN7�Բ˵����ͼ��
Menu,Tray,Icon,%D_MY%,shell32.dll,157,18
Menu,Tray,Icon,��ϵ����,shell32.dll,282,18
Menu,Tray,Icon,������Ϣ,shell32.dll,285,18
Menu,Tray,Icon,�ű�����,shell32.dll,288,18
Menu,Tray,Icon,�ȼ�����,shell32.dll,290,18
Menu,Tray,Icon,�����ű�,shell32.dll,287,18
Menu,Tray,Icon,�˳��ű�,shell32.dll,283,18
}
;�˵����
IfExist ,%A_Startup%%A_ScriptName%.lnk ;�ж������ļ������Ƿ���ڱ��ű��Ŀ�ݷ�ʽ
	Menu,D_Set,ToggleCheck,�������� ;�������д��ڱ��ű���ݷ�ʽʱ���������������෴��Ҳ���ǿ������Ժţ�
RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter ;��ȡע������Ƿ���ڻس��л����ܵ�ע�����
if D_Enter{
	Menu,D_Set,ToggleCheck,�س��л�
	Hotkey,Enter,Toggle ;���ÿ����ű�ʱ���õĻس��ȼ� �����س��л�����
}
RegRead,D_windows,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitwindows	;��س��л�����ͬ��
if D_windows{
	Menu,D_Set,ToggleCheck,�����ȼ�
	Hotkey,!q,Toggle
	Hotkey,!w,Toggle
	Hotkey,!e,Toggle
	Hotkey,!r,Toggle
}
RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss
if D_Boss{
	Menu,D_Hotkey,ToggleCheck,����/�ر�
	gosub,D_cx ;��ѯ���ݿ�
	Loop,9{
		Hotkey,!%A_Index%,Toggle	;���������ȼ�
		K_Hotkeys=!%A_Index%
		H_Hotkeys = Hotkeys = '%K_Hotkeys%'
		oRecordset.Find(H_Hotkeys,,,1) ;�����ݿ��в�ѯ�Ƿ��д��ȼ�����
		if !oRecordset.EOF{	;��ѯ���ȼ�
			X_pid:=oRecordset.Fields["pid"].Value	;��ȡ�ȼ���Ӧ�ĳ�����
			Menu,D_Hotkey,Add,!%A_Index%-%X_pid%,S_Hotkey	;�����ȼ��˵��Ա�ɾ��
		}
	}
}
RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate
if D_update{
	Menu,D_Set,ToggleCheck,��������
	if A_TickCount<20000	;�ж��Ƿ��ѿ�����20000���� ���⿪��δ����״̬��ȡ����
		SetTimer,�������,90000
	else
		gosub,�������
}
TrayTip,,Habit������
;�����ű�
Loop{
	IfWinNotActive,ahk_exe %D_Name% ;�ȴ���ǰ������ʧ ����һ��ѭ���ں���Ὣ
	{
		WinGet,D_Name,ProcessName,A ;��ȡ��ǰ���ڽ�����
		if not D_Name	;��������Ϊ��ʱ����ѭ��
		continue
		gosub,D_cx	;��ѯ���ݿ�
		sSearchCriteria = pid = '%D_Name%'
		oRecordset.Find(sSearchCriteria,,,1)	;�����ݿ��в�ѯ�Ƿ���ڴ˴��ڽ�����������
		if oRecordset.EOF{	;����������򴴽�����
			oRecordset.AddNew()
			for index, element in Array
			{
				oRecordset.Fields[element]:="1"	;�������������Ԥ��ֵΪ1
			}
			WinGet,D_Route,ProcessPath,A	;��ȡ��ǰ����·����ӵ����ݿ�
			oRecordset.Fields["pid"]:= D_Name	;��ӽ�����
			oRecordset.Fields["Hotkeys"]:= "0"	;����ȼ��� Ԥ��0
			oRecordset.Fields["Route"]:= D_Route	;��ӽ���·��
			oRecordset.Update()	;�������
		}else{	;������ڽ�������Ϊ�������� ��������õ����뷨
			D_Big= ;�ƿձ���
			D_Value=
			for index, element in Array	;��ȡ�����е����뷨���
			{
				A_element:=oRecordset.Fields[element].Value ;��157���Ѿ���ѯ�˽��̵��� �ڴ˿���ֱ�Ӷ�ȡ ���ڳ������е����뷨����е�ʹ�ô���
				if (A_element>D_Big){	;ֻ����ʹ�ô����������뷨��ŵ�����
					D_Big=%A_element%
					D_Value=%element%
				}
			}
			if D_TX	;�ж��Ƿ������� �������������ʾ�ű�ִ����Ϣ
			TrayTip,,%D_Name%`n����:%D_Value%-%D_Big%
			SwitchIME(D_Value)	;�л����뷨Ϊ����ȡ�õ��ĳ���ʹ�ô����������뷨
		}
		X_Name=	;������һ��������ֻҪ���־���Ӽ�¼ ����ֻ��¼������ڻ���һ����ĸʱʹ�õ����뷨
	}
	if A_TimeIdlePhysical<200	;�жϾ�����һ�������ʱ���Ƿ�Ϊ200������
	if A_PriorKey in q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,	;�ж�������Ƿ�Ϊ26��ĸ �����ȼ�Ҳ��¼
	if (X_Name<>D_Name){	;�����ж����ʱ�´�������ƿ� X_Name ����ֻ�����´���ִ��һ��if�ڵĴ���
		SetFormat,integer,hex
		HKL:=DllCall("GetKeyboardLayout","int",GetThRead(),UInt)
		StringTrimLeft,Layout,HKL,2
		Layout:= HKL=0x8040804 ? "00000804" : Layout
		Layout:= HKL=0x4090409 ? "00000409" : Layout
		SetFormat,IntegerFast,d
		;����һ���ǻ�ȡ��ǰ�������뷨
		gosub,D_cx	;��ѯ���ݿ�
		D_SS = pid = '%D_Name%'
		oRecordset.Find(D_SS,,,1)
		A_Layout:=oRecordset.Fields[Layout].Value	;�����ո�ʹ�����뷨�ڼ�¼�еĴ���
		J_Layout:=A_Layout+1	;����+1
		if D_TX	;���Կ�����Ϣ
		TrayTip,,%D_Name%`nд��:%Layout%-%J_Layout%`n%A_PriorKey%
		oRecordset.Fields[Layout]:= J_Layout	;д��+1�Ĵ��������뷨��
		oRecordset.MoveNext()	;�ƶ��α�
		X_Name=%D_Name%	;if (X_Name<>D_Name)�����Ͳ���ÿ����һ����ĸ�ͼ�¼��
	}
	Sleep, 100	;��һ���ӳٲ�Ҫƴ��������
}
return
;�˵����
������Ϣ:
Gui,D_about:New	;�����´���
Gui,D_about:+AlwaysOnTop -MinimizeBox -MinimizeBox +Owner	;�´��ڵ�һЩ���ÿ�����ahk����gui�в�ѯ
Gui,D_about:Add,Pic,w30 h-1 Icon222 Section,shell32.dll
Gui,D_about:Add,Text,x+10 ys+5 ,�汾��Ϣ��%D_bb%`n�������ԣ�AutoHotkey	;�����Ԥ����Ϣ������������
Gui,D_about:Add,Edit,xs w300 R5 ReadOnly,%D_bx%
Gui,D_about:Add,Link,xs,�ű����ۣ� <a href="%D_url%">%D_url%</a>
Gui,D_about:Show,AutoSize,������Ϣ
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
��������:
	Menu,D_Set,ToggleCheck,��������	;��������������˵�ʱ���˵����÷���
	IfExist,%A_Startup%%A_ScriptName%.lnk	;�ж��Ƿ��������ļ����ڴ��ڱ��ű���ݷ�ʽ
		FileDelete,%A_Startup%%A_ScriptName%.lnk	;������ɾ��
	else
		FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%%A_ScriptName%.lnk	;�������򴴽�
return
��������:
	Menu,D_Set,ToggleCheck,��������	;���÷���
	RegRead,D_update,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate	;��ȡע��������
	if D_update
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate	;������ɾ��
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,Habitupdate,To update	;�������򴴽�
return
�س��л�:	;ͬ�� ������һ�����ȼ������෴
	Menu,D_Set,ToggleCheck,�س��л�
	Hotkey,Enter,Toggle
	RegRead,D_Enter,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter
	if D_Enter
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitEnter,Switch
return
�����ȼ�:
	Menu,D_Set,ToggleCheck,�����ȼ�
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
���Կ���:	;ͬ��
	Menu,D_Set,ToggleCheck,���Կ���
	D_TX:=!D_TX
return
����/�ر�:
	Menu,D_Hotkey,ToggleCheck,����/�ر�
	Loop,9
	Hotkey,!%A_Index%,Toggle
	RegRead,D_Boss,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss
	if D_Boss
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARETestKey,HabitBoss,Boss
return
��ϵ����:
	Run tencent://message/?uin=%D_QQ%
return
�������:
	MsgBox,4,�������,����һ�����������`nȷ��Ҫ���������	;����һ��ѯ��
	IfMsgBox Yes	;�Ƿ�ѡ����YES
	{
		oRecordset.Close()	;�Ͽ����ݿ�
		oConnection.Close()	;�Ͽ����ݿ�
		FileDelete,%sDatabaseName%	;ɾ�����ݿ�����
		Reload	;�����ű�
	}
�����ű�:
	oRecordset.Close()
	oConnection.Close()
	Reload
�˳��ű�:
	ExitApp	;�˳��ű�
;��������
S_Hotkey:	;ɾ���ϰ��
	gosub,D_cx	;��ѯ���ݿ�
	StringLeft,S_Hotkey,A_ThisMenuItem,2	;������˵���ǰ�����ַ�������ȼ�����
	H_Hotkeys = Hotkeys = '%S_Hotkey%'
	oRecordset.Find(H_Hotkeys,,,1)	;��ѯ�Ƚ���
	oRecordset.Fields["Hotkeys"]:= "0"		;���ȼ����ƿ�
	oRecordset.MoveNext()
	Menu,D_Hotkey,Delete,%A_ThisMenuItem%	;ɾ���ȼ��˵�
	StringReplace,S_pid,A_ThisMenuItem,%S_Hotkey%-, , All		;ɾ������˵��е��ȼ�ʣ�� ������
	TrayTip,,%S_pid%���ȼ�`n"%S_Hotkey%"�Ѿ�ɾ��
return
D_Alt:	;�ϰ�� �ű�������ע���alt+���ֵ��ȼ�ͳһָ������ �����ȼ������д˱�ǩ
	gosub,D_cx	;��ѯ���ݿ�
	H_Hotkeys = Hotkeys = '%A_ThisHotkey%'
	oRecordset.Find(H_Hotkeys,,,1)	;�����ݿ��в�ѯ�ոհ����ȼ���Ӧ����
	if oRecordset.EOF{	;���ݿ��в����ڴ��ȼ���¼
		oRecordset.Find(sSearchCriteria,,,1)	;ȡ��ѭ��������Ӧ�ñ���ѯ�Ľ���
		X_Route:=oRecordset.Fields["Route"].Value	;��ȡ���̵�·�� �������·��ʱϵͳ����·���򲻴��� ��֪����ô�����в��� ϵͳ���Դ��ĳ���
		IfInString, X_Route, C:Windows	;���������ϵͳ�Դ���������� ����ʾ�û�
		{
			TrayTip,,��ֹΪϵͳĿ¼�³��������ȼ�`n%X_Route%
			return
		}
		oRecordset.Fields["Hotkeys"]:= A_ThisHotkey	;���ȼ���д�뵽����
		oRecordset.MoveNext()
		Menu,D_Hotkey,Add,%A_ThisHotkey%-%D_Name%,S_Hotkey	;�ڲ˵���Ϊ���ȼ������˵�
		TrayTip,,��Ϊ%D_Name%`n�����ϰ��"%A_ThisHotkey%"	;��ʾ�û������ɹ�
	}else{	;���ݿ��д��ڴ˼�¼ ���ȡ·���������
		X_Route:=oRecordset.Fields["Route"].Value
		X_pid:=oRecordset.Fields["pid"].Value
		IfWinActive ,ahk_exe %X_pid%	;���������ǰ�������ص�������
			WinMinimize
		else
			IfWinExist ,ahk_exe %X_pid%	;����Ƿ���ڴ���
				WinActivate
			else
				Run %X_Route%	;�����ڴ�����ֱ�����г���
	}
return
Ente:	;�س��л� �س����жϻ�ȡ�������ʹ�õ����뷨���л� ����ѭ����ͬ��
	Send {Enter}	;���ȷ��ͻس� ���б�Ҫ
	gosub,D_cx	;��ѯ���ݿ�
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
Temporary:	;��ʱ�ϰ�� ���ﲻ������www.ahk8.com���кܶ�һ�����õ�����
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
WinMove:	;�ѵ�ǰ���ڻ�ԭ���Ƶ���Ļ���м�! ����10��15���������޸ĵĹ��� ��˳ʱ���������λ�� �����
	D_Width:=(A_ScreenWidth/2)	;����ȡ����Ļ�߶����ȶ���֮һ�ĳߴ� ���жϴ������ڵ�λ��
	D_Height:=(A_ScreenHeight/2)
	WinGetPos,X,Y,Width,Height,A	;��ȡ��ǰ���ڵĴ�С��λ��
	if not D_window {	;����ִ�о���moce�ƶ�������������ڵĳߴ�Ϊ��Ļ�İ˷�֮һ
		WinMove,A,,A_ScreenWidth/8,A_ScreenHeight/8,(A_ScreenWidth/8)*6,(A_ScreenHeight/8)*6
		D_window=1	;��¼�Ѿ����й�
		return
	}
	if (X<D_Width) and (Y<D_Height-200)	;����	һ���ж��жϴ��������Ƿ���ĳ��λ�ò��ƶ����ڵ���һ��λ�õ�����СΪ ��Ļ���ķ�֮һ
		WinMove,A,,D_Width,,D_Width,D_Height
	if (X>D_Width-200) and (Y<D_Height-200)	;����
		WinMove,A,,,D_Height,D_Width,D_Height
	if (X>D_Width-200) and (Y>D_Height-200)	;����
		WinMove,A,,0,D_Height,D_Width,D_Height
	if (X<D_Width-200) and (Y>D_Height-200){	;����
		WinMove,A,,,0,D_Width,D_Height
		D_window=	;��¼���һ����ʱ���Ѿ����� �ڴ˰��´����ȼ�������ִ�о���
	}
;���ú��� ��Щ������������www.ahk8.com���ռ��� ����̳���������뷨���ݿ���кܶ�
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
	SetTimer,�������,Off	;���Ƚ�����ʱ��
	SplitPath,D_qiniu,,,,,OutDrive	;�������ļ�·����ֻ������
	update:=W_InternetCheckConnection(OutDrive)	;��������Ƿ���Է���
	if not update	;���ܷ������ȡ����������Ϣ�ļ�����
		return
	D_Array := StrSplit(DownloadToString(D_qiniu,"cp936"),"`n")	;�ú��������ļ���������������ʱ�ļ�
	D_Edit := D_Array[1] ;��ȡ��һ�а汾��
	D_link := D_Array[2] ;��ȡ�ڶ��������ļ�����
	D_Name := D_Array[3] ;���ļ���
	D_xing := D_Array[4] ;������Ϣ
	StringReplace, D_Edit, D_Edit, `r, , All	;ȥ�������еġ�`r��
	StringReplace, D_link, D_link, `r, , All
	StringReplace, D_Name, D_Name, `r, , All
	StringReplace, D_xing, D_xing, `r, , All
	if D_Edit is not number	;��ȡ�����汾�������
	{
		TrayTip,,��ȡ����ʧ��,10, 1
		return
	}
	if (D_Edit > D_bb)	;�ж��Ƿ�Ϊ�°汾
	{
		MsgBox,4,��⵽�°汾,�Ƿ������:%D_Edit%`n%D_xing%	;ѯ���û��Ƿ���²���ʾ������Ϣ
		IfMsgBox Yes
			gosub,D_Label
	}
return
D_Label:
	D_kb := InternetFileGetSize(D_link)
	Progress,1,%S_kb%/%D_kb%,���ڸ���...,AHK����
	FileDelete,%A_Temp%%D_Name%
	SetTimer,S_Label,500
	URLDownloadToFile,%D_link%,%A_Temp%%D_Name%
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
	FileGetSize,S_kb,%A_Temp%%D_Name%
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
W_InternetCheckConnection(lpszUrl){ ;���FTP�����Ƿ������
	FLAG_ICC_FORCE_CONNECTION := 0x1
	dwReserved := 0x0
	return, DllCall("Wininet.dllInternetCheckConnection", "Ptr", &lpszUrl, "UInt", FLAG_ICC_FORCE_CONNECTION, "UInt", dwReserved, "Int")
}
InternetFileGetSize(URL:=""){  ;��ȡ�����ļ���С
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
DownloadToString(URL, encoding="utf-8")	;�����ļ�������
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