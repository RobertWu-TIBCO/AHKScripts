#SingleInstance force  ; force reloading
Menu, Tray, Icon, gahk.ico
/*
ΪQQ�����ȼ�
����ű�ǰ���ǣ���Ҫ����Ĵ�����Ҫ���ȴ򿪵ģ�������岻����С������
Ȼ����win+f1 ̽�����ǣ�
Ȼ����Զ������°󶨣�
win q ��Ϣ����
win a �Ự�б�
win z ���������

ֻ����������ȼ�ǰ�ǲ�����С��
Author:             sunwind <1576157@qq.com>
Blog:               http://blog.csdn.net/liuyukuan
Copyright:          2016 sunwind
Date:               2016��2��19��23:36:07z
AutoHotkey Version: 1.1.23.01
OS:                 WIN_7
*/
#Persistent
DetectHiddenText, On
SetTitleMatchMode,2
;~ 2: ���ڱ����ĳ��λ�ñ������WinTitle��.
WinTitle=ahk_class TXGuiFoundation
main:
WinGet, winList,List,%WinTitle%
wins:=[]
Loop,%winList%
{
    this_id=% winList%A_Index%
    WinGetTitle,this_title,ahk_id %this_id%
    wins.Insert({index:A_Index,title:this_title,id:this_id})
}
main_flag:=box_flag:=message_flag:=0
for each,win in wins
{
        if InStr(win.title,"QQ")
        {
            main_flag:=1
            main_id:=win.id
            Hotkey,#F2,bind
        }
        ;else if InStr(win.title,"��Ϣ����")
        else if InStr(win.title,"��Ϣ������")
        {
            box_flag:=1
            box_id:=win.id
            Hotkey,#F3,box
        }
        else 
        {
            message_flag:=1
            message_id:=win.id
            Hotkey,#F1,message
        }
}
if (main_flag=1)
{
    ;MsgBox  �Ѿ����ȼ�#F2Ϊ����弤���ȼ�
;disable Msgbox so each reload would have no interrupts
}
if(main_flag=0)
{
    ;MsgBox �������������������#F4̽�ⴰ�ڣ�������Զ����ȼ�#F2Ϊ����弤���ȼ���
}
if(box_flag=1)
{
;    MsgBox  �Ѿ����ȼ�#F3Ϊ��Ϣ���Ӽ����ȼ�
}
if(box_flag=0)
{
    ;MsgBox ����������Ϣ���Ӻ�����#F4̽�ⴰ�ڣ�������Զ����ȼ�#F3Ϊ��Ϣ���Ӽ����ȼ���
}
if(message_flag=1)
{
    ;MsgBox  �Ѿ����ȼ�#F1Ϊ�Ự�б��ڼ����ȼ�
}
if(message_flag=0)
{
    ;MsgBox �������лỰ�б��ں�����#F4̽�ⴰ�ڣ�������Զ����ȼ�#F1Ϊ�лỰ�б��ڼ����ȼ���
}

return
;~ #q
box: 
WinActivate,ahk_id %box_id%
return

;~ #a
message:
WinActivate,ahk_id %message_id%
return

;~ #z
bind:
WinActivate,ahk_id %main_id%
return
#f4::gosub main

#f5::
IfWinExist Ⱥͨ��
WinActivate
return

::rq::
reload
return