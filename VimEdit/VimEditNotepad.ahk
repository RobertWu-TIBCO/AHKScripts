#SingleInstance force 

;Menu, Tray, Icon,vimEdit.ico
Menu, Tray, Icon,NOTEPAD++.ico

^!i::
    tmpfile=%A_ScriptDir%\ahk_text_edit_in_notepad.txt
    gvim=F:\Program Files\Notepad++\notepad++.exe
    WinGetTitle, active_title, A
	;�ж��ļ�����
filetype=%active_title%
IfInString, active_title, SQL ��ѯ������
filetype=sql
    clipboard =
        ; ��ռ�����
    send ^a
        ; ���� Ctrl + A ѡ��ȫ������
    send ^c
        ; ���� Ctrl + C ����
    clipwait
        ; �ȴ����ݽ��������
    FileDelete, %tmpfile%
    FileAppend, %clipboard%, %tmpfile%
    runwait, %gvim% "%tmpfile%"
	WinWaitActive %active_title%
    ;MsgBox %active_title%
        ; �ȴ��ղŻ�ȡ���ֵĴ��ڼ���
    fileread, text, %tmpfile%
    clipboard:=text
        ; ��ԭ��ȡ�����ݵ�������
    ;winwait %active_title%
    send ^v
        ; ���� Ctrl + V ճ��
return 