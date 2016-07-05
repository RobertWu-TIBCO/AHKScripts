;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：1.1.23.01
; 版本日期 ：2016.04.27
; 版本日期 : 2014年09月10日
; 适用平台：Win7
; 作       者：Kawvin(285781427@qq.com)
; 原  作  者：妖(aamii@qq.com)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 /*
╔══════════════════════════════════════╗
║   <<<<〇程序头部>>>>                                                  ║
╚══════════════════════════════════════╝
*/
SetWorkingDir,%A_ScriptDir%      ;设置工作目录
#MaxThreadsPerHotkey 9              ;最大热键数量
#SingleInstance force                      ;单脚本运行
#WinActivateForce                          ;强制激活窗体
#ClipboardTimeout 500                  ;首次访问剪贴板失败后继续尝试访问剪贴板的持续时间
Process Priority,,High                       ;线程,主,高级别
coordmode,Mouse,screen               ;设置鼠标相对于屏幕激活
coordmode,Menu                            ;设置菜单相对于窗口激活
SetTitleMatchMode,2                      ;设置WinWait等命令,匹配包含指定的 WinTitle 的窗口标题,精确匹配
DetectHiddenWindows On             ;不可见的窗口是否被脚本“看见”,是
AutoTrim,on                                     ;自动省略首尾的空格和Tab
SetBatchLines -1                              ;让脚本无休眠地执行（换句话说，也就是让脚本全速运行）
ComObjError(0)                               ;禁用  COM 错误通告
global Ky_RunWithSystem:=0          ;定义随系统启动变量
global Ky_FoldersPasteMode:=        ;定义文件夹结构粘贴模式
global Ky_SouFolder:=                     ;定义要复制的源文件夹
global Ky_DesFolder:=                     ;定义要粘贴的目标文件夹
global Ky_RecentPWS:=                   ;最近可用的解压密码
global Ky_ShiftIsPressed:=               ;按下Shift键，则执行第二操作
global Ky_CapslockIsPressed:=        ;按下Capslock键，则执行第二操作
Menu, Tray, UseErrorLevel               ;阻止显示对话框和终止线程
; #NoTrayIcon
Menu, Tray, Icon, candy.ico
SkSub_CreatTrayMenu()                   ;创建一个自定义的托盘菜单
 /*
╔══════════════════════════════════════╗
║<<<<〇全局设置>>>>                                                     ║
╚══════════════════════════════════════╝
*/
Label_My_global_and_PreDefined_Var:
	global szMenuIdx:={}                 ;菜单用1
	global szMenuContent:={}         ;菜单用2
	global szMenuWhichFile:={}      ;菜单用3
	global GeneralSettings_ini     := "ini\GeneralSettings.ini"
	IniRead All_MyVar,%GeneralSettings_ini%,MyVar		   	;读取我的变量，进行环境变量设置
    
	loop,parse,All_MyVar,`n
	{
		MyVar_Key:=RegExReplace(A_LoopField,"=.*?$")  	 ;用户自定义变量的key
		MyVar_Val:=RegExReplace(A_LoopField,"^.*?=") 		 ;用户自定义变量的value
		if (MyVar_Key && MyVar_Val && not instr(MyVar_Key," "))  ;抛弃空变量以及含空格的变量
			%MyVar_Key%=%MyVar_Val%   					;这样的写法不会传递环境变量。EnvSet,%MyVar_Key%,"%MyVar_Val%" ;另一种写法，可以传递环境变量到被他启动的应用程序
	}
 /*
╔══════════════════════════════════════╗
║<<<<①热键定义>>>>                                                     ║
╚══════════════════════════════════════╝
*/
Label_Candy_SetHotKey:         ;热键定义段，这个部分要插入到“全脚本的自动运行部分去”，可用Gosub解决。
	IniRead,Candy_hotkey,%GeneralSettings_ini%,Candy_Hotkey           ;读取整个热键定义字段，自定义热键格式:   热键=配置文件
	Loop,parse,Candy_hotkey,`n     ;循环读取ini里面，热键定义字段的每一行
	{
		Hotkey,% RegExReplace(A_loopfield,"=.*?$"),Label_Candy_Start,On,UseErrorLevel   ;左边是热键
		If ErrorLevel  ;热键出错
            MsgBox % "您定义的热键:      "   RegExReplace(A_loopfield,"=.*?$")   "     不可用，请检查!"
	}
    Return
 /*
╔══════════════════════════════════════╗
║<<<<②启动，获取对象>>>>                                           ║
╚══════════════════════════════════════╝
*/
Label_Candy_Start:
;     CandyStartTick :=A_TickCount  ;若要评估出menu时间，这里需打开 ,共三处，1/3
    SkSub_Clear_CandyVar()
    MouseGetPos,,,Candy_CurWin_id         ;当前鼠标下的进程ID
    WinGet, Candy_CurWin_Fullpath,ProcessPath,Ahk_ID %Candy_CurWin_id%    ;当前进程的路径
    WinGetTitle, Candy_Title,Ahk_ID %Candy_CurWin_id%    ;当前进程的标题
    Candy_Saved_ClipBoard := ClipboardAll
    Clipboard =
    Send, ^c
    ClipWait,0.5
    If ( ErrorLevel  )          ;如果没有选择到什么东西，则退出
    {
        ;~ Clipboard := Candy_Saved_ClipBoard    ;还原粘贴板
        ;~ Candy_Saved_ClipBoard =
        ;~ Return
        Clipboard:= Explorer_GetPath() . "|RightMenu"
    }
    Candy_isFile := DllCall("IsClipboardFormatAvailable", "UInt", 15)   ;是否是文件类型
    Candy_isHtml := DllCall("RegisterClipboardFormat", "str", "HTML Format")  ;是否Html类型
    CandySel=%Clipboard%
    CandySel_Rich:=ClipboardAll
    Clipboard := Candy_Saved_ClipBoard  ;还原粘贴板
    Candy_Saved_ClipBoard =
    IniRead,Candy_ProFile_Ini,%GeneralSettings_ini%,Candy_Hotkey,%A_Thishotkey%    ;本热键所调取的配置文件
    Transform,Candy_ProFile_Ini,Deref,%Candy_ProFile_Ini%                         ;ini文件路径可以使用自定义变量以及环境变量
    IfNotExist %Candy_ProFile_Ini%         ;如果配置文件不存在，则发出警告，且终止
    {
        MsgBox 对热键%A_thishotkey% 定义的配置文件不存在! `n--------`n请检查%Candy_ProFile_Ini%
        Return
    }
    SplitPath,Candy_ProFile_Ini,,Candy_Profile_Dir,,Candy_ProFile_Ini_NameNoext
 /*
╔══════════════════════════════════════╗
║<<<<③选中内容的后缀定义>>>>                                    ║
╚══════════════════════════════════════╝
*/
    If(Fileexist(CandySel) && RegExMatch(CandySel,"^(\\\\|.:\\)")) ;文件或者文件夹,不再支持相对路径的文件路径,但容许“文字模式的全路径”
    {
        Candy_isFile:=1     ;如果是“文字型”的有效路径，强制认定为文件
        SplitPath,CandySel,CandySel_FileNameWithExt,CandySel_ParentPath,CandySel_Ext,CandySel_FileNameNoExt,CandySel_Drive
        SplitPath,CandySel_ParentPath,CandySel_ParentName,,,, ;用这个提取“所在文件夹名”
        If InStr(FileExist(CandySel), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
        {
            CandySel_FileNameNoExt:=CandySel_FileNameWithExt
            CandySel_Ext:=RegExMatch(CandySel,"^.:\\$") ? "Drive":"Folder"  ;细分：盘符或者文件夹
        }
        Else  If (CandySel_Ext="")       ;若不是文件夹，且无后缀，则定义为NoExt
        {
            CandySel_Ext:="NoExt"
        }
        if (CandySel_ParentName="")
            CandySel_ParentName:=RTrim(CandySel_Drive,":")
    }
    Else If InStr(CandySel, "|RightMenu")  ;区分是否为右键菜单
    {
        CandySel:=StrReplace(CandySel,"|RightMenu","")
        Candy_isFile:=1     ;如果是“文字型”的有效路径，强制认定为文件
        SplitPath,CandySel,CandySel_FileNameWithExt,CandySel_ParentPath,CandySel_Ext,CandySel_FileNameNoExt,CandySel_Drive
        SplitPath,CandySel_ParentPath,CandySel_ParentName,,,, ;用这个提取“所在文件夹名”
        CandySel_FileNameNoExt:=CandySel_FileNameWithExt
        CandySel_Ext=RightMenu
    }
    Else if(instr(CandySel,"`n") And  Candy_isFile=1)  ;如果包含多行，且粘贴板性质为文件，则是“多文件”
    {
        CandySel_Ext:="MultiFiles" ;多文件的后缀=MultiFiles
        CandySel_FirstFile:=RegExReplace(CandySel,"(.*)\r.*","$1")  ;取第一行
        SplitPath ,CandySel_FirstFile,,CandySel_ParentPath,,  ;以第一行的父目录为“多文件的父目录”
        If RegExMatch(CandySel_ParentPath,"\:(|\\)$")  ;如果父目录是磁盘根目录,用盘符做父目录名。
            CandySel_ParentName:= RTrim(CandySel_ParentPath,":")
        else  ;否则，提取父目录名
            CandySel_ParentName:= RegExReplace(CandySel_ParentPath, ".*\\(.*)$", "$1")
    }
    Else     ;文本类型
    {
        ;-----------特殊文字串辨析-------------------
        IniRead Candy_User_defined_TextType,%Candy_ProFile_Ini%,user_defined_TextType  ;是否符合用户正则定义的文本类型，有优先顺序的，排在前面的优先
        loop,parse,Candy_User_defined_TextType,`n
        {
            If(RegExMatch(CandySel,RegExReplace(A_LoopField,"^.*?=")))     ;根据ini里面用户自定义段，逐条查看，右侧是正则规则
            {
                CandySel_Ext:=RegExReplace(A_LoopField,"=.*?$")   ;左边是“文本某类型”
                Candy_Cmd:=SkSub_Regex_IniRead(Candy_ProFile_Ini, "TextType", "i)(^|\|)" CandySel_Ext "($|\|)") ;获取该类型的”操作设定“
                If(Candy_Cmd!="Error")            ;如果有相应后缀组的定义，则跳出去运行。
                {
                    Goto Label_Candy_Read_Value
                    Break
                }
            }
        }
        IniRead,Candy_ShortText_Length,%Candy_ProFile_Ini%,Candy_Settings,ShortText_Length,80   ;没有定义，则根据所选文本的长短，设定为长文本或者短文本
        CandySel_Ext:=StrLen(CandySel) < Candy_ShortText_Length ? "ShortText" : "LongText" ;区分长短文本
    }
 /*
╔══════════════════════════════════════╗
║<<<<④查找定义>>>>                                                     ║
╚══════════════════════════════════════╝
*/
Label_Candy_Read_Value:
    Candy_Type          :=Candy_isFile> 0 ? "FileType":"TextType"         ;根据Candy_isFile判断类型，在相应的INI段里面查找定义
    Candy_Type_Any   :=Candy_isFile> 0 ? "AnyFile":"AnyText"         ;根据Candy_isFile判断类型，对应的Any的名称
    Candy_Cmd:=SkSub_Regex_IniRead(Candy_ProFile_Ini, Candy_Type, "i)(^|\|)" CandySel_Ext "($|\|)")  ;查找后缀群定义
    If(Candy_Cmd="Error")            ;如果没有相应后缀组的定义；下面这些啰嗦的写法是为了各种容错
    {
        IfExist,%Candy_Profile_Dir%\%CandySel_Ext%.ini   ;看是否有 后缀.ini 的配置文件存在
        {
            Candy_Cmd:="menu|" CandySel_Ext   ;同时，转化为Menu|命令行写法
        }
        Else
        {
            IniRead,Candy_Cmd, %Candy_ProFile_Ini%,%Candy_Type%,%Candy_Type_Any%   ;如果没有则看看 Any在ini的定义有没有
            If(Candy_Cmd="Error")   ;没有对AnyFile（或AnyText）的定义，则看是否有 AnyFile.ini或AnyText.ini配置存在
            {
                IfExist,%Candy_Profile_Dir%\%Candy_Type%.ini   ;有，则以此为准
                {
                    Candy_Cmd:="menu|" Candy_Type   ;同时，转化为Menu|命令行写法
                }
                Else
                {
                    Run,%CandySel%, ,UseErrorLevel  ;层层把关都没有么，好失望的说，就直接运行吧
                    Return
                }
            }
        }
    }
    If !(RegExMatch(Candy_Cmd,"i)^Menu\|"))
    {
        Goto Label_Candy_RunCommand            ;如果不是menu指令，直接运行应用程序
    }
 /*
╔══════════════════════════════════════╗
║<<<<⑤制作菜单>>>>                                                     ║
╚══════════════════════════════════════╝
*/
Label_Candy_DrawMenu:
    Menu,CandyTopLevelMenu,add
    Menu,CandyTopLevelMenu,DeleteAll
    CandyMenu_IconSize:=SkSub_IniRead(GeneralSettings_ini, "General_Settings", "MenuIconSize",16)
    CandyMenu_IconDir:=SkSub_IniRead(GeneralSettings_ini, "General_Settings", "MenuIconDir")  ;菜单图标位置

 ;加第一行菜单，缩略显示选中的内容，该菜单让你拷贝其内容
    CandyMenu_FirstItem:=Strlen(CdSel_NoSpace:=Trim(CandySel)) >20 ? SubStr(CdSel_NoSpace,1,10) . "..." . SubStr(CdSel_NoSpace,-10) : CdSel_NoSpace
    Menu CandyTopLevelMenu,Add,%CandyMenu_FirstItem%,Label_Candy_CopyFullpath
    Candy_Firstline_Icon:=SkSub_Get_Firstline_Icon(CandySel_Ext,CandySel,CandyMenu_IconDir "\Extension")
    Menu CandyTopLevelMenu,icon,%CandyMenu_FirstItem%,%Candy_Firstline_Icon%,,%CandyMenu_IconSize%
    Menu CandyTopLevelMenu,Add

    arrCandyMenuFrom:=StrSplit( Candy_Cmd,"|")
    CandyMenu_ini:= arrCandyMenuFrom[2]="" ? Candy_ProFile_Ini_NameNoext : arrCandyMenuFrom[2]
    CandyMenu_sec:= arrCandyMenuFrom[3]="" ? "Menu" : arrCandyMenuFrom[3]

    szMenuIdx:={}
    szMenuContent:={}
    szMenuWhichFile:={}
    SkSub_GetMenuItem(Candy_Profile_Dir,CandyMenu_ini,CandyMenu_sec,"CandyTopLevelMenu","")
    SkSub_DeleteSubMenus("CandyTopLevelMenu")

    For,k,v in szMenuIdx
    {
        SkSub_CreateMenu(v,"CandyTopLevelMenu","Label_Candy_HandleMenu",CandyMenu_IconDir,CandyMenu_IconSize)
    }
    MouseGetPos,CandyMenu_X, CandyMenu_Y
    MouseMove,CandyMenu_X,CandyMenu_Y,0
    MouseMove,CandyMenu_X,CandyMenu_Y,0
;     ToolTip,% A_TickCount-CandyStartTick,200,0     ;若要评估出menu时间，这里需打开 ,共三处，2/3
    Menu,CandyTopLevelMenu,shOW
;     ToolTip ;若要评估出menu时间，这里需打开 ,共三处，3/3
    Return

;================菜单处理================================
Label_Candy_HandleMenu:
    If GetKeyState("Ctrl")			    ;[按住Ctrl则是进入配置]
    {
        if GetKeyState("Capslock", "T")
            Ky_CapslockIsPressed:=1
        else
            Ky_CapslockIsPressed:=0
        Candy_ctrl_ini_fullpath:=Candy_Profile_Dir . "\" . szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem] . ".ini"
        Candy_Ctrl_Regex:= "=\s*\Q" szMenuContent[ A_thisMenu "/" A_ThisMenuItem] "\E\s*$"
        SkSub_EditConfig(Candy_ctrl_ini_fullpath,Candy_Ctrl_Regex)
    }
    else if GetKeyState("Shift")      ;[按住Shift则是执行第二操作]
    {
        if GetKeyState("Capslock", "T")
            Ky_CapslockIsPressed:=1
        else
            Ky_CapslockIsPressed:=0
        Ky_ShiftIsPressed:=1
        Candy_Cmd := szMenuContent[ A_thisMenu "/" A_ThisMenuItem]
        CandyError_From_Menu:=1
        Goto Label_Candy_RunCommand
    }
    else
    {
        if GetKeyState("Capslock", "T")
            Ky_CapslockIsPressed:=1
        else
            Ky_CapslockIsPressed:=0
        Candy_Cmd := szMenuContent[ A_thisMenu "/" A_ThisMenuItem]
        CandyError_From_Menu:=1
        Goto Label_Candy_RunCommand
    }
    return

Label_Candy_CopyFullpath:
    If GetKeyState("Ctrl")			    ;[按住Ctrl则是进入主配置]
    {
        Candy_Ctrl_Regex:="i)(^\s*|\|)" CandySel_Ext "(\||\s*)[^=]*="
        SkSub_EditConfig(Candy_Profile_ini,Candy_Ctrl_Regex)
    }
    Else
        Clipboard:=CandySel
    Return
 /*
╔══════════════════════════════════════╗
║<<<<⑥变量替换>>>>                                                     ║
╚══════════════════════════════════════╝
*/
Label_Candy_RunCommand:
    Candy_Cmd:=SkSub_EnvTrans(Candy_Cmd)  ;替换自变量以及系统变量,Ini里面用~%表示一个%,当然要用~~%，表示一个原义的~%
    Candy_Cmd=%Candy_Cmd%
    If (instr(Candy_Cmd,"{SetClipBoard:pure}")+instr(Candy_Cmd,"{SetClipBoard:rich}") )       ;这个开关指令会修改系统粘贴板，不会对命令行本身产生作用。所以先要从命令行替换掉。
    {
        Clipboard:=InStr(Candy_Cmd,"{SetClipBoard:pure}") ? CandySel : CandySel_Rich
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{SetClipBoard\:.*\}")
    }
    If (instr(Candy_Cmd,"{icon:")) ;icon图标
    {
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{icon\:.*\}")
    }
    If Candy_Cmd=   ;如果只想进行以上两步操作，如果运行的指令为空，则直接退出
        Return
    If instr(Candy_Cmd,"{date:")     ; 时间参数！定义方法为:{date:yyyy_MM_dd} 冒号:后面的部分可以随意定义
    {
        Candy_Time_Mode:=RegExReplace(Candy_Cmd,"i).*\{date\:(.*?)\}.*","$1")
        FormatTime,Candy_Time_Formated,%A_nOW%,%Candy_Time_Mode%
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{date\:(.*?)\}",Candy_Time_Formated)
    }
    If instr(Candy_Cmd,"{in:")    ; in：多文件的后缀包含
    {
        Candy_in_M:="i`am)^.*\.(" RegExReplace(Candy_Cmd,"i).*\{in\:(.*?)\}.*","$1") ")$"
        Grep(CandySel, Candy_in_M, CandySel, 1, 0, "`n")
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{in\:.*\}")
        If  (CandySel="")
            Return
        Else
            StringReplace,CandySel,CandySel,`n,`r`n,all
    }
    If instr(Candy_Cmd,"{ex:")    ; ex：多文件的后缀排除
    {
        Candy_ex_M:="i`am)^.*\.(" RegExReplace(Candy_Cmd,"i).*\{ex\:(.*?)\}.*","$1") ")$\R?"    ;可用，只是多了一个”后空白问题“
        CandySel:=RegExReplace(CandySel,Candy_ex_M)
        CandySel:=RegExReplace(CandySel,"\s*$","")         ;清除后空白 CandySel:=trim(CandySel,"`r`n")         ;清除后空白
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{ex\:.*\}")
        Clipboard:=CandySel
        If  (CandySel="")
            Return
    }
    If instr(Candy_Cmd,"{input:")   ;特别的参数:带有prompt提示文字的input 例：{Input:请输入延迟时间，以ms为单位},支持多个input输入
    {    ;如果要输入密码，请写成{input:提示文字:hide}
        CdInput_P=1
        Candy_Cmd_tmp:=Candy_Cmd
        While	CdInput_P :=	RegExMatch(Candy_Cmd_tmp, "i)\{input\:(.*?)\}", CdInput_M, CdInput_P+strlen(CdInput_M))
        {
            CdInput_Prompt:= RegExReplace(CdInput_M,"i).*\{input\:(.*?)(:hide)?}.*","$1")
            CdInput_Hide:= RegExMatch(CdInput_M,"i)\{input:.*?:hide}") ? "hide":""
            Gui +LastFound +OWnDialogs +AlwaysOnTop
            InputBox, CdInput_txt,Candy InputBox,`n%CdInput_Prompt% ,%CdInput_Hide%, 285, 175,,,,,
            If ErrorLevel
                Return
            Else
                StringReplace,Candy_Cmd,Candy_Cmd,%CdInput_M%,%CdInput_txt%
        }
    }
    If instr(Candy_Cmd,"{box:Filebrowser}")
    {
        FileSelectFile, f_File ,,, 请选择文件
        If ErrorLevel
            return
        StringReplace,Candy_Cmd,Candy_Cmd,{box:Filebrowser},%f_File%,All
    }
    If instr(Candy_Cmd,"{box:mFilebrowser}")
    {
        FileSelectFile, f_File ,M, , 请选择文件
        If ErrorLevel
            return
        CdMfile_suffix  := RegExReplace(Candy_Cmd,"i).*\{box:mFilebrowser:.*LastFile(.*?)\}.*","$1")
        CdMfile_prefix  := RegExReplace(Candy_Cmd,"i).*\{box:mFilebrowser:(.*?)FirstFile.*","$1")
        CdMfile_midfix := RegExReplace(Candy_Cmd,"i).*\{box:mFilebrowser:.*FirstFile(.*?)LastFile.*\}.*","$1")
        Firstline:=RegExReplace(f_File,"\n.*")
        no_Firstline:=RegExReplace(f_File,"^.*?\n","$1")
        StringReplace  ,CandySel_list,no_Firstline,`n,%CdMfile_midfix%%Firstline%/,all
        CandySel_list=%CdMfile_prefix%%Firstline%\%CandySel_list%%CdMfile_suffix%
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{.*FirstFile.*LastFile.*\}",CandySel_list)
    }
    If instr(Candy_Cmd,"{box:folderbrowser}")
    {
        FileSelectFolder, f_Folder , , , 请选择文件夹
        If f_Folder <>
            StringReplace,Candy_Cmd,Candy_Cmd,{box:folderbrowser},%f_Folder%,All
        Else
            Return
    }
    Candy_Cmd:=RegExReplace(Candy_Cmd,"(?<=\s|^)\{File:fullpath\}(?=\s|$|\|)","""{File:fullpath}""")     ;强制把前后有空字符或者顶端的全路径，套上引号
    If instr(Candy_Cmd,"{File:linktarget}")
    {
        FileGetShortcut,%CandySel%,CandySel_LinkTarget
        StringReplace,Candy_Cmd,Candy_Cmd,{File:linktarget} ,%CandySel_LinkTarget%,All                      ;lnk的目标
    }
    CandyCmd_RepStr :=Object( "{File:ext}"                ,CandySel_Ext
                                                ,"{File:name}"            ,CandySel_FileNameNoExt
                                                ,"{File:parentpath}"   ,CandySel_ParentPath
                                                ,"{File:parentname}"  ,CandySel_ParentName
                                                ,"{File:Drive}"             ,CandySel_Drive
                                                ,"{File:Fullpath}"         ,CandySel
                                                ,"{Text}"                     ,CandySel)
    For k, v in CandyCmd_RepStr
        StringReplace  ,Candy_Cmd,Candy_Cmd,%k%,%v%,All
    If RegExMatch(Candy_Cmd,"i)\{.*FirstFile.*LastFile.*\}")  ;如果是文件列表，需要先整理成需要的模式
    {   ;ini里面文件列表定义：   {FirstFile LastFile}   FirstFile代表非最后一个文件，LastFile代表最后一个文件。
        CdMfile_prefix  := RegExReplace(Candy_Cmd,"i).*\{(.*?)FirstFile.*\}.*","$1")
        CdMfile_suffix  := RegExReplace(Candy_Cmd,"i).*\{.*LastFile(.*?)\}.*","$1")
        CdMfile_midfix := RegExReplace(Candy_Cmd,"i).*\{.*FirstFile(.*?)LastFile.*\}.*","$1")
        StringReplace ,CandySel_list,CandySel,`r`n,%CdMfile_midfix%,all
        CandySel_list=%CdMfile_prefix%%CandySel_list%%CdMfile_suffix%
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{.*FirstFile.*LastFile.*\}",CandySel_list)
    }
    If instr(Candy_Cmd,"{file:name:")
    {
        Candy_FileName_Coded:=
        Candy_FileName_CodeType:= RegExReplace(Candy_Cmd,"i).*\{File\:name\:(.*?)\}.*","$1")
        Candy_FileName_Coded:=SkSub_UrlEncode(CandySel_FileNameNoExt,Candy_FileName_CodeType)
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{File\:name\:(.*?)\}",Candy_FileName_Coded)
    }
    If instr(Candy_Cmd,"{text:")  ;如果是需要格式化的文本，那先格式化再替换
    {
        Candy_Text_Coded:=
        Candy_Text_CodeType:= RegExReplace(Candy_Cmd,"i).*\{Text\:(.*?)\}.*","$1")
        Candy_Text_Coded:=SkSub_UrlEncode(CandySel,Candy_Text_CodeType)
        Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{Text\:(.*?)\}",Candy_Text_Coded)
    }
    If instr(Candy_Cmd,"{mfile:")  ;多文件中，带有序号的文件
    {
        Loop,parse,CandySel,`n
            StringReplace,Candy_Cmd,Candy_Cmd,{mfile:%A_Index%},%A_loopfield%,All
    }
 /*
╔══════════════════════════════════════╗
║<<<<⑦终极运行>>>>                                                     ║
╚══════════════════════════════════════╝
*/
    Candy_All_Cmd:="web|keys|cando|cango|run|openwith|SetClipBoard|msgbox|config|openwith|ow|rund|runp"
    If Not RegExMatch(Candy_Cmd,"i)^\s*(" Candy_All_Cmd ")\s*\|")
        Candy_Cmd=OpenWith|%Candy_Cmd% ;如果没有,则人为补一个OpenWith
    Candy_Cmd:=RegExReplace(Candy_Cmd,"~\|",Chr(3))
    arrCandy_Cmd_Str:=StrSplit(Candy_Cmd,"|"," `t")
    Candy_Cmd_Str1:=arrCandy_Cmd_Str[1]
    Candy_Cmd_Str2:=RegExReplace(arrCandy_Cmd_Str[2],Chr(3),"|")
    Candy_Cmd_Str3:=RegExReplace(arrCandy_Cmd_Str[3],Chr(3),"|")
    If (Candy_Cmd_Str1="web")
    {
        SkSub_WebSearch(Candy_CurWin_Fullpath,RegExReplace(Candy_Cmd,"i)^web\|(\s+|)|\s+"))
    }
    Else If (Candy_Cmd_Str1="Keys")  ;如果是以keys|开头，则是发热键
    {
       Send %Candy_Cmd_Str2%
    }
    Else If (Candy_Cmd_Str1="MsgBox")  ;如果是以MsgBox|开头，则是发一个提示框
    {
        Gui +LastFound +OWnDialogs +AlwaysOnTop
        MsgBox %Candy_Cmd_Str2%
    }
    Else If (Candy_Cmd_Str1="Config")
    {
        for k,v in szMenuWhichfile
            Config_files .= v "`n"
        Config_files:=RemoveDuplicates(Config_files)
        Loop ,parse, Config_files,`n
            SkSub_EditConfig(Candy_Profile_Dir . "\" A_LoopField ".ini","")
        Candy_Ctrl_Regex:="i)(^\s*|\|)" CandySel_Ext "(\||\s*)[^=]*="
            SkSub_EditConfig(Candy_Profile_ini,Candy_Ctrl_Regex)
    }
    Else If (Candy_Cmd_Str1="SetClipBoard")   ;之前的开关，只能把选中的内容放进粘贴板，而这个指令，则可以把后面跟随的内容放进粘贴板。（更丰富）
    {
        Clipboard := Candy_Cmd_Str2
    }
    Else If (Candy_Cmd_Str1="Cando")  ;如果是以Cando|开头，则是运行一些内部程序，方便与你的其它脚本进行挂接
    {
        CandySelected:=CandySel    ;兼容以前的cando变量写法
        If IsLabel("Cando_" . Candy_Cmd_Str2)                       ;程序内置的别名
            Goto % "Cando_" . Candy_Cmd_Str2
        Else
            Goto Label_Candy_ErrorHandle
    }
    Else If (Candy_Cmd_Str1="Cango")   ;如果是以Cango|开头，则是运行一些外部ahk程序，方便与你的其它脚本进行挂接
    {
        IfExist,%Candy_Cmd_Str2%
            Run %ahk% "%Candy_Cmd_Str2%" "%Candy_Cmd_Str3%" ;外部的ahk代码段，你的ahk可以带参数
        Else
            Goto Label_Candy_ErrorHandle
    }
    Else If (Candy_Cmd_Str1="OpenWith" or Candy_Cmd_Str1="OW")     ;OpenWith|指定用某程序打开选定的内容，这时候，应用程序后面不能带任何命令行，（严格的说是目标参数是且仅是“被选内容“，只是被省略了）
    {
        Run ,%Candy_Cmd_Str2% "%CandySel%",%Candy_Cmd_Str3%,%Candy_Cmd_Str4% UseErrorLevel             ;1:程序  2:工作目录 3:状态
        If (ErrorLevel = "Error")               ;如果运行出错的话
            Goto Label_Candy_ErrorHandle
    }
    Else If (Candy_Cmd_Str1="Run")     ;其后面要带命令行，即使操作对象是被选中的文件，也不能省略
    {
        Run,%Candy_Cmd_Str2% ,%Candy_Cmd_Str3%,%Candy_Cmd_Str4% UseErrorLevel             ;1:程序  2:工作目录 3:状态
        If (ErrorLevel = "Error")               ;如果运行出错的话
            Goto Label_Candy_ErrorHandle
    }
    Else If (Candy_Cmd_Str1="RunD")     ;格式为RunD|应用程序|应用程序的标题|x|y|等待时间
    {       ;没发现这个x，y起作用的情况，暂时放着
        Run,%Candy_Cmd_Str2%,, UseErrorLevel
        If (ErrorLevel = "Error")               ;如果运行出错的话
            Goto Label_Candy_ErrorHandle
        else
        {
            Sleep,% (Candy_Cmd_Str4="") ? 1000 : arrCandy_Cmd_Str[6]
            WinWaitActive, %Candy_Cmd_Str3% ,,5
            WinActivate, %Candy_Cmd_Str3%
            Candy_RunD_x:=arrCandy_Cmd_Str[4] ? arrCandy_Cmd_Str[4] : 100
            Candy_RunD_y:=arrCandy_Cmd_Str[5] ? arrCandy_Cmd_Str[5] : 100
            PostMessage, 0x233, HDrop( CandySel,Candy_RunD_x,Candy_RunD_y), 0,, %Candy_Cmd_Str3%
        }
    }
    Else If (Candy_Cmd_Str1="RunP")     ;格式为RunP|应用程序|应用程序的标题|等待时间；；
    {
        Clipboard := CandySel_Rich
        Run,%Candy_Cmd_Str2%,, UseErrorLevel
        If (ErrorLevel = "Error")               ;如果运行出错的话
            Goto Label_Candy_ErrorHandle
        else
        {
            Sleep,% (Candy_Cmd_Str4="") ? 1000 : Candy_Cmd_Str4
            WinWaitActive, %Candy_Cmd_Str3% ,,5
            WinActivate, %Candy_Cmd_Str3%
            Send ^v
        }
    }
    Return
 /*
╔══════════════════════════════════════╗
║<<<<⑧出错处理>>>>                                                     ║
╚══════════════════════════════════════╝
*/
Label_Candy_ErrorHandle: ;出错啦！
	If (SkSub_IniRead(Candy_ProFile_Ini,"Candy_Settings","ShowError", 0)=1 )     ;看看出错提示开关打开了没有，打开了的话，就显示出错信息
	{
		Gui +LastFound +OwnDialogs +AlwaysOnTop
        MsgBox, 4116,, 下述命令行定义出错： `n---------------------`n%Candy_Cmd%`n---------------------`n后缀名: %CandySel_Ext%`n`n立即配置相应ini？
		IfMsgBox Yes
		{
            if (CandyError_From_Menu=1)
            {
                Candy_This_ini:=szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem]
                Candy_ctrl_ini_fullpath:=Candy_Profile_Dir . "\" . szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem] . ".ini"
                Candy_Ctrl_Regex:= "=\s*\Q" szMenuContent[ A_thisMenu "/" A_ThisMenuItem] "\E\s*$"
                SkSub_EditConfig(Candy_ctrl_ini_fullpath,Candy_Ctrl_Regex)
            }
            else
            {
                Candy_Ctrl_Regex:="i)(^\s*|\|)" CandySel_Ext "(\||\s*)[^=]*="
                SkSub_EditConfig(Candy_Profile_ini,Candy_Ctrl_Regex)
            }
		}
	}
	Return

 /*
╔══════════════════════════════════════╗
║<<<<Fuctions所用到的函数>>>>                                   ║
╚══════════════════════════════════════╝
*/
SkSub_GetMenuItem(IniDir,IniNameNoExt,Sec,TopRootMenuName,Parent="")   ;从一个ini的某个段获取条目，用于生成菜单。
{
    Items:=SkSub_IniRead_Section(IniDir "\" IniNameNoExt ".ini",sec)         ;本次菜单的发起地
    StringReplace,Items,Items,△,`t,all
    Loop,parse,Items,`n
    {
        Left:=RegExReplace(A_LoopField,"(?<=\/)\s+|\s+(?=\/)|^\s+|(|\s+)=[^!]*[^>]*")
        Right:=RegExReplace(A_LoopField,"^.*?\=\s*(.*)\s*$","$1")
        If (RegExMatch(left,"^/|//|/$|^$")) ;如果最右端是/，或者最左端是/，或者存在//，则是一个错误的定义，抛弃
            Continue
        If RegExMatch(Left,"i)(^|/)\+$")   ;如果左边的最末端是仅仅一个"独立的" + 号
        {
            m_Parent := InStr(Left,"/") > 0 ? RegExReplace(Left,"/[^/]*$") "/" : ""  ;如果+号前面有存在上级菜单,则有上级菜单，否则没有
            Right:=RegExReplace(Right,"~\|",Chr(3))
            arrRight:=StrSplit(Right,"|"," `t")
            rr1:=arrRight[1]
            rr2:=RegExReplace(arrRight[2],Chr(3),"|")
            rr3:=RegExReplace(arrRight[3],Chr(3),"|")
            rr4:=RegExReplace(arrRight[4],Chr(3),"|")
            If (rr1="Menu")   ;如果后面是“插入（子）菜单”的命令 ，则极有可能菜单里面还有“嵌套的下级菜单”。。
            {
                m_ini:= (rr2="") ? IniNameNoExt :  rr2
                m_sec:= (rr3="") ? "Menu" : rr3
				m_Parent:=Parent "" m_Parent
                this:=SkSub_GetMenuItem(IniDir,m_ini,m_sec,TopRootMenuName,m_Parent)      ;嵌套，循环使用此函数，以便处理“其他文件里的，插入的菜单”
            }
;             用+的方法，可以让你快速扩展自己定义的子菜单，否则直接可以写在左侧了。
        }
        Else
        {
            szMenuIdx.insert( Parent ""  Left )
            szMenuContent[ TopRootMenuName "/" Parent "" Left] := Right
            szMenuWhichFile[ TopRootMenuName "/" Parent "" Left] :=IniNameNoExt
        }
    }
}
SkSub_DeleteSubMenus(TopRootMenuName)
{
    For i,v in szMenuIdx
    {
        If instr(v,"/")>0
        {
            Item:=RegExReplace(v, "(.*)/.*", "$1")
            Menu,%TopRootMenuName%/%Item%,add
            Menu,%TopRootMenuName%/%Item%,DeleteAll
        }
    }
}
SkSub_CreateMenu(Item,ParentMenuName,label,IconDir,IconSize)    ;条目，它所处的父菜单名，菜单处理的目标标签
{  ;送进来的Item已经经过了“去空格处理”，放心使用
    arrS:=StrSplit(Item,"/"," `t")
    _s:=arrS[1]
    if arrS.Maxindex()= 1      ;如果里面没有 /，就是最终的”菜单项“。添加到”它的父菜单”上。
    {
        If InStr(_s,"-") = 1       ;-分割线
        Menu, %ParentMenuName%, Add
        Else If InStr(_s,"*") = 1       ;* 灰菜单
        {
            _s:=Ltrim(_s,"*")
            Menu, %ParentMenuName%, Add,       %_s%,%Label%
            Menu, %ParentMenuName%, Disable,  %_s%
        }
        Else
        {
            y:=szMenuContent[ ParentMenuName "/" Item]
            z:=SkSub_Get_MenuItem_Icon( y ,IconDir)
            Menu, %ParentMenuName%, Add,  %_s%,%Label%
            Menu, %ParentMenuName%, icon,  %_s%,%z%,,%IconSize%
        }
    }
    Else     ;如果有/，说明还不是最终的菜单项，还得一层一层分拨出来。
    {
        _Sub_ParentName=%ParentMenuName%/%_s%
        StringTrimLeft,_subItem,Item,strlen(_s)+1
        SkSub_CreateMenu(_subItem,_Sub_ParentName,label,IconDir,IconSize)
        Menu,%ParentMenuName%,add,%_s%,:%_Sub_ParentName%
    }
}
SkSub_EnvTrans(v)
{
    v:=RegExReplace(v,"~%",Chr(3))
    Transform,v,Deref,%v% ;解决Sala的ini中支持%A_desktop%或%windir%等ahk变量或系统环境变量的解释问题，@sunwind @小古
    v:=RegExReplace(v,Chr(3),"%")
    Return v
}
SkSub_Get_Firstline_Icon(ext,fullpath,iconpath)
{
	IfExist,%iconpath%\%ext%.ico             ;如果固定的文件夹里面存在该类型的图标
		x := iconpath "\" ext ".ico"
	Else If ext in  bmp,gif,png,jpg,ico,icl,exe,dll
		x := fullpath
	Else
		x:=AssocQueryApp(Ext)
	Return %x%
}
SkSub_Get_MenuItem_Icon(item,iconpath)   ; item=需要获取图标的条目，iconpath=你定义的图标库文件夹
{
	cmd:=RegExReplace(item,"^\s+|(|\s+)\|[^!]*[^>]*")
    If instr(item,"{icon:")     ; 有图标硬定义
    {
        Path_Icon:=RegExReplace(item,"i).*\{icon\:(.*?)\}.*","$1")
        If(Fileexist(Path_Icon))         ;若有全路径的图标存在
			return Path_Icon
		If(Fileexist(iconpath "\MyIcon\" Path_Icon))       ;若在MyIcon文件夹里面
			return iconpath "\MyIcon\" Path_Icon
    }
	Else if FileExist(iconpath "\Command\" cmd ".ico")      ;若存在 "命令名.ico" 文件
	{
		Return  iconpath "\Command\" cmd ".ico"
	}
	item:=SkSub_envtrans(item)
	if RegExMatch(item,"i)^(ow|openwith|rot|run|roa|runp|rund)\|") ;运行命令类
	{
		cmd_removed:=RegExReplace(item,"^.*?\|")      ;里面纯粹的 应用程序 路径
		x:=RegExReplace(cmd_removed,"i)exe[^!]*[^>]*", "exe")
		Return %x%
	}
	Else if instr(item,".exe") ;省略了指令的openwith|
	{
		x:=RegExReplace(item,"i)\.exe[^!]*[^>]*", ".exe")
		Return %x%
	}
	Else
	{
		t:=RegExReplace(item,"\s*\|.*?$")       ;去除运行参数，只保留第一个|最前面的部分
		x:=AssocQueryApp(t)
		Return %x%
	}
}
AssocQueryApp(sExt)
{
    sExt =.%sExt%  ;ASSOCSTR_EXECUTABLE
    DllCall("shlwapi.dll\AssocQueryString", "uint", 0, "uint", 2, "uint", &sExt, "uint", 0, "uint", 0, "uint*", iLength)
    VarSetCapacity(sApp, 2*iLength, 0)
    DllCall("shlwapi.dll\AssocQueryString", "uint", 0, "uint", 2, "uint", &sExt, "uint", 0, "str", sApp, "uint*", iLength)
    Return sApp
}
SkSub_Regex_IniRead(ini,sec,reg)      ;正则方式的读取，等号左侧符合正则条件
{  ;在ini的某个段内，查找符合某正则规则的字符串，并返回value值
	IniRead,keylist,%ini%,%sec%,
	Loop,Parse,keylist,`n
	{
		t:=RegExReplace(A_LoopField,"=.*?$")
		If(RegExMatch(t, reg))
		{
			Return % RegExReplace(A_LoopField,"^.*?=")
			Break
		}
	}
	Return "Error"
}
SkSub_IniRead(ini, sec, key="", default = "")   ;iniread的函数化
{
	IniRead, v, %ini%, %sec%, %key%, %default%
	Return, v
}
SkSub_IniRead_Section(ini,sec)
{  ;返回全部某段的内容，函数化而已
	IniRead,keylist,%ini%,%sec%              ;提取[sec]段里面所有的群组
		Return %keylist%
}
grep(h, n, ByRef v, s = 1, e = 0, d = "")
{
	v =
	StringReplace, h, h, %d%, , All
	Loop
		If s := RegExMatch(h, n, c, s)
			p .= d . s, s += StrLen(c), v .= d . (e ? c%e% : c)
		Else Return, SubStr(p, 2), v := SubStr(v, 2)
}
SkSub_UrlEncode(str, enc="UTF-8")
{
    enc:=trim(enc)
    If enc=
        Return str
   hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
   VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
   While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
   encoded .= hex
   Return encoded
}
SkSub_WebSearch(Win_Full_Path,Http)
{
	all_browser:=SkSub_IniRead(GeneralSettings_ini, "General_Settings", "InUse_Browser")
	DefaultBrowser:=SkSub_EnvTrans(SkSub_IniRead(GeneralSettings_ini, "General_Settings", "Default_Browser"))
	;第①步，看当前当前激活窗口 是否 浏览器
	If Win_Full_Path Contains %All_Browser%
	{
		Browser:=Win_Full_Path
	}
	;第②步，看进程里面有没有浏览器，若有，看能被提取出来（防止虚拟桌面的隔离，妖自己的需求）
	Else Loop,Parse,All_Browser,`,   ;看所有定义的浏览器，
	{
		Useful_FullPath:=SkSub_process_exist_and_useful(A_LoopField)
		If (  Useful_FullPath!= 0  and Useful_FullPath!= 1 )
		{
			Browser:=Useful_FullPath
			Break
		}
	}
	; 第③步	，都没有么，看ini默认浏览器是否符合条件
	If ( Browser="")  ;看ini默认浏览器，a。看进程中是否有，并且能被提取出来（防止虚拟桌面的隔离，妖自己的需求）。b。或者进程里面没有。
	{
		DefaultBrowser_去除参数:= RegExReplace(DefaultBrowser, "exe[^!]*[^>]*", "exe")
		SplitPath ,DefaultBrowser_去除参数,DefaultBrowser_name
		Useful_FullPath:=SkSub_process_exist_and_useful(DefaultBrowser_name)
		If (  Useful_FullPath!= 0  And FileExist(DefaultBrowser_去除参数))
		{
			Browser:=DefaultBrowser
		}
	}
	; 第④部，最终运行
	If Browser ;如果取到了浏览器
	{
		SplitPath,browser,,,,browser_namenoext
        Browser_Args:=SkSub_IniRead(GeneralSettings_ini, "WebBrowser's_CommandLIne", browser_namenoext)
		If (Browser_Args!="Error")  ;有些浏览器，必须带参数,比如config或者单进程限制等待，所以在ini里面提供了一个定义的地方。
		{
			Browser := Browser " " Browser_Args
		}
		Run,% Browser . " """ . Http . """"
		IfInString Browser,firefox.exe
			WinActivate,Mozilla Firefox Ahk_Class MozillaWindowClass
		Else
			WinActivate Ahk_PID %ErrorLevel%
	}
	Else ;没有浏览器么
	{  ;看注册表 是否有默认的浏览器
		RegRead, RegDefaultBrowser, HKEY_CLASSES_ROOT, http\shell\open\command
		StringReplace, RegDefaultBrowser, RegDefaultBrowser,"
		SplitPath, RegDefaultBrowser,,RDB_Dir,,RDB_NameNoExt,
		Run,% RDB_Dir . "\" . RDB_NameNoExt . ".exe" . " """ . Http . """",,UseErrorLevel
		If errorlevel
		{
			Run,% "iexplore.exe " . site . """"	  ;internet explorer
		}
	}
}
;============================================================================================================
SkSub_process_exist_and_useful(Process_name)        ;判断某个进程是否存在且能有效运行，如果不用desktops，这段代码可以清除掉。
{
	Process,exist,%Process_name%
	WinGet, Process_Fullpath,ProcessPath,Ahk_PID %ErrorLevel%
	If (ErrorLevel!=0 And  Process_Fullpath!="")
		Return %Process_Fullpath%
	Else if ErrorLevel=0
		Return 1
	Else
		Return 0
}
HDrop(fnames,x=0,y=0)
{
	characterSize := A_IsUnicode ? 2 : 1
	fns:=RegExReplace(fnames,"\n$")
	fns:=RegExReplace(fns,"^\n")
	hDrop:=DllCall("GlobalAlloc","UInt",0x42,"UInt",20+(StrLen(fns)*characterSize)+characterSize*2)
	p:=DllCall("GlobalLock","UInt",hDrop)
	NumPut(20, p+0)  ;offset
	NumPut(x,  p+4)  ;pt.x
	NumPut(y,  p+8)  ;pt.y
	NumPut(0,  p+12) ;fNC
	NumPut(A_IsUnicode ? 1 : 0,  p+16) ;fWide
	p2:=p+20
	Loop,Parse,fns,`n,`r
	{
		DllCall("RtlMoveMemory","UInt",p2,"Str",A_LoopField,"UInt",StrLen(A_LoopField)*characterSize)
		p2+=StrLen(A_LoopField)*characterSize + characterSize
	}
	DllCall("GlobalUnlock","UInt",hDrop)
	Return hDrop
}
SkSub_EditConfig(inifile,regex="") ;编辑配置文件！
{
	if not fileExist(inifile)      ;动态菜单未必有ini文件存在
		return
	if (regex<>"")  ;如果送了正则表达式进来
	{
		Loop
		{
			FileReadLine, L, %inifile%, %A_Index%
			if ErrorLevel
				break
			if regexmatch(L,regex)
			{
				LineNo:=a_index
				break
			}
		}
	}
	TextEditor:=SkSub_EnvTrans(SkSub_IniRead(GeneralSettings_ini, "General_Settings", "Default_TextEditor"))  ;默认文本编辑器
	TextEditor:=FileExist(TextEditor) ? TextEditor:"notepad.exe"       ;文本编辑器
	SplitPath,TextEditor,,,,namenoext
	LineJumpArgs:=SkSub_IniRead(GeneralSettings_ini, "TextEditor's_CommandLine", namenoext)
	if  (LineJumpArgs="Error" or LineNo="" )
		cmd :=TextEditor " " inifile
	else
	{
		cmd :=TextEditor " " LineJumpArgs
		StringReplace,cmd,cmd,$(FILEPATH),%inifile%
		StringReplace,cmd,cmd,$(LINENUM),%LineNo%
	}
	Run,%cmd%,,UseErrorLevel,TextEditor_PID
	WinActivate ahk_pid %TextEditor_PID%
	return
}

SkSub_Clear_CandyVar()
{
	Global
    CandySel:=
    CandySel_LinkTarget:=
    CandySel_Ext:=
    CandySel_FileNamenoExt:=
    CandySel_ParentPath:=
    CandySel_ParentName:=
    CandySel_Drive:=
	Config_files:=
	CandyError_From_Menu:=0
}

RemoveDuplicates(Str, Delimiter="`n")
{
        Str_sort :=	Str
        Sort, Str_sort, U
        Loop, parse, Str_sort, `n, `r
        {
            Str_m :=	"`am)^" A_LoopField "$"
            Str :=	RegExReplace(Str,Str_m,"","",-1,RegExMatch(Str,Str_m)+StrLen(A_LoopField))
        }
        return %	Trim(RegExReplace(Str,"\v+","`n"))
}
 /*
╔══════════════════════════════════════╗
║<<<<托盘菜单处理部分>>>>                                           ║
╚══════════════════════════════════════╝
*/
SkSub_CreatTrayMenu()
{
  ;Menu, Tray, Icon,candy.ico
  Menu, Tray, NoStandard        ;自定义菜单放在标准菜单上面
  Menu, tray, add, 关于与提示,TrayHandle_About
  Menu, tray, add ; 分隔符
  Menu, tray, add, 编辑全局配置,TrayHandle_GeneralSettings
  Menu, tray, add, 重启脚本,TrayHandle_ReLoad
  Menu, tray, add ; 分隔符
  IniRead,Ky_RunWithSystem,ini\GeneralSettings.ini, Ky_Settings, RunWithSystem,0   ;读取Ky变量，是否随系统启动
  menu,tray,add, 随系统启动,TrayHandle_RunWithSystem
  if (Ky_RunWithSystem)
        menu,tray,Check ,随系统启动
    else 
        menu,tray,UnCheck, 随系统启动
  Menu, tray, add ; 分隔符
  Menu, tray, add, 退出,TrayHandle_Exit
}
/*
╔══════════════════════════════════════╗
║<<<<托盘菜单处理部分>>>>                                           ║
╚══════════════════════════════════════╝
*/
TrayHandle_ReLoad:
  Reload
Return
TrayHandle_Exit:
  ExitApp
Return

TrayHandle_GeneralSettings:
    SkSub_EditConfig(GeneralSettings_ini,"")
    return

TrayHandle_RunWithSystem:
if (Ky_RunWithSystem)
  {
        ;menu,tray,unCheck ,随系统启动
        IniWrite,0,ini\GeneralSettings.ini, Ky_Settings, RunWithSystem      ;改成不随启动，0
        RegDelete,HKEY_LOCAL_MACHINE,Software\Microsoft\Windows\CurrentVersion\Run,Candy
        Reload
    } else {
         ;menu,tray,Check, 随系统启动
         IniWrite,1,ini\GeneralSettings.ini, Ky_Settings, RunWithSystem      ;改成随启动，1
         regwrite,REG_SZ,HKEY_LOCAL_MACHINE,Software\Microsoft\Windows\CurrentVersion\Run,Candy,%A_ScriptFullPath%
         Reload
    }
return

TrayHandle_About:
  MsgBox, , About Candy,
  ( LTrim
    版本：Candy2.0.0.6
    作者：Kawvin(QQ:2857814247)
    改自：万年书妖
  )
  Return
;==============================================================================
;我定义的快捷键
;=======================================================
;以下设置双击PageUp静音
$PGUP::
  if MyDefKey2_presses > 0 ; SetTimer 已经启动，所以我们记录按键。
  {
    MyDefKey2_presses += 1
    return
  }
  ;否则，这是新一系列按键的首次按键。将计数设为 1 并启动定时器：
  MyDefKey2_presses = 1
  SetTimer, KeyDef2, 400 ;在 400 毫秒内等待更多的按键。
  return

KeyDef2:
  SetTimer, KeyDef2, off
  if MyDefKey2_presses = 1 ;该键已按过一次。
  {
    send {PGUP}
  }
  else if MyDefKey2_presses = 2 ;该键已按过两次。
  {
    send,{Volume_Mute}
  }
  MyDefKey2_presses = 0
  return
  
;~ ScrollLock::	;静音
    ;~ send,{Volume_Mute}
    ;~ return
;~ ;========================
!PGDN::	;音量-(Alt+-)
    send,{Volume_Down}
    soundget,CurVol
    CurVol:=round(CurVol)
    Progress, b w500 fs18,当前音量：%CurVol%,, 音量调节 
    Progress, %CurVol% ; 设置进度条的位置 
    Sleep, 150 
    Progress, Off 
    return
;========================
!PGUP::	;音量+(Alt+=)
    send,{Volume_Up}
    soundget,CurVol
    CurVol:=round(CurVol)
    Progress, b w500 fs18,当前音量：%CurVol%,, 音量调节 
    Progress, %CurVol% ; 设置进度条的位置 
    Sleep, 150 
    Progress, Off 
    return



;==============================================================================
;cando脚本
;=======================================================
;cando_脚本编译:
;run,%ahk2exe% /in %CandySel% /icon D:\KawvinApps\Candy\candy.ico
;return
;=======================================================
cando_收集到MLO:       ;长文本/短文件
    IfNotExist ahk_class  TfrmMyLifeMain ;判断某进程是否存在
    {
        Run,%mlo%,, useerrorlevel
        ;WinActivate,ahk_exe mlo.exe  ;等待某进程出现
        sleep,1000
        WinWait ,ahk_class TfrmMyLifeMain  ;等待某进程出现
    }
    Candy_Saved_ClipBoard:=ClipboardAll
    Clipboard:=CandySel
    send,^+m    ;新建任务窗口
    winwait,ahk_class TfrmQuickAddMLOTask  ;等待新建任务进程
    sleep,500
    send,^v ;       ；添加任务
    sleep,300
    send,^{enter}   ;添加任务
    sleep,300
    send,!{F4}           ;关闭任务窗口
    Clipboard := Candy_Saved_ClipBoard  ;还原粘贴板
    return
;=======================================================
cando_直接发送到印象笔记:    ;长文本/短文件
    IfNotExist ahk_class ENMainFrame ;判断某进程是否存在
    {
        Run,%EverNote%,, useerrorlevel
        WinWait ,ahk_class ENMainFrame ;等待某进程出现
    }
    Candy_Saved_ClipBoard:=ClipboardAll
    Clipboard:=CandySel
    send,^!v    ;ctrl+alt+v,印象笔记粘贴快捷键
    Clipboard := Candy_Saved_ClipBoard  ;还原粘贴板
    return
;=======================================================
cando_邮件发送到印象笔记:    ;长文本/短文件
    MyFun_SendEmailToEnverNote(CandySel,CandySel)
    return
;=======================================================
;我的函数-发送邮件到印象笔记
MyFun_SendEmailToEnverNote(MySubject,MyHtmlbody)
{
    NameSpace := "http://schemas.microsoft.com/cdo/configuration/"
    Email := ComObjCreate("CDO.Message")
    Email.From := "xxxx@sina.com"
    Email.To := "xxxx@m.yinxiang.com"
    Email.Subject := MySubject
    Email.Htmlbody := MyHtmlbody
    ;Email.AddAttachment("C:\foo.zip")
    Email.Configuration.Fields.Item(NameSpace "sendusing") := 2
    Email.Configuration.Fields.Item(NameSpace "smtpserver") := "smtp.sina.com" ;SMTP服务器地址
    Email.Configuration.Fields.Item(NameSpace "smtpserverport") := 25
    Email.Configuration.Fields.Item(NameSpace "smtpauthenticate") := 1
    Email.Configuration.Fields.Item(NameSpace "sendusername") := "xxxx@sina.com" ;邮箱账号
    Email.Configuration.Fields.Item(NameSpace "sendpassword") := "xxxx" ;邮箱密码
    Email.Configuration.Fields.update
    Email.Send
    return
}

;=======================================================
cando_创建投标项目投标目录:   ;文件/文件夹/多文件
    FileCreateDir %CandySel%\00－原始招标文件
    FileCreateDir %CandySel%\00－原始招标文件\%a_yyyy%%a_mm%%a_dd%招标文件
    ;FileCreateDir %CandySel%\00－原始招标文件\2015xxxx补遗文件1
    FileCreateDir %CandySel%\01－解压招标文件
    FileCreateDir %CandySel%\02－材料询价表
    FileCreateDir %CandySel%\03－投标质疑文件
    FileCreateDir %CandySel%\04－预算成本文件
    FileCreateDir %CandySel%\04－预算成本文件\%a_yyyy%%a_mm%%a_dd%第1次报价文件
    ;FileCreateDir %CandySel%\04－预算成本文件\2015xxxx第N次报价文件(最终版)
    FileCreateDir %CandySel%\05－投标文件
    FileCreateDir %CandySel%\05－投标文件\00－封面及封袋
    FileCreateDir %CandySel%\05－投标文件\00－封面及封袋\01－封面
    FileCreateDir %CandySel%\05－投标文件\00－封面及封袋\02－内封袋
    FileCreateDir %CandySel%\05－投标文件\00－封面及封袋\03－外封袋
    FileCreateDir %CandySel%\05－投标文件\01－投标函（资信标、资格预审、资格后审）
    FileCreateDir %CandySel%\05－投标文件\02－商务标
    FileCreateDir %CandySel%\05－投标文件\03－技术标
    FileCreateDir %CandySel%\05－投标文件\04－材料样板
    FileCreateDir %CandySel%\05－投标文件\成品－打印版文件
    FileCreateDir %CandySel%\05－投标文件\成品－电子光盘
    Return

;=======================================================
cando_以当前日期－剪贴板内容创建目录:  ;文件/文件夹/多文件;右键菜单
    CurDir=%a_yyyy%%a_mm%%a_dd%－%Clipboard%
    if CandySel_Ext=RightMenu
        FileCreateDir %CandySel%\%CurDir%
    else
        FileCreateDir %CandySel_ParentPath%\%CurDir%
    return
;=======================================================
cando_以剪贴板内容创建目录:   ;文件/文件夹/多文件;右键菜单
    CurDir=%Clipboard%
    if CandySel_Ext=RightMenu
        FileCreateDir %CandySel%\%CurDir%
    else
        FileCreateDir %CandySel_ParentPath%\%CurDir%
    return
;=======================================================
cando_以剪贴板内容重命名文件夹: ;文件夹
    CurDir=%Clipboard%
    SplitPath,CandySel,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt,MyOutDrive
    MyNewFile =%MyOutDir%\%Clipboard%
    FileMovedir,%CandySel%,%MyNewFile%
    return
;=======================================================
cando_以剪贴板内容重命名文件:   ;文件
    MyCopyName=%Clipboard%
    MyTemFile := RegExReplace(candysel,"(.*)\r.*","$1")
    SplitPath ,MyTemFile,,,MyExt,MyNameNoExt
    MyNewFile =%CandySel_ParentPath%\%MyCopyName%.%MyExt%
    FileMove,%MyTemFile%,%MyNewFile%
    return
;=======================================================
cando_交换文件名:    ;多文件
    SplitPath ,CandySel_FirstFile,,CandySel_ParentPath,,  ;以第一行的父目录为“多文件的父目录”
    ArrayCount=0
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        ArrayCount += 1  ;记录在数组中有多少个项目。
        Array%ArrayCount% := RegExReplace(A_loopfield,"(.*)\r.*","$1")
    }
    SplitPath ,Array1,,,MyExt1,MyNameNoExt1
    SplitPath ,Array2,,,MyExt2,MyNameNoExt2
    MyTem=%CandySel_ParentPath%\Tem.%MyExt1%
    MyNew1=%CandySel_ParentPath%\%MyNameNoExt2%.%MyExt1%
    MyNew2=%CandySel_ParentPath%\%MyNameNoExt1%.%MyExt2%

    FileMove,%Array1%,%MyTem%
    FileMove,%Array2%,%MyNew2%
    FileMove,%MyTem%,%MyNew1%
    return
;=======================================================
cando_文件名前添加输入内容:   ;文件/文件夹/多文件
    Inputbox, MyInsert, 提示,请输入要添加的内容 
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt,MyOutDrive
        If InStr(FileExist(MyTemFile), "D")
        {
            MyNewFile =%MyOutDir%\%MyInsert%%MyOutNameNoExt%
            FileMovedir,%MyTemFile%,%MyNewFile%
        } else {
            MyNewFile =%MyOutDir%\%MyInsert%%MyOutNameNoExt%.%MyOutExt%
            FileMove,%MyTemFile%,%MyNewFile%
        }
    }
    return
;=======================================================
cando_文件名后添加输入内容:   ;文件/文件夹/多文件
    Inputbox, MyInsert, 提示,请输入要添加的内容
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt,MyOutDrive
        If InStr(FileExist(MyTemFile), "D")
        {
            MyNewFile =%MyOutDir%\%MyOutNameNoExt%%MyInsert%
            FileMovedir,%MyTemFile%,%MyNewFile%
        } else {
            MyNewFile =%MyOutDir%\%MyOutNameNoExt%%MyInsert%.%MyOutExt%
            FileMove,%MyTemFile%,%MyNewFile%
        }
    }
    return
;=======================================================
cando_文件名前添加当前日期:   ;文件/文件夹/多文件
    CurDate=%a_yyyy%%a_mm%%a_dd%-
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt,MyOutDrive
        If InStr(FileExist(MyTemFile), "D")
        {
            MyNewFile =%MyOutDir%\%CurDate%%MyOutNameNoExt%
            FileMovedir,%MyTemFile%,%MyNewFile%
        } else {
            MyNewFile =%MyOutDir%\%CurDate%%MyOutNameNoExt%.%MyOutExt%
            FileMove,%MyTemFile%,%MyNewFile%
        }
    }
    return
;=======================================================
cando_文件名后添加当前日期:   ;文件/文件夹/多文件
    CurDate=-%a_yyyy%%a_mm%%a_dd%
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt,MyOutDrive
        If InStr(FileExist(MyTemFile), "D")
        {
            MyNewFile =%MyOutDir%\%MyOutNameNoExt%%CurDate%
            FileMovedir,%MyTemFile%,%MyNewFile%
        } else {
            MyNewFile =%MyOutDir%\%MyOutNameNoExt%%CurDate%.%MyOutExt%
            FileMove,%MyTemFile%,%MyNewFile%
        }
    }
;=======================================================
cando_删除文件后缀:   ;文件/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")
            continue
        SplitPath ,MyTemFile,,,MyExt,MyNameNoExt
        MyNewFile =%CandySel_ParentPath%\%MyNameNoExt%
        FileMove,%MyTemFile%,%MyNewFile%
    }
    return
;=======================================================
cando_添加文件后缀为输入内容:  ;文件/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")
            continue
        SplitPath ,MyTemFile,,,MyExt,MyNameNoExt
        Inputbox, MyNewExt, 提示,请输入新的后缀名 
        if MyNewExt="" 
        return
        MyNewFile =%CandySel_ParentPath%\%MyNameNoExt%.%MyExt%.%MyNewExt%
        FileMove,%MyTemFile%,%MyNewFile%
    }
    return
;=======================================================
cando_修改文件后缀为ZIP:   ;文件/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")
            continue
        SplitPath ,MyTemFile,,,MyExt,MyNameNoExt
        MyNewFile =%CandySel_ParentPath%\%MyNameNoExt%.zip
        FileMove,%MyTemFile%,%MyNewFile%
    }
    return
;=======================================================
cando_修改文件后缀为RAR:   ;文件/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")
            continue
        SplitPath ,MyTemFile,,,MyExt,MyNameNoExt
        MyNewFile =%CandySel_ParentPath%\%MyNameNoExt%.rar
        FileMove,%MyTemFile%,%MyNewFile%
    }
    return
;=======================================================
cando_修改文件后缀为输入内容:   ;文件/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")
            continue
        SplitPath ,MyTemFile,,,MyExt,MyNameNoExt
        Inputbox, MyNewExt, 提示,请输入新的后缀名 
        if MyNewExt="" 
        return
        MyNewFile =%CandySel_ParentPath%\%MyNameNoExt%.%MyNewExt%
        FileMove,%MyTemFile%,%MyNewFile%
    }
    return
;=======================================================
cando_复制移动到:   ;文件/文件夹/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath,MyTemFile, SourceFolderName ; 仅从它的完全路径提取文件夹名称。
        If InStr(FileExist(MyTemFile), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
        {
            if Ky_ShiftIsPressed=
                FileCopyDir, %MyTemFile%, %A_ThisMenuItem%\%SourceFolderName%、
            else
                FilemoveDir, %MyTemFile%, %A_ThisMenuItem%\%SourceFolderName%
        } Else  {
            if Ky_ShiftIsPressed=
                filecopy,%MyTemFile%,%A_ThisMenuItem%
            else
                filemove,%MyTemFile%,%A_ThisMenuItem%
        }
    }
    Ky_ShiftIsPressed:=
    return
;=======================================================
cando_移动到上级文件夹:  ;文件/文件夹/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
            {
               splitpath,MyTemFile,SourceFolderName ,MyParentDir ; 提取当前文件的所在文件夹名称。
               splitpath,MyParentDir, ,MyParentDir ; 提取当前文件的所在文件夹的父文件夹名称。
               run,%Unlocker% %MyTemFile%
               FilemoveDir, %MyTemFile%, %MyParentDir%\%SourceFolderName%
            }
            Else 
            {
                splitpath,MyTemFile, ,MyParentDir ; 提取当前文件的所在文件夹名称。
                splitpath,MyParentDir, ,MyParentDir ; 提取当前文件的所在文件夹的父文件夹名称。
                run,%Unlocker% %MyTemFile%
                filemove,%MyTemFile%,%MyParentDir%
            }
    }
    return
;=======================================================
cando_名称前删除首字母:  ;文件/文件夹/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath ,MyTemFile,MyFileName,MyDir,MyExt,MyNameNoExt
        MyFileName:=substr(MyFileName,2,255)
        MyNewName=%MyDir%\%MyFileName%
        If InStr(FileExist(MyTemFile), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
            FilemoveDir, %MyTemFile%, %MyNewName%
        else 
            FileMove,%MyTemFile%,%MyNewName%
    }
    return
;=======================================================
cando_名称前添加首字母:  ;文件/文件夹/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        SplitPath ,MyTemFile,MyFileName,MyDir,MyExt,MyNameNoExt
        MyNameNoExt:=substr(MyNameNoExt,1,1)
        MyFirstLetter:=MyFun_GetFL(MyNameNoExt)
        IF MyFirstLetter!=
        {
            MyNewName=%MyDir%\%MyFirstLetter%%MyFileName%
            If InStr(FileExist(MyTemFile), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
                FilemoveDir, %MyTemFile%, %MyNewName%
            else 
                FileMove,%MyTemFile%,%MyNewName%
        }
    }
    return
;=======================================================
cando_名称前添加首字母含子文件:  ;文件/文件夹/多文件
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If InStr(FileExist(MyTemFile), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
        {
            MySub_AddFL(MyTemFile)
        }
        Else 
        {
            SplitPath ,MyTemFile,MyFileName,MyDir,MyExt,MyNameNoExt
            MyNameNoExt:=substr(MyNameNoExt,1,1)
            MyFirstLetter:=MyFun_GetFL(MyNameNoExt)
            IF MyFirstLetter !=
            {
                MyNewName=%MyDir%\%MyFirstLetter%%MyFileName%
                FileMove,%MyTemFile%,%MyNewName%
            }
        }
    }
    return
;======================================================
;过程：文件夹下添加首字母
MySub_AddFL(MyPath)
{
    If InStr(FileExist(MyPath), "D")  ;区分是否文件夹,Attrib= D ,则是文件夹
    {
        DirList=
        loop,%MyPath%\*.*,2,1   ;遍历子文件夹
            DirList=%DirList%%A_LoopFileFullPath%`n ;生成子文件夹列表
        Loop,parse,DirList,`n
        {
            MyDirVar:=A_LoopField
            if MyDirVar !=
                MySub_AddFL(MyDirVar)   ;如果不为空，再次遍历子文件夹
         }
        
         FileList=
        loop,%MyPath%\*.*,0   ;遍历文件夹下的文件
            FileList=%FileList%%A_LoopFileFullPath%`n   ; 生成文件夹下的文件列表
        loop,parse,FileList,`n
        {
            MyListVar:=A_LoopField
            if MyListVar!=
            {
                SplitPath ,MyListVar,MyFileName,MyDir,MyExt,MyNameNoExt
                MyNameNoExt:=substr(MyNameNoExt,1,1)
                MyFirstLetter:=MyFun_GetFL(MyNameNoExt)
                IF MyFirstLetter !=
                {
                    MyNewName=%MyDir%\%MyFirstLetter%%MyFileName%
                    FileMove,%MyListVar%,%MyNewName%
                }
            }
        }   
        SplitPath ,MyPath,MyFileName,MyDir,MyExt,MyNameNoExt
        MyNameNoExt:=substr(MyNameNoExt,1,1)
        MyFirstLetter:=MyFun_GetFL(MyNameNoExt)
        IF MyFirstLetter !=
        {
            MyNewName=%MyDir%\%MyFirstLetter%%MyFileName%
            FilemoveDir, %MyPath%, %MyNewName%
        }
    }
}
;======================================================
;函数：获取字符串的中文首字母
MyFun_GetFL(MyHZ)
{
    MyFLA1=吖阿啊锕嗄哎哀唉埃挨锿捱皑癌嗳矮蔼霭艾爱砹隘嗌嫒碍暧瑷安桉氨庵谙鹌鞍俺埯铵揞犴岸按案胺暗黯肮昂盎凹坳敖嗷廒獒遨熬翱聱螯鳌鏖拗袄媪岙傲奥骜澳懊
   
   MyFLB1=巴叭扒吧岜芭疤捌笆粑拔茇菝跋魃把钯靶坝爸罢鲅霸灞掰白百佰柏捭摆呗败拜稗扳班般颁斑搬瘢癍阪坂板版钣舨办半伴扮拌绊瓣邦帮梆浜绑榜膀蚌傍棒谤蒡磅镑包孢苞胞煲龅褒雹宝饱保鸨堡葆褓报抱豹趵鲍暴爆陂卑杯悲碑鹎北贝狈邶备背钡倍悖被惫焙辈碚蓓褙鞴鐾奔贲锛本苯畚坌笨崩绷嘣甭泵迸甏蹦逼荸鼻匕比吡妣彼秕俾笔舭鄙币必毕闭庇畀哔毖荜陛毙狴铋婢庳敝萆弼愎筚滗痹蓖裨跸辟弊碧箅蔽壁嬖篦薜避濞臂髀璧襞边砭笾编煸蝙鳊鞭贬扁窆匾碥褊卞
   MyFLB2=弁忭汴苄拚便变缏遍辨辩辫杓彪标飑髟骠膘瘭镖飙飚镳表婊裱鳔憋鳖别蹩瘪宾彬傧斌滨缤槟镔濒豳摈殡膑髌鬓冰兵丙邴秉柄炳饼禀并病摒拨波玻剥钵饽啵脖菠播伯孛驳帛泊勃亳钹铂舶博渤鹁搏箔膊踣薄礴跛簸擘檗逋钸晡醭卜卟补哺捕不布步怖钚部埠瓿簿
   
    MyFLC1=嚓擦礤猜才材财裁采彩睬踩菜蔡参骖餐残蚕惭惨黪灿粲璨仓伧沧苍舱藏操糙曹嘈漕槽艚螬草册侧厕恻测策岑涔噌层蹭叉杈插馇锸查茬茶搽猹槎察碴檫衩镲汊岔诧姹差拆钗侪柴豺虿瘥觇掺搀婵谗孱禅馋缠蝉廛潺镡蟾躔产谄铲阐蒇冁忏颤羼伥昌娼猖菖阊鲳长肠苌尝偿常徜嫦厂场昶惝敞氅怅畅倡鬯唱抄怊钞焯超晁巢朝嘲潮吵炒耖车砗扯彻坼掣撤澈抻郴琛嗔尘臣忱沉辰陈宸晨谌碜闯衬称龀趁榇谶柽蛏铛撑瞠丞成呈承枨诚城乘埕铖惩程裎塍酲澄橙逞骋秤吃哧蚩鸱
    MyFLC2=眵笞嗤媸痴螭魑弛池驰迟茌持匙墀踟篪尺侈齿耻豉褫叱斥赤饬炽翅敕啻傺瘛充冲忡茺舂憧艟虫崇宠铳抽瘳仇俦帱惆绸畴愁稠筹酬踌雠丑瞅臭出初樗刍除厨滁锄蜍雏橱躇蹰杵础储楮楚褚处怵绌搐触憷黜矗搋揣啜嘬踹川氚穿传舡船遄椽舛喘串钏囱疮窗床创怆吹炊垂陲捶棰槌锤春椿蝽纯唇莼淳鹑醇蠢踔戳绰辍龊呲疵词祠茈茨瓷慈辞磁雌鹚糍此次刺赐从匆苁枞葱骢璁聪丛淙琮凑楱腠辏粗徂殂促猝酢蔟醋簇蹙蹴汆撺镩蹿窜篡爨崔催摧榱璀脆啐悴淬萃毳瘁粹翠村皴存忖寸搓磋撮蹉嵯痤矬鹾脞厝挫措锉错
        
    MyFLD1=哒耷搭嗒褡达妲怛沓笪答瘩靼鞑打大呆呔歹傣代岱甙绐迨带待怠殆玳贷埭袋逮戴黛丹单担眈耽郸聃殚瘅箪儋胆疸掸旦但诞啖弹惮淡萏蛋氮澹当裆挡党谠凼宕砀荡档菪刀叨忉氘导岛倒捣祷蹈到悼焘盗道稻纛得锝德的灯登噔簦蹬等戥邓凳嶝瞪磴镫低羝堤嘀滴镝狄籴迪敌涤荻笛觌嫡氐诋邸坻底抵柢砥骶地弟帝娣递第谛棣睇缔蒂碲嗲掂滇颠巅癫典点碘踮电佃甸阽坫店垫玷钿惦淀奠殿靛癜簟刁叼凋貂碉雕鲷吊钓调掉铞爹跌迭垤瓞谍喋堞揲耋叠牒碟蝶蹀鲽丁仃叮玎
    MyFLD2=疔盯钉耵酊顶鼎订定啶腚碇锭丢铥东冬咚岽氡鸫董懂动冻侗垌峒恫栋洞胨胴硐都兜蔸篼斗抖钭陡蚪豆逗痘窦嘟督毒读渎椟牍犊黩髑独笃堵赌睹芏妒杜肚度渡镀蠹端短段断缎椴煅锻簖堆队对兑怼碓憝镦吨敦墩礅蹲盹趸囤沌炖盾砘钝顿遁多咄哆裰夺铎掇踱朵哚垛缍躲剁沲堕舵惰跺
    
    MyFLE1=屙讹俄娥峨莪锇鹅蛾额婀厄呃扼苊轭垩恶饿谔鄂阏愕萼遏腭锷鹗颚噩鳄恩蒽摁儿而鸸鲕尔耳迩洱饵珥铒二佴贰
    
    MyFLF1=发乏伐垡罚阀筏法砝珐帆番幡翻藩凡矾钒烦樊蕃燔繁蹯蘩反返犯泛饭范贩畈梵方邡坊芳枋钫防妨房肪鲂仿访彷纺舫放飞妃非啡绯菲扉蜚霏鲱肥淝腓匪诽悱斐榧翡篚吠废沸狒肺费痱镄分吩纷芬氛玢酚坟汾棼焚鼢粉份奋忿偾愤粪鲼瀵丰风沣枫封疯砜峰烽葑锋蜂酆冯逢缝讽唪凤奉俸佛缶否夫呋肤趺麸稃跗孵敷弗伏凫孚扶芙芾怫拂服绂绋苻俘氟祓罘茯郛浮砩莩蚨匐桴涪符艴菔袱幅福蜉辐幞蝠黻呒抚甫府拊斧俯釜脯辅腑滏腐黼父讣付妇负附咐阜驸复赴副傅富赋缚腹鲋赙蝮鳆覆馥
    
    MyFLG1=旮伽钆尜嘎噶尕尬该陔垓赅改丐钙盖溉戤概干甘杆肝坩泔苷柑竿疳酐尴秆赶敢感澉橄擀旰矸绀淦赣冈刚岗纲肛缸钢罡港杠筻戆皋羔高槔睾膏篙糕杲搞缟槁稿镐藁告诰郜锆戈圪纥疙哥胳袼鸽割搁歌阁革格鬲葛蛤隔嗝塥搿膈镉骼哿舸个各虼硌铬给根跟哏亘艮茛更庚耕赓羹哽埂绠耿梗鲠工弓公功攻供肱宫恭蚣躬龚觥巩汞拱珙共贡勾佝沟钩缑篝鞲岣狗苟枸笱构诟购垢够媾彀遘觏估咕姑孤沽轱鸪菇菰蛄觚辜酤毂箍鹘古汩诂谷股牯骨罟钴蛊鹄鼓嘏臌瞽固故顾崮梏牿
    MyFLG2=雇痼锢鲴瓜刮胍鸹呱剐寡卦诖挂褂乖拐怪关观官冠倌棺鳏馆管贯惯掼涫盥灌鹳罐光咣桄胱广犷逛归圭妫龟规皈闺硅瑰鲑宄轨庋匦诡癸鬼晷簋刽刿柜炅贵桂跪鳜衮绲辊滚磙鲧棍呙埚郭崞聒锅蝈国帼掴虢馘果猓椁蜾裹过
    
    MyFLH1=铪哈嗨孩骸海胲醢亥骇害氦顸蚶酣憨鼾邗含邯函晗涵焓寒韩罕喊汉汗旱悍捍焊菡颔撖憾撼翰瀚夯杭绗航颃沆蒿嚆薅蚝毫嗥豪嚎壕濠好郝号昊浩耗皓颢灏诃呵喝嗬禾合何劾和河曷阂核盍荷涸盒菏蚵颌貉阖翮贺褐赫鹤壑黑嘿痕很狠恨亨哼恒桁珩横衡蘅轰哄訇烘薨弘红宏闳泓洪荭虹鸿蕻黉讧侯喉猴瘊篌糇骺吼后厚後逅候堠鲎乎呼忽烀轷唿惚滹囫弧狐胡壶斛湖猢葫煳瑚鹕槲糊蝴醐觳虎浒唬琥互户冱护沪岵怙戽祜笏扈瓠鹱花华哗骅铧滑猾化划画话桦怀徊淮槐踝坏
    MyFLH2=欢獾还环郇洹桓萑锾寰缳鬟缓幻奂宦唤换浣涣患焕逭痪豢漶鲩擐肓荒慌皇凰隍黄徨惶湟遑煌潢璜篁蝗癀磺簧蟥鳇恍晃谎幌灰诙咴恢挥虺晖珲辉麾徽隳回洄茴蛔悔卉汇会讳哕浍绘荟诲恚桧烩贿彗晦秽喙惠缋毁慧蕙蟪昏荤婚阍浑馄魂诨混溷耠锪劐豁攉活火伙钬夥或货获祸惑霍镬嚯藿蠖
    
    MyFLJ1=讥击叽饥乩圾机玑肌芨矶鸡咭迹剞唧姬屐积笄基绩嵇犄缉赍畸跻箕畿稽齑墼激羁及吉岌汲级即极亟佶急笈疾戢棘殛集嫉楫蒺辑瘠蕺籍几己虮挤脊掎戟嵴麂计记伎纪妓忌技芰际剂季哜既洎济继觊偈寂寄悸祭蓟暨跽霁鲚稷鲫冀髻骥加夹佳迦枷浃珈家痂笳袈袷葭跏嘉镓岬郏荚恝戛铗蛱颊甲胛贾钾瘕价驾架假嫁稼戋奸尖坚歼间肩艰兼监笺菅湔犍缄搛煎缣蒹鲣鹣鞯囝拣枧俭柬茧捡笕减剪检趼睑硷裥锏简谫戬碱翦謇蹇见件建饯剑牮荐贱健涧舰渐谏楗毽溅腱践鉴键僭
    MyFLJ2=槛箭踺江姜将茳浆豇僵缰礓疆讲奖桨蒋耩匠降洚绛酱犟糨艽交郊姣娇浇茭骄胶椒焦蛟跤僬鲛蕉礁鹪角佼侥挢狡绞饺皎矫脚铰搅湫剿敫徼缴叫峤轿较教窖酵噍醮阶疖皆接秸喈嗟揭街孑节讦劫杰诘拮洁结桀婕捷颉睫截碣竭鲒羯她姐解介戒芥届界疥诫借蚧骱藉巾今斤金津矜衿筋襟仅卺紧堇谨锦廑馑槿瑾尽劲妗近进荩晋浸烬赆缙禁靳觐噤京泾经茎荆惊旌菁晶腈睛粳兢精鲸井阱刭肼颈景儆憬警净弪径迳胫痉竞婧竟敬靓靖境獍静镜扃迥炯窘纠究鸠赳阄啾揪鬏九久灸
    MyFLJ3=玖韭酒旧臼咎疚柩桕厩救就舅僦鹫居拘狙苴驹疽掬椐琚趄锔裾雎鞠鞫局桔菊橘咀沮举矩莒榉榘龃踽句巨讵拒苣具炬钜俱倨剧惧据距犋飓锯窭聚屦踞遽瞿醵娟捐涓鹃镌蠲卷锩倦桊狷绢隽眷鄄噘撅孓决诀抉珏绝觉倔崛掘桷觖厥劂谲獗蕨噱橛爵镢蹶嚼矍爝攫军君均钧皲菌筠麇俊郡峻捃浚骏竣
    
    MyFLK1=咔咖喀卡佧胩开揩锎凯剀垲恺铠慨蒈楷锴忾刊勘龛堪戡坎侃砍莰看阚瞰康慷糠扛亢伉抗闶炕钪尻考拷栲烤铐犒靠坷苛柯珂科轲疴钶棵颏稞窠颗瞌磕蝌髁壳咳可岢渴克刻客恪课氪骒缂嗑溘锞肯垦恳啃裉吭坑铿空倥崆箜孔恐控抠芤眍口叩扣寇筘蔻刳枯哭堀窟骷苦库绔喾裤酷夸侉垮挎胯跨蒯块快侩郐哙狯脍筷宽髋款匡诓哐筐狂诳夼邝圹纩况旷矿贶框眶亏岿悝盔窥奎逵馗喹揆葵暌魁睽蝰夔傀跬匮喟愦愧溃蒉馈篑聩坤昆琨锟髡醌鲲悃捆阃困扩括栝蛞阔廓
    
    MyFLL1=垃拉啦邋旯砬喇剌腊瘌蜡辣来崃徕涞莱铼赉睐赖濑癞籁兰岚拦栏婪阑蓝谰澜褴斓篮镧览揽缆榄漤罱懒烂滥啷郎狼莨廊琅榔稂锒螂朗阆浪蒗捞劳牢唠崂痨铹醪老佬姥栳铑潦涝烙耢酪仂乐叻泐勒鳓雷嫘缧檑镭羸耒诔垒磊蕾儡肋泪类累酹擂嘞塄棱楞冷愣厘梨狸离莉骊犁喱鹂漓缡蓠蜊嫠璃鲡黎篱罹藜黧蠡礼李里俚哩娌逦理锂鲤澧醴鳢力历厉立吏丽利励呖坜沥苈例戾枥疠隶俐俪栎疬荔轹郦栗猁砺砾莅唳笠粒粝蛎傈痢詈跞雳溧篥俩奁连帘怜涟莲联裢廉鲢濂臁镰蠊敛
    MyFLL2=琏脸裣蔹练娈炼恋殓链楝潋良凉梁椋粮粱墚踉两魉亮谅辆晾量辽疗聊僚寥廖嘹寮撩獠缭燎镣鹩钌蓼了尥料撂咧列劣冽洌埒烈捩猎裂趔躐鬣邻林临啉淋琳粼嶙遴辚霖瞵磷鳞麟凛廪懔檩吝赁蔺膦躏拎伶灵囹岭泠苓柃玲瓴凌铃陵棂绫羚翎聆菱蛉零龄鲮酃领令另呤溜熘刘浏流留琉硫旒遛馏骝榴瘤镏鎏柳绺锍六鹨咯龙咙泷茏栊珑胧砻笼聋隆癃窿陇垄垅拢娄偻喽蒌楼耧蝼髅嵝搂篓陋漏瘘镂露噜撸卢庐芦垆泸炉栌胪轳鸬舻颅鲈卤虏掳鲁橹镥陆录赂辂渌逯鹿禄滤碌路漉
    MyFLL3=戮辘潞璐簏鹭麓氇驴闾榈吕侣旅稆铝屡缕膂褛履律虑率绿氯孪峦挛栾鸾脔滦銮卵乱掠略锊抡仑伦囵沦纶轮论捋罗猡脶萝逻椤锣箩骡镙螺倮裸瘰蠃泺洛络荦骆珞落摞漯雒
    
    MyFLM1=妈嬷麻蟆马犸玛码蚂杩骂唛吗嘛埋霾买荬劢迈麦卖脉颟蛮馒瞒鞔鳗满螨曼谩墁幔慢漫缦蔓熳镘邙忙芒盲茫硭莽漭蟒猫毛矛牦茅旄蛑锚髦蝥蟊卯峁泖茆昴铆茂冒贸耄袤帽瑁瞀貌懋么没枚玫眉莓梅媒嵋湄猸楣煤酶镅鹛霉每美浼镁妹昧袂媚寐魅门扪钔闷焖懑们氓虻萌盟甍瞢朦檬礞艨勐猛蒙锰艋蜢懵蠓孟梦咪弥祢迷猕谜醚糜縻麋靡蘼米芈弭敉脒眯汨宓泌觅秘密幂谧嘧蜜眠绵棉免沔黾勉眄娩冕湎缅腼面喵苗描瞄鹋杪眇秒淼渺缈藐邈妙庙乜咩灭蔑篾蠛民岷玟苠珉缗
    MyFLM2=皿闵抿泯闽悯敏愍鳘名明鸣茗冥铭溟暝瞑螟酩命谬缪摸谟嫫馍摹模膜麽摩磨蘑魔抹末殁沫茉陌秣莫寞漠蓦貊墨瘼镆默貘耱哞牟侔眸谋鍪某母毪亩牡姆拇木仫目沐坶牧苜钼募墓幕睦慕暮穆
    
    MyFLN1=拿镎哪内那纳肭娜衲钠捺乃奶艿氖奈柰耐萘鼐囡男南难喃楠赧腩蝻囔囊馕曩攮孬呶挠硇铙猱蛲垴恼脑瑙闹淖讷呐呢馁嫩能嗯妮尼坭怩泥倪铌猊霓鲵伲你拟旎昵逆匿溺睨腻拈年鲇鲶黏捻辇撵碾廿念埝娘酿鸟茑袅嬲尿脲捏陧涅聂臬啮嗫镊镍颞蹑孽蘖您宁咛拧狞柠聍凝佞泞甯妞牛忸扭狃纽钮农侬哝浓脓弄耨奴孥驽努弩胬怒女钕恧衄疟虐暖挪傩诺喏搦锘懦糯
    
    MyFLO1=噢哦讴欧殴瓯鸥呕偶耦藕怄沤
    
    MyFLP1=趴啪葩杷爬耙琶筢帕怕拍俳徘排牌哌派湃蒎潘攀爿盘磐蹒蟠判泮叛盼畔袢襻乓滂庞逄旁螃耪胖抛脬刨咆庖狍炮袍匏跑泡疱呸胚醅陪培赔锫裴沛佩帔旆配辔霈喷盆湓怦抨砰烹嘭朋堋彭棚硼蓬鹏澎篷膨蟛捧碰丕批纰邳坯披砒铍劈噼霹皮芘枇毗疲蚍郫陴啤埤琵脾罴蜱貔鼙匹庀仳圮痞擗癖屁淠媲睥僻甓譬片偏犏篇翩骈胼蹁谝骗剽漂缥飘螵瓢殍瞟票嘌嫖氕撇瞥苤姘拼贫嫔频颦品榀牝娉聘乒俜平评凭坪苹屏枰瓶萍鲆钋坡泼颇婆鄱皤叵钷笸迫珀破粕魄剖掊裒仆攴扑铺噗匍莆菩葡蒲璞濮镤朴圃埔浦普溥谱氆镨蹼瀑曝
    
    MyFLQ1=七沏妻柒凄栖桤戚萋期欺嘁槭漆蹊亓祁齐圻岐芪其奇歧祈耆脐颀崎淇畦萁骐骑棋琦琪祺蛴旗綦蜞蕲鳍麒乞企屺岂芑启杞起绮綮气讫汔迄弃汽泣契砌荠葺碛器憩掐葜恰洽髂千仟阡扦芊迁佥岍钎牵悭铅谦愆签骞搴褰前荨钤虔钱钳乾掮箝潜黔浅肷慊遣谴缱欠芡茜倩堑嵌椠歉呛羌戕戗枪跄腔蜣锖锵镪强墙嫱蔷樯抢羟襁炝悄硗跷劁敲锹橇缲乔侨荞桥谯憔鞒樵瞧巧愀俏诮峭窍翘撬鞘切茄且妾怯窃挈惬箧锲亲侵钦衾芩芹秦琴禽勤嗪溱噙擒檎螓锓寝吣沁揿青氢轻倾卿圊
     MyFLQ2=清蜻鲭情晴氰擎檠黥苘顷请謦庆箐磬罄跫銎邛穷穹茕筇琼蛩丘邱秋蚯楸鳅囚犰求虬泅俅酋逑球赇巯遒裘蝤鼽糗区曲岖诎驱屈祛蛆躯蛐趋麴黢劬朐鸲渠蕖磲璩蘧氍癯衢蠼取娶龋去阒觑趣悛圈全权诠泉荃拳辁痊铨筌蜷醛鬈颧犬畎绻劝券炔缺瘸却悫雀确阕阙鹊榷逡裙群
    
    MyFLR1=蚺然髯燃冉苒染禳瓤穰嚷壤攘让荛饶桡扰娆绕惹热人仁壬忍荏稔刃认仞任纫妊轫韧饪衽恁葚扔仍日戎肜狨绒茸荣容嵘溶蓉榕熔蝾融冗柔揉糅蹂鞣肉如茹铷儒嚅孺濡薷襦蠕颥汝乳辱入洳溽缛蓐褥阮朊软蕤蕊芮枘蚋锐瑞睿闰润若偌弱箬
    
    MyFLS1=仨撒洒卅飒脎萨塞腮噻鳃赛三叁毵伞散糁馓桑嗓搡磉颡丧搔骚缫臊鳋扫嫂埽瘙色涩啬铯瑟穑森僧杀沙纱刹砂莎铩痧裟鲨傻唼啥歃煞霎筛晒山删杉芟姗衫钐埏珊舢跚煽潸膻闪陕讪汕疝苫剡扇善骟鄯缮嬗擅膳赡蟮鳝伤殇商觞墒熵裳垧晌赏上尚绱捎梢烧稍筲艄蛸勺芍苕韶少劭邵绍哨潲奢猞赊畲舌佘蛇舍厍设社射涉赦慑摄滠麝申伸身呻绅诜娠砷深神沈审哂矧谂婶渖肾甚胂渗慎椹蜃升生声牲胜笙甥渑绳省眚圣晟盛剩嵊尸失师虱诗施狮湿蓍酾鲺十什石时识实拾炻蚀食埘莳鲥史矢豕使始驶屎士氏世仕市示式事侍势视试饰室
    MyFLS2=恃拭是柿贳适舐轼逝铈弑谥释嗜筮誓噬螫收手守首艏寿受狩兽售授绶瘦书抒纾叔枢姝倏殊梳淑菽疏舒摅毹输蔬秫孰赎塾熟暑黍署鼠蜀薯曙术戍束沭述树竖恕庶数腧墅漱澍刷唰耍衰摔甩帅蟀闩拴栓涮双霜孀爽谁水税睡吮顺舜瞬说妁烁朔铄硕嗍搠蒴嗽槊丝司私咝思鸶斯缌蛳厮锶嘶撕澌死巳四寺汜伺似兕姒祀泗饲驷俟笥耜嗣肆忪松凇崧淞菘嵩怂悚耸竦讼宋诵送颂嗖搜溲馊飕锼艘螋叟嗾瞍擞薮苏酥稣俗夙诉肃涑素速宿粟谡嗉塑愫溯僳蔌觫簌狻酸蒜算虽荽眭睢濉绥隋随髓岁祟谇遂碎隧燧穗邃孙狲荪飧损笋隼榫唆娑挲桫梭睃嗦羧蓑缩所唢索琐锁
    
    MyFLT1=他它趿铊塌溻塔獭鳎挞闼遢榻踏蹋骀胎台邰抬苔炱跆鲐薹太汰态肽钛泰酞坍贪摊滩瘫坛昙谈郯覃痰锬谭潭檀忐坦袒钽毯叹炭探赕碳汤铴羰镗饧唐堂棠塘搪溏瑭樘膛糖螗螳醣帑倘淌傥耥躺烫趟涛绦掏滔韬饕洮逃桃陶啕淘萄鼗讨套忑忒特铽慝疼腾誊滕藤剔梯锑踢绨啼提缇鹈题蹄醍体屉剃倜悌涕逖惕替裼嚏天添田恬畋甜填阗忝殄腆舔掭佻挑祧条迢笤龆蜩髫鲦窕眺粜铫跳贴萜铁帖餮厅汀听町烃廷亭庭莛停婷葶蜓霆挺梃铤艇通嗵仝同佟彤茼桐砼铜童酮僮潼瞳统捅
    MyFLT2=桶筒恸痛偷头投骰透凸秃突图徒涂荼途屠酴土吐钍兔堍菟湍团抟疃彖推颓腿退煺蜕褪吞暾屯饨豚臀氽托拖脱驮佗陀坨沱驼柁砣鸵跎酡橐鼍妥庹椭拓柝唾箨
    
    MyFLW1=哇娃挖洼娲蛙瓦佤袜腽歪崴外弯剜湾蜿豌丸纨芄完玩顽烷宛挽晚莞婉惋绾脘菀琬皖畹碗万腕汪亡王网往枉罔惘辋魍妄忘旺望危威偎逶隈葳微煨薇巍为韦圩围帏沩违闱桅涠唯帷惟维嵬潍伟伪尾纬苇委炜玮洧娓诿萎隗猥痿艉韪鲔卫未位味畏胃軎尉谓喂渭猬蔚慰魏温瘟文纹闻蚊阌雯刎吻紊稳问汶璺翁嗡蓊瓮蕹挝倭涡莴喔窝蜗我沃肟卧幄握渥硪斡龌乌圬污邬呜巫屋诬钨无毋吴吾芜唔梧浯蜈鼯五午仵伍坞妩庑忤怃迕武侮捂牾鹉舞兀勿务戊阢杌芴物误悟晤焐婺痦骛雾寤鹜鋈
    
    MyFLX1=夕兮汐西吸希昔析矽穸诶郗唏奚息浠牺悉惜欷淅烯硒菥晰犀稀粞翕舾溪皙锡僖熄熙蜥嘻嬉膝樨歙熹羲螅蟋醯曦鼷习席袭觋媳隰檄洗玺徙铣喜葸屣蓰禧戏系饩细郄阋舄隙禊呷虾瞎匣侠狎峡柙狭硖遐暇瑕辖霞黠下吓夏厦罅仙先纤氙祆籼莶掀跹酰锨鲜暹闲弦贤咸涎娴舷衔痫鹇嫌冼显险猃蚬筅跣藓燹县岘苋现线限宪陷馅羡献腺霰乡芗相香厢湘缃葙箱襄骧镶详庠祥翔享响饷飨想鲞向巷项象像橡蟓枭削哓枵骁宵消绡逍萧硝销潇箫霄魈嚣崤淆小晓筱孝肖哮效校笑啸些
    MyFLX2=楔歇蝎协邪胁挟偕斜谐携勰撷缬鞋写泄泻绁卸屑械亵渫谢榍榭廨懈獬薤邂燮瀣蟹躞心忻芯辛昕欣莘锌新歆薪馨鑫囟信衅兴星惺猩腥刑行邢形陉型硎醒擤杏姓幸性荇悻凶兄匈芎汹胸雄熊休修咻庥羞鸺貅馐髹朽秀岫绣袖锈溴戌盱砉胥须顼虚嘘需墟徐许诩栩糈醑旭序叙恤洫畜勖绪续酗婿溆絮嗅煦蓄蓿轩宣谖喧揎萱暄煊儇玄痃悬旋漩璇选癣泫炫绚眩铉渲楦碹镟靴薛穴学泶踅雪鳕血谑勋埙熏窨獯薰曛醺寻巡旬驯询峋恂洵浔荀循鲟训讯汛迅徇逊殉巽蕈
    
    MyFLY1=丫压呀押鸦桠鸭牙伢岈芽琊蚜崖涯睚衙疋哑痖雅亚讶迓垭娅砑氩揠咽恹烟胭崦淹焉菸阉湮腌鄢嫣蔫延闫严妍芫言岩沿炎研盐阎筵蜒颜檐兖奄俨衍偃厣掩眼郾琰罨演魇鼹厌彦砚唁宴晏艳验谚堰焰焱雁滟酽谳餍燕赝央泱殃秧鸯鞅扬羊阳杨炀佯疡徉洋烊蛘仰养氧痒怏恙样漾幺夭吆妖腰邀爻尧肴姚轺珧窑谣徭摇遥瑶繇鳐杳咬窈舀崾药要鹞曜耀椰噎爷耶揶铘也冶野业叶曳页邺夜晔烨掖液谒腋靥一伊衣医依咿猗铱壹揖欹漪噫黟仪圯夷沂诒宜怡迤饴咦姨荑贻眙胰酏痍
    MyFLY2=移遗颐疑嶷彝乙已以钇矣苡舣蚁倚椅旖义亿弋刈忆艺仡议亦屹异佚呓役抑译邑佾峄怿易绎诣驿奕弈疫羿轶悒挹益谊埸翊翌逸意溢缢肄裔瘗蜴毅熠镒劓殪薏翳翼臆癔镱懿因阴姻洇茵荫音殷氤铟喑堙吟垠狺寅淫银鄞夤龈霪尹引吲饮蚓隐瘾印茚胤应英莺婴瑛嘤撄缨罂樱璎鹦膺鹰迎茔盈荥荧莹萤营萦楹滢蓥潆蝇嬴赢瀛郢颍颖影瘿映硬媵哟唷佣拥痈邕庸雍墉慵壅镛臃鳙饔喁永甬咏泳俑勇涌恿蛹踊用优忧攸呦幽悠尢尤由犹邮油柚疣莜莸铀蚰游鱿猷蝣友有卣酉莠铕牖
    MyFLY3=黝又右幼佑侑囿宥诱蚴釉鼬纡迂淤渝瘀于予余妤欤於盂臾鱼俞禺竽舁娱狳谀馀渔萸隅雩嵛愉揄腴逾愚榆瑜虞觎窬舆蝓与伛宇屿羽雨俣禹语圄圉庾瘐窳龉玉驭吁聿芋妪饫育郁昱狱峪浴钰预域欲谕阈喻寓御裕遇鹆愈煜蓣誉毓蜮豫燠鹬鬻鸢冤眢鸳渊箢元员园沅垣爰原圆袁援缘鼋塬源猿辕圜橼螈远苑怨院垸媛掾瑗愿曰约月刖岳钥悦钺阅跃粤越樾龠瀹云匀纭芸昀郧耘氲允狁陨殒孕运郓恽晕酝愠韫韵熨蕴
    
    MyFLZ1=匝咂拶杂砸灾甾哉栽宰载崽再在糌簪咱昝攒趱暂赞錾瓒赃臧驵奘脏葬遭糟凿早枣蚤澡藻灶皂唣造噪燥躁则择泽责迮啧帻笮舴箦赜仄昃贼怎谮曾增憎缯罾锃甑赠吒咋哳喳揸渣楂齄扎札轧闸铡眨砟乍诈咤栅炸痄蚱榨膪斋摘宅翟窄债砦寨瘵沾毡旃粘詹谵澶瞻斩展盏崭搌辗占战栈站绽湛骣蘸张章鄣嫜彰漳獐樟璋蟑仉涨掌丈仗帐杖胀账障嶂幛瘴钊招昭啁找沼召兆诏赵笊棹照罩肇蜇遮折哲辄蛰谪摺磔辙者锗赭褶这柘浙蔗鹧贞针侦浈珍桢真砧祯斟甄蓁榛箴臻诊枕胗轸
    MyFLZ2=畛疹缜稹圳阵鸩振朕赈镇震争征怔峥挣狰钲睁铮筝蒸徵拯整正证诤郑帧政症之支卮汁芝吱枝知织肢栀祗胝脂蜘执侄直值埴职植殖絷跖摭踯止只旨址纸芷祉咫指枳轵趾黹酯至志忮制帙帜治炙质郅峙栉陟挚桎秩致贽轾掷痔窒鸷彘智滞痣蛭骘稚置雉膣觯踬中忠终盅钟舯衷锺螽肿种冢踵仲众重州舟诌周洲粥妯轴碡肘帚纣咒宙绉昼胄荮皱酎骤籀朱侏诛邾洙茱株珠诸猪铢蛛槠潴橥竹竺烛逐舳瘃躅主拄渚属煮嘱麈瞩伫住助苎杼注贮驻柱炷祝疰著蛀筑铸箸翥抓爪拽专砖
    MyFLZ3=匝咂拶杂颛转啭赚撰篆馔妆庄桩装壮状幢撞隹追骓椎锥坠缀惴缒赘肫窀谆准卓拙倬捉桌涿灼茁斫浊浞诼酌啄着琢禚擢濯镯仔孜兹咨姿赀资淄缁谘孳嵫滋粢辎觜趑锱龇髭鲻籽子姊秭耔笫梓紫滓訾字自恣渍眦宗综棕腙踪鬃总偬纵粽邹驺诹陬鄹鲰走奏揍租菹足卒族镞诅阻组俎祖躜缵纂钻攥嘴最罪蕞醉尊遵樽鳟撙昨左佐作坐阼怍柞祚胙唑座做
    
    MyHZ:=substr(MyHZ,1,1)
    ;msgbox  %MyHZ%
    if regexmatch(MyFLA1,MyHZ)>0
        return "A"
    else if  regexmatch(MyFLB1,MyHZ)>0 or regexmatch(MyFLB2,MyHZ)>0
        return "B"
    else if regexmatch(MyFLC1,MyHZ)>0  or regexmatch(MyFLC2,MyHZ)>0
        return "C"
    else if regexmatch(MyFLD1,MyHZ)>0 or regexmatch(MyFLD2,MyHZ)>0
        return "D"
    else if regexmatch(MyFLE1,MyHZ)>0
        return "E"
    else if regexmatch(MyFLF1,MyHZ)>0
        return "F"
    else if regexmatch(MyFLG1,MyHZ)>0 or regexmatch(MyFLG2,MyHZ)>0
        return "G"
    else if regexmatch(MyFLH1,MyHZ)>0 or regexmatch(MyFLH2,MyHZ)>0
        return "H"
    else if regexmatch(MyFLJ1,MyHZ)>0 or regexmatch(MyFLJ2,MyHZ)>0 or regexmatch(MyFLJ3,MyHZ)>0
        return "J"
    else if regexmatch(MyFLK1,MyHZ)>0
        return "K"
    else if regexmatch(MyFLL1,MyHZ)>0 or regexmatch(MyFLL2,MyHZ)>0 or regexmatch(MyFLL3,MyHZ)>0
        return "L"
    else if regexmatch(MyFLM1,MyHZ)>0 or regexmatch(MyFLM2,MyHZ)>0
        return "M"
    else if regexmatch(MyFLN1,MyHZ)>0
        return "N"
    else if regexmatch(MyFLO1,MyHZ)>0
        return "O"
    else if regexmatch(MyFLP1,MyHZ)>0
        return "P"
    else if regexmatch(MyFLQ1,MyHZ)>0 or regexmatch(MyFLQ2,MyHZ)>0
        return "Q"
    else if regexmatch(MyFLR1,MyHZ)>0
        return "R"
    else if regexmatch(MyFLS1,MyHZ)>0 or regexmatch(MyFLS2,MyHZ)>0
        return "S"
    else if regexmatch(MyFLT1,MyHZ)>0 or regexmatch(MyFLT2,MyHZ)>0
        return "T"
    else if regexmatch(MyFLW1,MyHZ)>0
        return "W"
    else if regexmatch(MyFLX1,MyHZ)>0 or regexmatch(MyFLX2,MyHZ)>0
        return "X"
    else if regexmatch(MyFLY1,MyHZ)>0 or regexmatch(MyFLY2,MyHZ)>0 or regexmatch(MyFLY3,MyHZ)>0
        return "Y"
    else if regexmatch(MyFLZ1,MyHZ)>0 or regexmatch(MyFLZ2,MyHZ)>0 or regexmatch(MyFLZ3,MyHZ)>0
        return "Z"
    else
        return  ""
}

;=======================================================
cando_复制到Word中:     ;长文本/短文件
    Run,"C:\Program Files\Microsoft Office\Office15\WINWORD.EXE"
    sleep,4000
    send,^n
    send,!pma
    send,1{tab}1{tab}1{tab}1{enter}
    Clipboard :=CandySel_Rich
    send,^v
return

;=======================================================
cando_复制保存到Txt中:     ;长文本/短文件
    TxtPath:=
    IniRead,TxtPath,%GeneralSettings_ini%,Ky_Settings,Txt保存路径
    if ErrorLevel
        TxtPath:=
    MyFun_SaveTxtFile(TxtPath,Candysel)
return
;=======================================================
cando_复制保存到Txt指定位置:     ;长文本/短文件
    TxtPath:=
    TxtPath:=A_ThisMenuItem
    IfNotExist ,%TxtPath%
        TxtPath:=
    MyFun_SaveTxtFile(TxtPath,Candysel)
return
;=======================================================
;保存Txt的函数
;SavePath,保存路径
;SaveText,要保存的内容
MyFun_SaveTxtFile(SavePath,SaveText)
{
    TxtName:=
    MySaveName:=
    Loop,parse,SaveText,`n     ;循环读取每一行
    {
        TxtName := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        TxtName:=trim(TxtName)
        StringReplace,TxtName,TxtName,`,,,all
        StringReplace,TxtName,TxtName,`\,,all
        StringReplace,TxtName,TxtName,`/,,all
        StringReplace,TxtName,TxtName,`:,,all
        StringReplace,TxtName,TxtName,`*,,all
        StringReplace,TxtName,TxtName,`?,,all
        StringReplace,TxtName,TxtName,`<,,all
        StringReplace,TxtName,TxtName,`>,,all
        StringReplace,TxtName,TxtName,`|,,all
        if TxtName!=
        {
            FirstLineLen:=strlen(TxtName)
            if FirstLineLen>20
                TxtName:=substr(TxtName,1,20)
            break
        }
    }
    if SavePath!=
        MySaveName:=SavePath . "\" . TxtName . ".txt"
    else
        MySaveName:=TxtName . ".txt"
    MyWF:=fileopen(MySaveName,"rw")
    if !IsObject(MyWF)
    {
        MsgBox 不能打开写入 %MySaveName% 文件
        return
    }
    else
    {
        MyWF.Write(SaveText)
        MyWF.Close()
    }
}
;=======================================================
cando_以文件夹名称重命名:    ;文件
    MyTemFile := RegExReplace(candysel,"(.*)\r.*","$1")   ;读取第一行
    If InStr(FileExist(candysel), "D")
        return
    SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt
    SplitPath,MyOutDir,MyParentFileName
    runwait,%7z% x %MyTemFile% -p1024 -o%MyOutDir%\已解压的文件\
    NewName=%MyOutDir%\%MyParentFileName%.%MyOutExt%
    FileMove,%MyTemFile%,%NewName%
    return
;=======================================================
cando_放入同名文件夹:   ;文件,按下SHIFT键则打开文件
    SplitPath,CandySelected,MyOutFileName,MyOutDir,,MyOutNameNoExt
    FileCreateDir,%MyOutDir%\%MyOutNameNoExt%
    FileMove,%CandySelected%,%MyOutDir%\%MyOutNameNoExt%\%MyOutFileName%
    if Ky_ShiftIsPressed!=
        run %MyOutDir%\%MyOutNameNoExt%
    Ky_ShiftIsPressed:=
    Return
;=======================================================
cando_复制所选文件夹下子文件夹结构:   ;文件夹
    Ky_SouFolder:=CandySel
    Ky_FoldersPasteMode:=1
    return
;=======================================================
cando_复制所选文件夹结构:    ;多文件，其实是多文件夹
    Ky_SouFolder:=CandySel
    Ky_FoldersPasteMode:=2
    return
;=======================================================
cando_粘贴文件夹结构:        ;文件/文件夹/多文件,按下SHIFT删除所选内容/右键菜单
    if Ky_SouFolder=        ;如果源文件源数据为空，则中止
        return
    MyTemFile := RegExReplace(candysel,"(.*)\r.*","$1")      ;取第一文件或文件夹所在目录
    SplitPath,MyTemFile,,MyOutDir,,
    if CandySel_Ext=RightMenu
        Ky_DesFolder:=CandySel
    else
        Ky_DesFolder :=MyOutDir
    if Ky_FoldersPasteMode=1 ;粘贴所选文件夹下子文件夹结构
    {
        Loop, Files,%Ky_SouFolder%\*.*, DR  ;只复制文件夹,包含子文件夹
        {
            StringReplace,NewDir,A_LoopFileFullPath,%Ky_SouFolder%,%Ky_DesFolder%,All
            filecreatedir, %NewDir%
        }
    }
    if Ky_FoldersPasteMode=2 ;粘贴所选文件夹结构
    {
        Loop,parse,Ky_SouFolder,`n     ;循环读取每一行
        {
            MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
            If InStr(FileExist(MyTemFile), "D")
            {
                SplitPath,MyTemFile,,,,MyOutNameNoExt
                filecreatedir,%Ky_DesFolder%\%MyOutNameNoExt%
            }
        }
    }
    Ky_SouFolder:=
    Ky_DesFolder:=
    Ky_FoldersPasteMode:=
    if Ky_CapslockIsPressed=1
    {
        If InStr(FileExist(candysel), "D")
            fileremovedir,%candysel%
        else
            filedelete,%candysel%
    } 
    Ky_CapslockIsPressed:=
    Return
;=======================================================
cando_迅雷批量下载:   ;长文本/短文本
    ;~ IfNotExist ahk_exe 'Thunder'.exe  ;判断某进程是否存在
    ;~ {
        ;~ Run,%Thunder%,, useerrorlevel
        ;~ sleep,3000
    ;~ }
    Run,%Thunder%,, useerrorlevel
    sleep,3000
    ;WinActivate ,ahk_class XLUEFrameHostWnd  ;等待某进程出现
    Candy_Saved_ClipBoard:=ClipboardAll
    Clipboard:=CandySel
    send,^n
    winwait,ahk_class XLUEModalHostWnd  ;等待新建任务进程
    sleep,1000
    send,^v
    Clipboard := Candy_Saved_ClipBoard  ;还原粘贴板
    return  
;=======================================================
cando_文件名替换指定内容:        ;文件/多文件
    SplitPath,Candy_ProFile_Ini,,Candy_Profile_Dir,,Candy_ProFile_Ini_NameNoext
    ReplaceList:=A_ScriptDir . "\" . Candy_Profile_Dir . "\替换列表.txt"
    ifnotexist,%ReplaceList%
        return
    Loop,parse,candysel,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        MyNewFile:=MyTemFile
        ;If InStr(FileExist(MyTemFile), "D")
        ;    continue
        Loop,read,%ReplaceList%
        {
            MyOldStr:=RegExReplace(A_LoopReadLine,"=.*?$")  	 ;要替换的字符串
            MyNewStr:=RegExReplace(A_LoopReadLine,"^.*?=") 	;替换为的字符串
            StringReplace,MyNewFile,MyNewFile,%MyOldStr%,%MyNewStr%,all
        }
        if MyTemFile=%MyNewFile%
            continue
        MyNewFileCount:=MyNewFile
        if MyNewFileCount=
            return
        Loop
        {
            ifnotexist,%MyNewFileCount%
                break
            SplitPath,MyNewFile,,MyOutDir,MyOutExt,MyOutNameNoExt
            MyNewFileCount=%MyOutDir%\%MyOutNameNoExt%-%A_Index%.%MyOutExt%
        }
        If InStr(FileExist(MyTemFile), "D")
            filemovedir,%MyTemFile%,%MyNewFileCount%
        else
            filemove,%MyTemFile%,%MyNewFileCount%
    }
    return
;=======================================================
cando_等号对齐:        ;长文本，INI文件
;~ F9::
	Send,^a
	Send,^c
	Sel=%Clipboard%
	LimitMax:=90     ;左侧超过该长度时，该行不参与对齐，该数字可自行修改
	MaxLen:=0
	StrSpace:=" "
	Loop,% LimitMax+1
		StrSpace .=" "
		Aligned:=
		loop, parse, Sel, `n,`r                   ;首先求得左边最长的长度，以便向它看齐
		{
			IfNotInString,A_loopfield,=              ;本行没有等号，过
				Continue
			ItemLeft :=RegExReplace(A_LoopField,"\s*(.*?)\s*=.*$","$1")        ;本条目的 等号 左侧部分
			ThisLen:=StrLen(regexreplace(ItemLeft,"[^\x00-\xff]","11"))       ;本条左侧的长度
			MaxLen:=( ThisLen > MaxLen And ThisLen <= LimitMax) ? ThisLen : MaxLen       ;得到小于LimitMax内的最大的长度，这个是最终长度
		}
		loop, parse, Sel, `n,`r
		{
			IfNotInString,A_loopfield,=
			{
				Aligned .= A_loopfield "`r`n"
				Continue
			}
			ItemLeft:=trim(RegExReplace(A_LoopField,"\s*=.*?$") )        ;本条目的 等号 左侧部分
			Itemright:=trim(RegExReplace(A_LoopField,"^.*?=")  )          ;本条目的 等号 右侧部分
			ThisLen:=StrLen(regexreplace(ItemLeft,"[^\x00-\xff]","11"))   ;本条左侧的长度
			if ( ThisLen> MaxLen )       ;如果本条左侧大于最大长度，注意是最大长度，而不是LimitMax，则不参与对齐
			{
				Aligned .= ItemLeft  "= " Itemright "`r`n"
				Continue
			}
			Else
			{
				Aligned .= ItemLeft . SubStr( StrSpace, 1, MaxLen+2-ThisLen ) "= " Itemright "`r`n"        ;该处给右侧等号后添加了一个空格，根据需求可删
		}
	}
	Aligned:=RegExReplace(Aligned,"\s*$","")   ;顺便删除最后的空白行，可根据需求注释掉
	clipboard := Aligned
	Send ^v
	Return
;=======================================================
cando_编辑Zip密码列表:     ;文件/文件夹/多文件
    SplitPath,Candy_ProFile_Ini,,Candy_Profile_Dir,,Candy_ProFile_Ini_NameNoext
    PswList:=A_ScriptDir . "\" . Candy_Profile_Dir . "\Zip密码列表.txt"
    IfNotExist %PswList%
    {
        MySub_WriteFile(PswList,"","rw")
    }
    run,%PswList%
    return
;=======================================================
cando_自寻密码解压:     ;文件/多文件,按住SHIFT则删除
    Zip7:=7z
    ExtractDir:=
    SplitPath,Candy_ProFile_Ini,,Candy_Profile_Dir,,Candy_ProFile_Ini_NameNoext
    PswList:=A_ScriptDir . "\" . Candy_Profile_Dir . "\Zip密码列表.txt"
    IfNotExist %PswList%
    {
        MySub_WriteFile(PswList,"","rw")
        run,%PswList%
    }
    if Ky_CapslockIsPressed=1
        if Ky_ShiftIsPressed=1
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,1,1)
        else
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,1,0)
    else
        if Ky_ShiftIsPressed=1
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,0,1)
        else
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,0,0)
    Ky_ShiftIsPressed:=
    Ky_CapslockIsPressed:=
    return
;=======================================================
cando_自寻密码解压到:     ;文件/多文件，按住SHIFT则删除
    Zip7:=7z
    FileSelectFolder,ExtractDir,*%CandySel_ParentPath%,1
    If ExtractDir=
        return
    SplitPath,Candy_ProFile_Ini,,Candy_Profile_Dir,,Candy_ProFile_Ini_NameNoext
    PswList:=A_ScriptDir . "\" . Candy_Profile_Dir . "\Zip密码列表.txt"
    IfNotExist %PswList%
    {
        MySub_WriteFile(PswList,"","rw")
        run,%PswList%
    }
    if Ky_CapslockIsPressed=1
        if Ky_ShiftIsPressed=1
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,1,1)
        else
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,1,0)
    else
        if Ky_ShiftIsPressed=1
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,0,1)
        else
            MySub_7ZipExtract(Zip7,candysel,PswList,ExtractDir,0,0)
    Ky_ShiftIsPressed:=
    Ky_CapslockIsPressed:=
    return
;=======================================================
;解压过程，Zip7=7Zip路径,MyFileList=要解压的文件列表,MyPswPath=密码列表文件路径，
                ;MyExtractDir=解压路径，为空则为文件所在目录,MyDelete=是否删除，1为删除,MyToDir=是不为文件夹，1为文件夹
MySub_7ZipExtract(Zip7,MyFileList,MyPswPath,MyExtractDir,MyDelete,MyToDir:=0)
{
    Loop,parse,MyFileList,`n     ;循环读取每一行
    {
        ifexist,ZipDone.txt
            filedelete,ZipDone.txt
        HavePSW:=0
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        If inStr(FileExist(MyTemFile), "D")     ;如果是文件夹就继续
            continue
        SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt
        StringLower, MyOutExt, MyOutExt
        ;如果是zip,rar,7z则处理
        if (MyOutExt="zip" or  MyOutExt="rar" or MyOutExt="7z")
        {
            if MyExtractDir=        ;如果解压目录为空，则解压在文件所在目录
                MyExtractDir:=MyOutDir        
            if Ky_RecentPWS!=       ;如果最近密码存在
            {
                if MyToDir=1
                    MyCmdLine=%comspec% /c %Zip7% x `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%MyExtractDir%\%MyOutNameNoExt%\`" && echo ZipDone>ZipDone.txt
                else
                    MyCmdLine=%comspec% /c %Zip7% x `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%MyExtractDir%\`" && echo ZipDone>ZipDone.txt
                ;if MyDelete=1
                    runWait,%MyCmdLine%,,UseErrorLevel
                ;else
                ;    run,%MyCmdLine%,,UseErrorLevel
                ifexist,ZipDone.txt
                {
                    filedelete,ZipDone.txt
                    if MyDelete=1
                        filedelete, %MyTemFile%
                    continue
                }
            }
            Loop,read,%MyPswPath%
            {
                ifexist,ZipDone.txt
                    filedelete,ZipDone.txt
                MyPSW := RegExReplace(A_LoopReadLine,"(.*)\r.*","$1")
                if MyPSW=   ;如果是空行就继续
                    continue
                ;run,%7z% x %MyTemFile% -p%MyPSW% -o%MyOutDir%\,,UseErrorLevel
                if MyToDir=1
                    MyCmdLine=%comspec% /c %Zip7% x `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%MyExtractDir%\%MyOutNameNoExt%\`" && echo ZipDone>ZipDone.txt
                else
                    MyCmdLine=%comspec% /c %Zip7% x `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%MyExtractDir%\`" && echo ZipDone>ZipDone.txt
                ;msgbox %MyCmdLine
                ;if MyDelete=1
                    runWait,%MyCmdLine%,,UseErrorLevel
                ;else
                ;    run,%MyCmdLine%,,UseErrorLevel
                ifexist,ZipDone.txt
                {
                    HavePSW:=1
                    Ky_RecentPWS:=MyPSW
                    filedelete,ZipDone.txt
                    break
                }
            }
            if HavePSW=0
            {
    MyReStart:
                Inputbox, MyInput, `n提示,%MyTemFile%`n`n在密码列表中未找到密码，请输入密码`n如果密码形式为 xxxx`|x，则记录密码
                stringsplit,MyArray_PSW,MyInput,`|
                if MyToDir=1
                    MyCmdLine=%comspec% /c %Zip7% x `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%MyExtractDir%\%MyOutNameNoExt%\`" && echo ZipDone>ZipDone.txt
                else
                    MyCmdLine=%comspec% /c %Zip7% x `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%MyExtractDir%\`" && echo ZipDone>ZipDone.txt
                ;MsgBox % MyCmdLine
                ;if MyDelete=1
                    runWait,%MyCmdLine%,,UseErrorLevel
                ;else
                ;    run,%MyCmdLine%,,UseErrorLevel
                ifnotexist,ZipDone.txt
                {
                    msgbox,4,操作选择,密码不正确，是否重新输入？
                    ifmsgbox Yes
                        goto,MyRestart
                }
                if MyArray_PSW2!=   ;如果密码形式为xxxx|x,则记录密码
                    FileAppend,%MyArray_PSW1%`n,%MyPswPath%
            }
            if MyDelete=1
                filedelete, %MyTemFile%
        }
    }
    ifexist,ZipDone.txt
        filedelete,ZipDone.txt
}
return
;=======================================================
;写文件过程，MyFileName=文件名称,MyContent=写入内容，MyMode=写入模式,rw/
MySub_WriteFile(MyFileName,MyContent,MyMode)
{
    MyWF:=fileopen(MyFileName,MyMode)
    if !IsObject(MyWF)
    {
        MsgBox 不能打开写入 %MyFileName% 文件
        return
    }
    else
    {
        MyWF.Write(MyContent)
        MyWF.Close()
    }
}
return
;=======================================================
cando_所选文件统一压缩为Zip:     ;文件/文件夹/多文件；按住SHIFT则加密
    Zip7:=7z
    Inputbox, MyInput, 提示,`n请输入Zip文件名称`n`n如果为空，则默认使用所选文件所在目录名称
    if Ky_ShiftIsPressed!=
        Inputbox, MyPassword, 提示,`n请输入加密密码`n`n如果为空，则默认不加密`n加密文件名,密码形式为 xxxx`|x ，压缩格式为7z
    else
        MyPassword:=
    Ky_ShiftIsPressed:=
    if MyInput!=
        MyZipFileName=%MyInput%
    else
        SplitPath,CandySel_ParentPath,,,,MyZipFileName
    MyZipFileName:=CandySel_ParentPath . "\" . MyZipFileName
    if Ky_CapslockIsPressed=0
        MySub_7ZipAdd(Zip7,candysel,MyZipFileName,MyPassword,0,0)
    else
        MySub_7ZipAdd(Zip7,candysel,MyZipFileName,MyPassword,0,1)
    return
;=======================================================
cando_所选文件各自压缩为Zip:     ;文件/文件夹/多文件；按住SHIFT则加密
    Zip7:=7z
    MyZipFileName:=
    if Ky_ShiftIsPressed=1
        Inputbox, MyPassword, 提示,`n请输入加密密码`n`n如果为空，则默认不加密`n加密文件名，密码形式为 xxxx`|x ，压缩格式为7z
    else
        MyPassword:=
    Ky_ShiftIsPressed:=
    if Ky_CapslockIsPressed=0
        MySub_7ZipAdd(Zip7,candysel,MyZipFileName,MyPassword,1,0)
    else
        MySub_7ZipAdd(Zip7,candysel,MyZipFileName,MyPassword,1,1)
    return
;=======================================================
;压缩过程，Zip7=7Zip路径,MyFileList=要压缩的文件列表,MyZipFile=压缩文件名称，MyPsw=密码,ZipMode=压缩模式，0=统一，1=各自,MyDelete=是否删除，1为删除
MySub_7ZipAdd(Zip7,MyFileList,MyZipFile,MyPsw,ZipMode,MyDelete:=0)
{
    Loop,parse,MyFileList,`n     ;循环读取每一行
    {
        MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
        if ZipMode=0        ;统一压缩
        {
            if MyPsw!=
            {
                stringsplit,MyArray_PSW,MyPSW,`|
                If InStr(FileExist(MyTemFile), "D")
                    if MyArray_PSW2!=
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyZipFile%.7z`" -p%MyArray_PSW1% -mhe `"%MyTemFile%\`"
                    else
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyZipFile%.zip`" -p%MyArray_PSW1% `"%MyTemFile%\`"
                else
                    if MyArray_PSW2!=
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyZipFile%.7z`" -p%MyArray_PSW1% -mhe `"%MyTemFile%`"
                    else
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyZipFile%.zip`" -p%MyArray_PSW1% `"%MyTemFile%`"
            } else {
                If InStr(FileExist(MyTemFile), "D")
                    MyCmdLine=%comspec% /c %Zip7% a `"%MyZipFile%.zip`" `"%MyTemFile%\`"
                else
                    MyCmdLine=%comspec% /c %Zip7% a `"%MyZipFile%.zip`"  `"%MyTemFile%`"
            }
            Runwait,%MyCmdLine%,,UseErrorLevel
        }
        if ZipMode=1        ;各自压缩
        {
            SplitPath,MyTemFile,,MyOutDir,,MyOutNameNoExt
            if MyPsw!=
            {
                stringsplit,MyArray_PSW,MyPSW,`|
                If InStr(FileExist(MyTemFile), "D")
                    if MyArray_PSW2!=
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyOutDir%\%MyOutNameNoExt%.7z`" -p%MyArray_PSW1% -mhe `"%MyTemFile%\`"
                    else
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyOutDir%\%MyOutNameNoExt%.zip`" -p%MyArray_PSW1% `"%MyTemFile%\`"
                else
                    if MyArray_PSW2!=
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyOutDir%\%MyOutNameNoExt%.7z`" -p%MyArray_PSW1% -mhe `"%MyTemFile%`"
                    else
                        MyCmdLine=%comspec% /c %Zip7% a `"%MyOutDir%\%MyOutNameNoExt%.zip`" -p%MyArray_PSW1% `"%MyTemFile%`"
            } else {
                If InStr(FileExist(MyTemFile), "D")
                    MyCmdLine=%comspec% /c %Zip7% a `"%MyOutDir%\%MyOutNameNoExt%.zip`" `"%MyTemFile%\`"
                else
                    MyCmdLine=%comspec% /c %Zip7% a `"%MyOutDir%\%MyOutNameNoExt%.zip`"  `"%MyTemFile%`"
            }
            ;msgbox % MyCmdLine
            if MyDelete=1
                RunWait,%MyCmdLine%,,UseErrorLevel
            else
                Run,%MyCmdLine%,,UseErrorLevel
        }
        if MyDelete=1
        {
            If InStr(FileExist(MyTemFile), "D")
                fileremovedir,%MyTemFile%,1
            else
                filedelete,%MyTemFile%
        }
    }
}
return

;==================================================================================
;从资源管理器中，获取被选择的文件的路径（及文件夹）的API
/*  
    Explorer_GetSelected(hwnd="")   - paths of target window's selected items  
    Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder  
    Explorer_GetPath(hwnd="")       - path of target window's folder  
  
    用法:  
        F1::  
            path := Explorer_GetPath()  		;打开的目录的路径
            all := Explorer_GetAll()  			;打开的路径下的所有文件的路径
            sel := Explorer_GetSelected()  	;打开的路径下所选择的文件的路径
            MsgBox % path  
            MsgBox % all  
            MsgBox % sel  
        return  
*/  

Explorer_GetPath(hwnd="")  
{  
    if !(window := Explorer_GetWindow(hwnd))  
        return ErrorLevel := "ERROR"  
    if (window="desktop")  
        return A_Desktop  
    path := window.LocationURL  
    path := RegExReplace(path, "ftp://.*@","ftp://")  
    StringReplace, path, path, file:///  
    StringReplace, path, path, /, \, All   
    Loop  
        If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)  
            StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All  
        Else Break  
    return path  
}  
  
Explorer_GetAll(hwnd="")  
{  
    return Explorer_Get(hwnd)  
}  
  
Explorer_GetSelected(hwnd="")  
{  
    return Explorer_Get(hwnd,true)  
}  
  
Explorer_GetWindow(hwnd="")  
{  
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")  
    WinGetClass class, ahk_id %hwnd%  
  
    if (process!="explorer.exe")  
        return  
    if (class ~= "(Cabinet|Explore)WClass")  
    {  
        for window in ComObjCreate("Shell.Application").Windows  
            if (window.hwnd==hwnd)  
                return window  
    }  
    else if (class ~= "Progman|WorkerW")   
        return "desktop" ; desktop found  
}  
  
Explorer_Get(hwnd="",selection=false)  
{  
    if !(window := Explorer_GetWindow(hwnd))  
        return ErrorLevel := "ERROR"  
    if (window="desktop")  
    {  
        ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman  
        if !hwWindow ; #D mode  
            ControlGet, hwWindow, HWND,, SysListView321, A  
        ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%  
        base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop  
        Loop, Parse, files, `n, `r  
        {  
            path := base "\" A_LoopField  
            IfExist %path% ; ignore special icons like Computer (at least for now)  
                ret .= path "`n"  
        }  
    }  
    else  
    {  
        if selection  
            collection := window.document.SelectedItems  
        else  
            collection := window.document.Folder.Items  
        for item in collection  
            ret .= item.path "`n"  
    }  
    return Trim(ret,"`n")  
} 
;==================================================================================
;=======================================================
;我预留的函数
;SplitPath,MyTemFile,MyOutFileName,MyOutDir,MyOutExt,MyOutNameNoExt,MyOutDrive
