#SingleInstance force  ; force reloading
/*
;-------------------------------------------------------------------------------
;利用candy的菜单构建函数
;   简单的做一个托盘菜单
;   看效果的时候，请查看有没有同名ini
;
;-------------------------------------------------------------------------------
*/
#Persistent
Menu, Tray, Icon, ..\AHKManager\mouse.ico
Label_Test_Main:
    #NoEnv
    Menu, TeseMenu, UseErrorLevel
;     Menu,TeseMenu,nostandard

    SetWorkingDir,%A_ScriptDir%
    global GArr_MenuIdx:={}              ;菜单用1
    global GArr_MenuItem:={}             ;菜单用2

^RButton::
    MouseGetPos,,,curwin
    WinGet,curwinname,ProcessName,Ahk_ID %curwin%     ;当前窗口的进程路径
    WinGet,_fullpath,ProcessPath,Ahk_ID %curwin%     ;当前窗口的进程路径
    SplitPath,_fullpath,,_ParentPath,,_NameNoExt  ;当前窗口的进程名称，不带后缀

    If fileExist(_NameNoExt ".ini")
        Test_Profile_Dir:=_NameNoExt
    else
        Test_Profile_Dir:="any"


    Menu,TeseMenu,DeleteAll
    Menu TeseMenu,Add
    GArr_MenuIdx:={}
    GArr_MenuItem:={}
    SkSub_Menu_GetItems(A_ScriptDir,Test_Profile_Dir,"testsec","TeseMenu","")
    SkSub_Menu_DeleteSubs("TeseMenu")
    For,k,v in GArr_MenuIdx
    {
        SkSub_Menu_Create_No_Icon(v,"TeseMenu","Label_Test_HandleMenu")
    }
    Menu,TeseMenu,Show
    Return
Label_Test_HandleMenu:
    MsgBox 到了这里，说明你会用了
    return
/*
;-------------------------------------------------------------------------------
; 示例用的是无图标函数
;
;
;
;-------------------------------------------------------------------------------
*/
SkSub_Menu_GetItems(IniDir,IniNameNoExt,Sec,TopRootMenuName,Parent="")
{
    Items:=SkSub_IniRead_Section(IniDir "\" IniNameNoExt ".ini",Sec)
    StringReplace,Items,Items,△,`t,all
    Loop,parse,Items,`n
    {
        Left:=RegExReplace(A_LoopField,"(?<=\/)\s+|\s+(?=\/)|^\s+|(|\s+)=[^!]*[^>]*")
        Right:=RegExReplace(A_LoopField,"^.*?\=\s*(.*)\s*$","$1")
        If (RegExMatch(left,"^/|//|/$|^$"))
            Continue
        If RegExMatch(Left,"i)(^|/)\+$")
        {
            m_Parent :=  InStr(Left,"/") > 0 ? RegExReplace(Left,"/[^/]*$") "/" : ""
            Right:=RegExReplace(Right,"~\|",Chr(3))
            arrRight:=StrSplit(Right,"|"," `t")
            rr1:=arrRight[1]
            rr2:=RegExReplace(arrRight[2],Chr(3),"|")
            rr3:=RegExReplace(arrRight[3],Chr(3),"|")
            rr4:=RegExReplace(arrRight[4],Chr(3),"|")
            If (rr1="Menu")
            {
                m_ini:= (rr2="") ? IniNameNoExt :  rr2
                m_Sec:= (rr3="") ? "Menu" : rr3
                m_Parent:=Parent "" m_Parent
                this:=SkSub_Menu_GetItems(IniDir,m_ini,m_Sec,TopRootMenuName,m_Parent)
            }
        }
        Else
        {
            GArr_MenuIdx.insert( Parent ""  Left )
            GArr_MenuItem[ TopRootMenuName "/" Parent "" Left] := Right
            GArr_MenuFromIni[ TopRootMenuName "/" Parent "" Left] :=IniNameNoExt
        }
    }
}
SkSub_Menu_DeleteSubs(TopRootMenuName)
{
    For i,v in GArr_MenuIdx
    {
        If instr(v,"/")>0
        {
            Item:=RegExReplace(v, "(.*)/.*", "$1")
            Menu,%TopRootMenuName%/%Item%,DeleteAll
        }
    }
}
SkSub_Menu_Create_No_Icon(Item,ParentMenuName,label)
{
    arrS:=StrSplit(Item,"/"," `t")
    _s:=arrS[1]
    if arrS.Maxindex()= 1
    {
        If InStr(_s,"-") = 1
        Menu, %ParentMenuName%, Add
        Else If InStr(_s,"*") = 1
        {
            _s:=Ltrim(_s,"*")
            Menu, %ParentMenuName%, Add,       %_s%,%Label%
            Menu, %ParentMenuName%, Disable,  %_s%
        }
        Else
        {
            _Right:=GArr_MenuItem[ ParentMenuName "/" Item]
            Menu, %ParentMenuName%, Add,  %_s%,%Label%
        }
    }
    Else
    {
        _Sub_ParentName=%ParentMenuName%/%_s%
        StringTrimLeft,_subItem,Item,strlen(_s)+1
        SkSub_Menu_Create_No_Icon(_subItem,_Sub_ParentName,label)
        Menu,%ParentMenuName%,Add,%_s%,:%_Sub_ParentName%
    }
}
SkSub_IniRead_Section(ini,sec)   ;返回全部某段的内容，函数化而已
{
	IniRead,keylist,%ini%,%sec%              ;提取[sec]段里面所有的群组
		Return %keylist%
}