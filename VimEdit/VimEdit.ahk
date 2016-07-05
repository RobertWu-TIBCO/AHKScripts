#SingleInstance force 

;Menu, Tray, Icon,vimEdit.ico
Menu, Tray, Icon,xvim.ico

^i::
    tmpfile=%A_ScriptDir%\ahk_text_edit_in_vim.txt
    gvim=F:\Program Files\Vim\vim74\gvim.exe
    WinGetTitle, active_title, A
	;判断文件类型
filetype=%active_title%
IfInString, active_title, SQL 查询分析器
filetype=sql
    clipboard =
        ; 清空剪贴板
    send ^a
        ; 发送 Ctrl + A 选中全部文字
    send ^c
        ; 发送 Ctrl + C 复制
    clipwait
        ; 等待数据进入剪贴板
    FileDelete, %tmpfile%
    FileAppend, %clipboard%, %tmpfile%
    runwait, %gvim% "%tmpfile%" +
    fileread, text, %tmpfile%
    clipboard:=text
        ; 还原读取的数据到剪贴板
    winwait %active_title%
        ; 等待刚才获取文字的窗口激活
    send ^v
        ; 发送 Ctrl + V 粘贴
return 