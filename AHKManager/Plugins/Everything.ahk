﻿; RunZ:Everything
; 使用 Everything 搜索
; 需要 Everything 在运行才可以用

Everything:
    if (!FileExist(A_ScriptDir "\Lib\Reserved\es.exe"))
    {
        return
    }

    @("SearchWithEverything", "使用 Everything 搜索")
    @("sea", "Robert Everything 搜索")
return

; 功能待完善
SearchWithEverything:
    result := RunAndGetOutput(A_ScriptDir "\Lib\Reserved\es.exe -n 15 " Arg)
    DisplayResult(result)
    TurnOnRealtimeExec()
    SetCommandFilter("Open")
return

sea:
   Run,"F:\Program Files\Everything\Everything.exe" -s %Arg%
return