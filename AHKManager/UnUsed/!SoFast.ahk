;ԭ���ߣ�sfufoet
;====================================
; ����Сѩ �޸���Ʒ
; http://wwww.snow518.cn/
;====================================

#Persistent
#SingleInstance
; ��֤����һֱ����
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
; ɾ�� AutoHotKey Ĭ�ϵ�����ͼ���Ҽ��˵�
Menu,Tray,Add,���(&R), mycheck
Menu,Tray,Add
Menu,Tray,Add,�༭(&E)..., editme
Menu,Tray,Add
Menu,Tray,Add,�˳�(&X), Exit
Menu,Tray,Add
Menu,Tray,Tip,���͸��¼�鹤��
Menu,Tray,Default, ���(&R)
Menu,Tray,Click,1
icon=F
changed=F
count=0
; ÿһ��������һ�� loopcheck����������������Ҫ�޸ģ���λ�Ǻ��룬��������ֹ����Ļ����һ�����ͼ�꣬ѡ�񡰼�顱
app := SubStr(A_ScriptName, 1, StrLen(A_ScriptName) - 4)
iniFile = %app%.ini

iconNone=%app%_none.ico
iconNew=%app%_new.ico
iconNormal=%app%.ico
Menu,Tray,Icon,%iconNormal%

SetTimer, changeicon, 500
SetTimer, loopcheck,60000
Return

mycheck:
gosub loopcheck
Return

loopcheck:
Loop
{
	FileReadLine, TargetURL, %iniFile%, %A_Index%
	; ��ȡ�ļ� urls.txt ��ÿһ�У��ŵ����� TargetURL ���棬��� urls.txt �У�һ����ַ����һ�С�
	if ErrorLevel
		break
	; ����Ҳ����ļ��Ļ�������ѭ����

	nowf=%TargetURL%
	StringReplace,nowf,nowf,\,_,All
	StringReplace,nowf,nowf,/,_,All
	StringReplace,nowf,nowf,:,_,All
	StringReplace,nowf,nowf,*,_,All
	StringReplace,nowf,nowf,?,_,All
	StringReplace,nowf,nowf,`",_,All
	StringReplace,nowf,nowf,<,_,All
	StringReplace,nowf,nowf,>,_,All
	StringReplace,nowf,nowf,|,_,All

	UrlDownloadToFile, %TargetURL%, %app%_data\%nowf%.txt
	; ���ض�ȡ������ַ��һ����ѭ������A_Index�������� txt �С�
	FileRead, alltext, %app%_data\%nowf%.txt
	; �Ѷ�ȡ���ص����ļ��� alltext
	;SplitText=<div id="content">
	SplitText=<div class="post"
	; ���÷ָ��ַ������� Wordpres ������ĵı�ǡ�
	StringGetPos, textPos, alltext, %SplitText%
	if textPos < 0
	{
		SplitText=<div id="content">
		StringGetPos, textPos, alltext, %SplitText%
	}
	; ��� SplitText �� alltext �е�λ��
	StringTrimLeft, alltext, alltext, %textPos%
	; ȥ�� <div id="content"> ֮ǰ�������ַ���
	RegExMatch(alltext, "http://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?",URL)
	; ��ʣ�µ���������������ʽ��������������������ƥ����ַ��
	IfNotExist %app%_data\%nowf%_url.txt
	{
		FileAppend, %URL%, %app%_data\%nowf%_url.txt
	}
	; ����ļ������ڣ���ƥ�䵽����ַд��һ�� txt
	else
	{
	; ����ļ����ڣ��ȶ�ȡ��Ȼ��ɾ�����ٱȽ϶�ȡ�����ݺ�ƥ�䵽�������ǲ���һ���ġ�
		FileRead, temp, %app%_data\%nowf%_url.txt
		FileDelete, %app%_data\%nowf%_url.txt
		FileAppend, %URL%, %app%_data\%nowf%_url.txt
		if (URL<>temp)
		{
			traytip,[%TargetURL%] �ոո����ˡ���,%URL% ,,1
			menu,tray,add,%URL%,show
			count:=count+1
			;run %URL%
			; ��һ���Ļ�������������ʾ��������ƥ�䵽����ַ��Ҳ����ֱ�Ӵ������¡�
		}
	}
}
return

changeicon:
if count=0
{
	if changed=F
	{
		menu,tray,icon,%iconNormal%
		changed=T
	}
}
else
{
	changed=F
	if icon=F
	{
		menu,tray,icon,%iconNew%
		icon=T
	}
	else
	{
		menu,tray,icon,%iconNone%
		icon=F
	}
}
return

editme:
Run, edit %A_ScriptDir%\%app%.ini
return

show:
Run %A_ThisMenuItem%
Menu,Tray,Delete,%A_ThisMenuItem%
count:=count-1
Return

Exit:
ExitApp
