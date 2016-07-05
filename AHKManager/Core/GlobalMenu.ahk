FileEncoding, CP936
global g_GlobalMenuItems := ""
global  lnksavedir := "" ;如何给Label传参数?设置一个global变量为何不行?

global menuName:=""
global fileName:=""
global folderName:=""
global suffix:=""
global action:="txt_edit"

GlobalMenu:
	AddToGlobalMenu("常用文档(&2)`tWin+ 2","FileMenu")
	AddToGlobalMenu("常用路劲(&3)`tWin+ 3","FolderMenu")
	AddToGlobalMenu("RecentFolder","RecentFolder")
	AddToGlobalMenu("FuckAHK","FuckAHK")
	AddToGlobalMenu("RunFolderList_DirFav","RunFolderList")
	AddToGlobalMenu("Eclipse Workspace","EcSpace")
	AddToGlobalMenu("Ahk Learn(&5)`tWin+ 5","AhkOpenMenu")
	AddToGlobalMenu("Ahk Open文档(&4)`tWin+ 4","OpenFileMenu")
	AddToGlobalMenu("测试当前脚本", "OpenWithAHK", "Notepad++")
	AddToGlobalMenu("测试当前脚本A32", "OpenWithAHK32", "Notepad++")
    AddToGlobalMenu("帮助文档(&1)`tWin+ 1","ChmMenu")
	AddToGlobalMenu("发送到火狐", "OpenWithFF", "Notepad++")
	AddToGlobalMenu("发送文件到记事本", "OpenWithNotepad", "Notepad++")
	AddToGlobalMenu("发送到Everything", "OpenWithEve", "Notepad++")
	AddToGlobalMenu("GlobalFolderLabel_RecentLink","GlobalFolderLabel_RecentLink")
	AddToGlobalMenu("GlobalLabelAnyFolderLnk_chm","GlobalLabelAnyFolderLnk_chm")
	AddToGlobalMenu("GlobalLabelAnyFolderLnk_suffix_chm","GlobalLabelAnyFolderLnk_suffix_chm")
	AddToGlobalMenu("脚本目录","Menu_Tray_OpenDir")
	 AddToGlobalMenu("查看剪切板内容", "Clip")
	AddToGlobalMenu("编辑","Menu_Tray_Edit")
	AddToGlobalMenu("测试每行","RunEachLine")
	AddToGlobalMenu("测试每行Menu","RunEachLineMenu")
	
    WinGetClass, lastWindowClass, A

    for index, element in g_GlobalMenuItems
    {
        if (element[3] == "" || lastWindowClass == element[3])
        {
            Menu, GlobalMenu, Add, % element[1], % element[2]
        }
    }

    Menu, GlobalMenu, Show
    Menu, GlobalMenu, DeleteAll
return

GlobalLabelAnyFolderLnk_chm:
menuName:="GlobalLabelAnyFolderLnk_chm"
folderName:="F:\Program Files\AutoHotkey\Scripts\chm"
action:="txt_edit"
gosub GlobalLabelAnyFolderLnk
return

GlobalLabelAnyFolderLnk_suffix_chm:
menuName:="GlobalLabelAnyFolderLnk_suffix_chm"
folderName:="F:\Program Files\AutoHotkey\Scripts\chm"
action:="txt_edit"
suffix:="chm"
gosub GlobalLabelAnyFolderLnk_suffix
return

GlobalFolderLabel_RecentLink:
menuName:="GlobalFolderLabel_RecentLink"
fileName:="F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\RecentLink.xml"
action:="txt_edit"
gosub GlobalFolderLabel
return

FuckAHK:
menuName:="FuckAHK"
fileName:="F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\FuckAHK.xml"
action:="txt_edit"
gosub GlobalFolderLabel
return

GlobalFolderLabel:
Menu %menuName%, Add, %menuName%, Menu_Tray_Exit
Menu %menuName%, ToggleEnable, %menuName%
Menu %menuName%, Default, %menuName%
scriptCount = 0
Loop, Read, %fileName%
{
    Menu %menuName%, add, %A_LoopReadLine%, %action%
}
Menu %menuName%, Show
return


GlobalLabelAnyFolderLnk:
Menu %menuName%, Add, %menuName%, Menu_Tray_Exit
Menu %menuName%, ToggleEnable, %menuName%
Menu %menuName%, Default, %menuName%
scriptCount = 0
;Loop, F:\Program Files\AutoHotkey\Scripts\chm\*.*
Loop, %folderName%\*.*
{
    ;StringRePlace menuNameTmp, A_LoopFileName, .CHM ;commented

    scriptCount += 1
    scripts%scriptCount%0 := A_LoopFileName
	
    ;Menu %menuName%, add, %menuNameTmp%, %action%
    Menu %menuName%, add, %A_LoopFileName%, %action%
}
Menu,%menuName%,show
return


GlobalLabelAnyFolderLnk_suffix:
Menu %menuName%, Add, %menuName%, Menu_Tray_Exit
Menu %menuName%, ToggleEnable, %menuName%
Menu %menuName%, Default, %menuName%
scriptCount = 0
Loop, %folderName%\*.%suffix%
{
    scriptCount += 1
    scripts%scriptCount%0 := A_LoopFileName
	
    Menu %menuName%, add, %A_LoopFileName%, %action%
}
Menu,%menuName%,show
return

ChmMenu:
Menu scripts_edit, Add, 帮助文档, Menu_Tray_Exit
Menu scripts_edit, ToggleEnable, 帮助文档
Menu scripts_edit, Default, 帮助文档
scriptCount = 0
Loop, F:\Program Files\AutoHotkey\Scripts\chm\*.*
{
    StringRePlace menuNameTmp, A_LoopFileName, .chm

    scriptCount += 1
    scripts%scriptCount%0 := A_LoopFileName
	
    Menu scripts_edit, add, %menuNameTmp%, tsk_edit
}
Menu,scripts_edit,show
return


FileMenu:
Menu txt_edit, Add, 常用文档, Menu_Tray_Exit
;Menu txt_edit, ToggleEnable, 常用文档
;Menu txt_edit, Default, 常用文档
scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\folderLinkFiles.xml
{
    Menu txt_edit, add, %A_LoopReadLine%, txt_edit
}
Menu txt_edit, Show
return

FolderMenu:
Menu folder_edit, Add, 常用路劲, Menu_Tray_Exit
Menu folder_edit, ToggleEnable, 常用路劲
Menu folder_edit, Default, 常用路劲
scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\folderLink.xml
{
    Menu folder_edit, add, %A_LoopReadLine%, txt_edit
}
Menu folder_edit, Show
return

RecentFolder:
Menu RecentFolder, Add, RecentFolder, Menu_Tray_Exit
Menu RecentFolder, ToggleEnable, RecentFolder
Menu RecentFolder, Default, RecentFolder
scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\RecentLink.xml
{
    Menu RecentFolder, add, %A_LoopReadLine%, txt_edit
}
Menu RecentFolder, Show
return



EcSpace:
Menu workspace, Add, Workspace, Menu_Tray_Exit
Menu workspace, ToggleEnable, Workspace
Menu workspace, Default, Workspace
scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\ecspace.xml
{
    Menu workspace, add, %A_LoopReadLine%, txt_edit
}
Menu workspace, Show
return

OpenFileMenu:
Menu openfiles_edit, Add, Ahk Open文档, Menu_Tray_Exit
Menu openfiles_edit, ToggleEnable, Ahk Open文档
Menu openfiles_edit, Default, Ahk Open文档
scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\folderLinkOpenFiles.xml
{
    Menu openfiles_edit, add, %A_LoopReadLine%, openfile_edit
}
Menu openfiles_edit, Show
return

AhkOpenMenu:
Menu ahk_edit, Add, Ahk Open文档, Menu_Tray_Exit
Menu ahk_edit, ToggleEnable, Ahk Open文档
Menu ahk_edit, Default, Ahk Open文档
scriptCount = 0
Loop, Read, F:\Program Files\AutoHotkey\Scripts\AHK管理器【终版】\FromAutoHotkeyScriptFolder\Good\ListViewFolder\AllAhkLearn.xml
{
    IfNotInString, #@#@,  %A_LoopReadLine% ;this uses #@#@ to comment ignore lines in the file list files ! good !
	{
	;IfNotInString, Manager, %A_LoopReadLine%  ;Fails to control more
    Menu ahk_edit, add, %A_LoopReadLine%, openfile_edit
	}
}
Menu ahk_edit, Add
Menu ahk_edit, Show
return


AddToGlobalMenu(name, label, winClass := "")
{
    if (g_GlobalMenuItems == "")
    {
        g_GlobalMenuItems := Object()
    }

    g_GlobalMenuItems.Push([name, label, winClass])
}

OpenWithNotepad:
    WinGetTitle, title, A
    StringReplace, title, title, - Notepad++, , All

    Run, "F:\Program Files\Notepad++\notepad++.exe" "%title%"
return

RunEachLine:
    WinGetTitle, title, A
    StringReplace, title, title, - Notepad++, , All
	
Loop, Read, %title%
{
	command:= A_LoopReadLine " version -v"
	result := RunAndGetOutput(command)
	GoSub, ActivateRunZ
	
    MsgBox %A_LoopReadLine%
    DisplayResult("执行结果 " . StrLen(result) . " ：`n`n" . result)
	
    ;Run,"%A_LoopReadLine%" version -a >> "RunEachLineOutput.txt"
	;if use cmd, it is not found. fuck!
    ;Run,%ComSpec% /k "%A_LoopReadLine%" version -a
}

return


OpenWithAHK32:
    WinGetTitle, title, A ; 如果换一个方式取文件名，就可以自定义出右键菜单了
    StringReplace, title, title, - Notepad++, , All

    Run, "F:\Program Files\AutoHotkey\AutoHotkeyA32.exe" "%title%"
return

OpenWithAHK:
    WinGetTitle, title, A ; 如果换一个方式取文件名，就可以自定义出右键菜单了
    StringReplace, title, title, - Notepad++, , All

    Run, "F:\Program Files\AutoHotkey\AutoHotkey.exe" "%title%"
return

OpenWithFF:
    WinGetTitle, title, A ; 如果换一个方式取文件名，就可以自定义出右键菜单了
    StringReplace, title, title, - Notepad++, , All

    Run, "F:\Program Files\Mozilla Firefox\firefox.exe" "%title%"
return

OpenWithEve:
    WinGetTitle, title, A ;  the same can be done by ctrl+alt+c get folder name then alt+s search in folder
    StringReplace, title, title, - Notepad++, , All
	;MsgBox %title%

    Run, "F:\Program Files\Everything\Everything.exe" -p "%title%"
return


#1::
gosub ChmMenu
return

#2::
gosub FileMenu
return

#3::
gosub FolderMenu
return

#4::
gosub OpenFileMenu
return

#5::
gosub Menu_Tray_Edit
return

#6::
gosub Menu_Tray_OpenDir
return

Menu_Tray_Exit:
	ExitApp
Return

Menu_Tray_OpenDir:
	Run %A_ScriptDir%
Return

Menu_Tray_Edit:
	openfile("Core\GlobalMenu.ahk")
Return

tsk_edit:
Run,  F:\Program Files\AutoHotkey\Scripts\chm\%A_ThisMenuItem%.chm
return

txt_edit:
Run, %A_ThisMenuItem%
return

openfile_edit:
openfile(A_ThisMenuItem)
return

RunEachLineMenu:
    WinGetTitle, title, A
    StringReplace, title, title, - Notepad++, , All
	
Menu eachlinemenu, Add, eachlinemenu, Menu_Tray_Exit
Menu eachlinemenu, ToggleEnable, eachlinemenu
Menu eachlinemenu, Default, eachlinemenu
scriptCount = 0
Loop, Read, %title%
{
    Menu eachlinemenu, add, %A_LoopReadLine%, PlayResult
}
Menu eachlinemenu, Show

return

PlayResult:
    command:= A_ThisMenuItem " version -v"
	 result := RunAndGetOutput(command)
	 GoSub, ActivateRunZ
    DisplayResult("执行结果 " . StrLen(result) . " ：`n`n" . result)

return

RunFolderList:
lnksavedir:="E:\EasyOSLink\Run\Folder" ;如何给Label传参数?设置一个global变量为何不行?
gosub DirFav
return

;作者@小古

  ;首先定义并创建目录快捷方式存放的文件夹：

  ;~ ;=====================================
  ;~ 用法：在上述变量对应的目录里右键拖入常用的文件夹的快捷方式（lnk文件），双击本ahk文件，即可弹出全部lnk绘成的Menu．点击即可打开．是一个目录收藏夹的功能．
  ;~ 说明：支持lnk分组，支持子目录，支持文件的lnk，也支持文件夹的lnk．自动过滤重复路径．
  
  ;~ ;=====================================
DirFav:
  Menu,opendir,add
  Menu,opendir,DeleteAll
ifnotexist %lnksavedir%
{
  msgbox,存放目录快捷方式的文件夹%LnkSaveDir%不存在，请修改源代码，并建立相应文件夹后重试！
return
}
else
{
 IfExist,%lnksavedir%\dirlist.txt
      FileDelete,%lnksavedir%\dirlist.txt
  Loop %lnksavedir%\*.lnk,,1
    {
      FileGetShortcut,%A_LoopFileFullPath%,,Outdir ;是文件的lnk，取其工作目录
      outtarget:=outdir
      If StrLen(outdir)=0
        {
          FileGetShortcut,%A_LoopFileFullPath%,Outtarget   ;是文件夹的lnk，取指向
        }
      ;MsgBox %OutTarget%
      FileAppend,%OutTarget%`n,%lnksavedir%\dirlist.txt
    }
  ;fileappend,关闭`n,%lnksavedir%\dirlist.txt
  Loop, Read, %lnksavedir%\dirlist.txt
    {
      Menu,opendir,add,%A_LoopReadLine%,doopen
    }
  ;msgbox %A_LoopReadLine%
  ;MsgBox % docopyitem[A_Index]
  menu,opendir,add
  menu,opendir,add,打开收藏夹目录,doopenlnksave
  Menu,opendir,add,关闭菜单,donothing
  Menu,opendir,add,关于DirFav,doabout
  Menu,opendir,show
Return
}
return 

doopen:
  ;msgbox % A_ThisMenuItem ;获取菜单上显示的路径文本，鸣谢@流彩
  IfExist %A_ThisMenuItem%
    {
      Run %A_ThisMenuItem%
    }
  Else
    {
      MsgBox,262208,提示：,无法打开该文件夹！%A_ThisMenuItem%,5
    }
      IfExist,%lnksavedir%\dirlist.txt
      FileDelete,%lnksavedir%\dirlist.txt
  Menu,opendir,DeleteAll
Return

doopenlnksave:
ifexist %lnksavedir%
  run %lnksavedir%
else
  msgbox 找不到该目录，请核对！
return

doabout:
msgbox,,关于DirFav,作者：危险胡、小古，邮件：huyaowen@qq.com
return

donothing:
Menu,copyto,add
Menu,copyto,DeleteAll
Return