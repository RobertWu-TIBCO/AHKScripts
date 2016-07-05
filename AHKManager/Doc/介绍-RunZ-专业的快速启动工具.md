快速启动工具可能大家都比较了解，简单地输入几个英文字母或者拼音缩写，就可以启动自己需要的软件。但程序员专用的快速启动工具你用过吗？

[RunZ](https://github.com/goreliu/runz/) 的定位和其他快速启动工具有所不同，它的特点是专业、高效，同时尽量提高易用性。文字的表达还是有些苍白无力的，下面演示一下 RunZ 的强大功能。

熟悉 Linux 的朋友应该都知道 ps 命令是用来查看进程的，kill 命令是根据 PID 杀死进程的。我们可以用 ps xx | grep 搜索到要找的进程，然后再通过管道将 PID 传给 kill 命令，将其杀死。但如果在 Windows 呢，是不是需要进任务管理器从头扫到尾，或者安装操作复杂的专业进程管理软件？

RunZ 借鉴了管道这一非常有用的技术，输入 ps（或 ListProcess，或 通过拼音首字母 jc 搜索）然后回车，就会看到所有进程，此时输入的字母相当于 grep。找到进程后，按 Ctrl + 回车，就相当于输入了管道，然后选择 KillProcess（杀死进程）命令，就可以将之前搜索到的进程杀死。

![杀死进程](Images/kill_process.gif)

我们再来看下细节。

这里涉及了两条命令，一条是 ListProcess，另一条是 KillProcess。

ListProcess 是用来查找进程的。当只输入 ListProcess 时，会显示所有进程，当 ListProcess 后添加参数后，则显示匹配到的进程。这里的匹配功能是比较强大的，支持 &（与）|（或）!（非）?(正则表达式模式）>（匹配模版）中文拼音首字母等，还可以在配置文件详细定制。

但除了直接在 ListProcess 后添加参数外，可以直接输入 ListProcess 回车，然后进入搜索模式，这时输入的任何内容都会被实时搜索和展示出来，如截图演示的那样。

找到进程后，按下 Ctrl + 回车，这时 RunZ 会将之前选择的结果保存，以便传递给管道后的下一条命令。这里需要注意的是按完之后，显示只有两个命令可以选择，一个是 ListProcess，另一个是 CountNumber。并未其他的都不能选择，输入任何内容都可以匹配其他命令。这两个预选命令是 ListProcess 指定的，如果需求杀死之前选择的进程，只需要按下回车。如果想查看选择了几个进程，可以按方向下键，或者 Ctrl + j，CountNumber 类似于 Linux 的 wc 命令。

可能有朋友对这个演示的内容比较感兴趣，但怀疑实现起来一定比较麻烦吧，比如我想实现另一个功能，也使用相同的操作方式。

RunZ 是支持插件的，而且插件写起来非常容易，拿上边的 ListProcess 和 KillProcess 来说：

这是 ListProcess 的完整代码，只有 7 行，用的是 AHK，RunZ 自身也是用 AHK 写的。

```
ListProcess:
    result := ""

    ; 这三行是用来获取进程列表的
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
        result .= "* | 进程 | " process.Name " | " process.CommandLine "`n"
    Sort, result

	; SetCommandFilter() 用来指定管道后的命令，用户也可以忽略它们来手动选择，| 表示或
    SetCommandFilter("KillProcess|CountNumber")
	; Arg 为输入参数
    ; AlignText() 用来对结果各列对齐
    ; FilterResult() 用来对结果过滤
    ; DisplayResult() 用来显示结果
    DisplayResult(FilterResult(AlignText(result), Arg))
	; TurnOnResultFilter() 用来打开结果搜索模式，用户按下回车后，就可以实时搜索进程
    TurnOnResultFilter()
return
```

KillProcess 就更简单了，只有 4 行：

```
KillProcess:
    args := StrSplit(Arg, " ")
    for index, argument in args
    {
        Process, Close, %argument%
    }
return
```

如果我想实现这样一个功能，计算剪切板包含特定内容的行数，具体应该如何去做呢：

只需要写这样一个 RunZ 插件，需要 UTF-8 BOM 格式，保存到 CountClipLine.ahk。然后右键发送到 RunZ，重启 RunZ 就可以安装上了。

```
; RunZ:CountClipLine
; 计算剪切板含特定内容的行数

CountClipLine:
    @("CountClipLineFun", "计算剪切板含特定内容的行数")
return

CountClipLineFun:
    SetCommandFilter("CountNumber")
    DisplayResult(FilterResult(clipboard, Arg))
    TurnOnResultFilter()
return
```

效果：

![计算剪切板含特定内容的行数](Images/count_clip.gif)

软件刚开发不久，可能有 bug，还在完善中，不知道大家是否感兴趣。

Github 地址: https://github.com/goreliu/runz/

