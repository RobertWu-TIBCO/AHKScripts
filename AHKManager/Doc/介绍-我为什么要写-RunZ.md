我们知道现有的知名快速启动工具有：

* [Launchy](http://launchy.net/)
* [ALTRun](https://code.google.com/archive/p/altrun/)
* [ALMRun](http://almrun.chenall.net/)
* [Wox](https://github.com/Wox-launcher/Wox)
* [Executor](http://executor.dk)

等等，不知名的更多，甚至系统自带的`Win + r`也能让一些人满意。想必总有一个可以满足自己的需求，那我为什么又写一个新的 RunZ 呢？

就我个人而言，对快速启动工具的最基本需求是：

1. 体积小，资源占用低，最好可以不常驻运行。
2. 项目尚有人维护，有反馈渠道。
3. 可扩展性强，支持方便地用脚本扩展功能。

这三个要求并不算高。

比如第一点。因为它名字就占了“快速”两字，自然唯快不破。如果自身启动不能做到快速，并且常驻运行后占用几十兆甚至更多内存，我是无法接受的。所以 Wox 等工具虽然功能上很强大，但我还是选择忽略掉了。

再如第二点。人无完人，软件自然也无完软件，包含 bug 毫不稀奇。但如果软件已经没人维护了，即使包含了一个小 bug，就很让人头疼了，更不用说接受新需求了。Launchy、ALTRun 和 Executor 最近更新时间都是几年前，而且基本上不会再升级了，这是很难让人放心使用的。

至于第三点。如果一个软件不支持插件扩展，即使自身功能很多，也是“死”的，只能实现作者考虑到的功能，考虑不到的自然无从谈起。Launchy 支持插件扩展，但需要复杂的开发环境。ALTRun 和 Executor 不支持扩展，只能通过配置外置命令勉强应付。ALMRun 支持 Lua 扩展，Wox 支持 Python 扩展。

所以总体上 ALMRun 是最能满足我的需求的，我也用了一段时间。但让我放弃的原因是，发现一些小问题，如果要调试的话，编译 ALMRun 需要安装体积庞大的 Visual Studio，而且 ALMRun 是用 7000 多行 C++ 代码实现的，维护成本很高。使用 Lua 语言写扩展的主要问题在于 API 稀少，如果要调用 Windows API 则十分麻烦，写起扩展来捉襟见肘。综合考虑后，我半夜未眠用手机记下功能点，然后接下来的几天写下了这个 RunZ。

## RunZ 特点

正如之前我提到的三个主要需求：

1. 体积小，资源占用低，最好可以不常驻运行。
2. 项目尚有人维护，有反馈渠道。
3. 可扩展性强，支持脚本扩展功能。

RunZ 自然可以满足。

RunZ 是用 AHK 所写，包含 AHK 解释器也只有 1.4M，核心代码只有千余行。运行后占用内存不足 10M，而且可以常驻或非常驻运行，随启随用，用毕退出，毫无延迟。

因为 RunZ 自身是 AHK 所写，扩展自然也用 AHK。AHK 虽然功能上远没有 C++、Python、C# 之流强大，性能上也不出色，但有着其他语言都没有的优点：

1. 开发环境简单。只需要一个不足 1M 的解释器和一个顺手的编辑器，就可以开发了。
2. API 丰富。AHK 提供了很多桌面软件需要用到的 API，而且调用 Windows API 非常方便，这是 Python、Ruby、JavaScript、Perl、Visual Basic Script 等脚本语言所无法比拟的。
3. AHK 对热键绑定有专门支持，写起来非常容易，而这在其他语言基本上都要费费尽周折。

在功能上，RunZ 也有一些与众不同的特点：

### 界面简单

和很多酷炫的快速启动工具相比，RunZ 的界面简单到有点寒酸，只有三个文本框，第一个用来输入，第二个用来展示功能列表，第三个用来展示当前功能详情。

![主界面1](Images/main1.png)

如果感觉底部的文本框也多余，可以在配置文件中去掉：

![主界面2](Images/main2.png)

操作起来也很简单，回车 执行当前命令，上下方向键或`Ctrl + j`和`Ctrl + k`可以移动当前对应的命令，`Alt + 序号`可以直接执行对应命令。

按`F1`可显示更多帮助，按`Shift + F1`可以打开置顶的帮助提示。

![帮助界面](Images/help.png)

不支持鼠标右键操作，所有操作都使用按键。也没有配置界面，可以按`F2`直接修改配置文件，其中有详细的注释，配置示例：

```
﻿[Config]
RunIfOnlyOne=0
; 如果结果中只有一个则直接运行
SearchFileDir=A_ProgramsCommon | A_StartMenu
; 搜索的目录，可以使用 全路径 或 ahk 以 A_ 开头的变量，必须以 " | " 分隔
SearchFileType=*.lnk | *.exe
; 搜索的文件类型，必须以 " | " 分隔
SearchFileExclude=卸载
; 排除的文件，正则表达式
SearchFullPath=0
; 搜索完整路径，否则只搜文件名
TCMatchPath=Lib\TCMatch\tcmatch.dll
; tcmatch.dll 地址，如果没有则使用 InStr 匹配
SaveInputText=0
; 退出时保存编辑框内容
RunOnce=0
; 运行一次命令就退出，对展示信息的命令无效
TCPath=c:\totalcmd\totalcmd.exe
; TotalCommander 路径，如果为空则使用资源管理器打开
RunInBackground=1
; 在后台运行
LoadControlPanelFunctions=1
; 加载控制面板中的功能
ExitIfInactivate=0
; 窗口失去焦点后窗口关闭，启用后窗口置顶显示功能失效
WindowAlwaysOnTop=0
; 窗口置顶显示
SaveHistory=1
; 记录历史
HistorySize=26
; 记录历史的数量
AutoRank=1
; 自动根据使用频率调节顺序，因为效率问题，结果不能实时体现，重启或 ctrl + r 后更新


; 图形界面相关参数
[Gui]
ShowTrayIcon=1
FontName=宋体
FontSize=12
WidgetWidth=600
EditHeight=25
DisplayAreaHeight=250
HideDisplayAreaVScroll=0
; 不显示纵向滚动条
ShowCurrentCommand=1
; 在下方显示当前命令
FirstChar=a
; 列表第一行的首字母或数字
DisplayRows=15
; 在列表中显示的行数
DisplayCols=68
; 在列表中显示的文字列数（多出的会被截断），注意包含中文的情况
HideTitle=1
; 隐藏标题栏


; 这里的 command 优先显示，请在下边的 [Command] 后边添加
;
; 文件类型（直接使用 AHK 的 Run() 运行）：
; file | 文件路径 | 注释
; 如：
; file | notepad | 记事本
; 注释里可以包含要搜索的字符串，也可以没有：
; file | c:\mine\mine.exe
; 文件路径也可以是网址：
; file | www.baidu.com | 百度 bd
; 如果需要在指定目录运行软件，该配置不支持，请直接在 UserFunctions.ahk 添加
;
; cmd 类型，在 cmd.exe 运行命令，运行后会自动暂停：
; 如：
; cmd | ipconfig | 查看 IP 地址
[Command]

; 映射 RunZ 自身使用的按键：
; key=label
; 等同于
; Hotkey, key, label
; 如（可使用 Test 测试）：
; f1=Test
; 具体功能请直接在代码里搜 Hotkey 对应的标签
; key=Default 可取消代码中的按键映射
; 注意优先级比默认的 Alt + 字母数字 系列按键高，如无特殊原因不要修改 Alt 的映射
[Hotkey]

; 语法和 [Hotkey] 一样，但作用范围是全局的
[GlobalHotkey]
#j=ActivateWindow
!space=ActivateWindow
```

完整配置请参考`Conf\RunZ.ini.help.txt`，如果`Conf`目录中无`RunZ.ini`，RunZ 会自动将此文件复制为`RunZ.ini`。

## 搜索功能强大

RunZ 使用 [tcmatch.dll](http://totalcmd.net/plugring/Google_like_QS.html) 来搜索，支持拼音首字母搜索、模糊匹配、正则表达式等功能。发布包自带 tcmatch.dll，使用 TotalCommander 的用户也可以在配置里将 tcmatch.dll 路径指向 TotalCommander 所在目录，以便共用 tcmatch.ini。

很多人使用 tcmatch.dll 的原因是拼音搜索，但 tcmatch.dll 的功能不仅于此，这里简单普及一下，来看 tcmatch.ini，我添加了部分常用选项的注释：

```
[general]
simple_search_activate_char=
; 简单搜索前导符号
regex_search_activate_char=?
; 正则搜索前导符号
leven_search_activate_char=<
srch_activate_char=*
preset_activate_char=>
; 加载搜索模版前导符号
simple_search_match_beginning_activate_char=^
and_separator_char=" "
; 与 关系符号
or_separator_char=|
; 或 关系符号
wdx_separator_char=/
negate_char=!
case_sensitive=0
; 大小写敏感
allow_empty_result=0
filter_files_and_folders=3
match_beginning=0
; 首字符匹配开关
use_pinyin=1
; 启用中文拼音首字母匹配
use_korean=0
; 启用韩文
[gui]
override_search=1
invert_result=0
one_line_gui=1
show_presets=0
[presets]
e=.exe|.bat|.com|.scr|.lnk
; 搜索模版，输入 >e 即可搜索对应字符串
[replace]
chars1=》|>
; 搜索前先替换字符，可用于中文输入法没切换的情况
chars2=？|?
```

更多功能等待大家探索，另外 tcmatch.dll 自带 tcmatch.exe，可用于在图形界面修改 tcmatch.ini，因为体积所限我没有将其集成在内，需要的用户可自行去 [官网](http://totalcmd.net/plugring/Google_like_QS.html) 下载。tcmatch.dll 的搜索功能，比几乎所有现有快速启动工具的搜索功能要更加强大和灵活。

## 排序功能灵活方便

除了按字词搜索，另一个非常常用的功能是排序，当搜索结果出现多条时，显示的顺序就非常关键了。

RunZ 支持自动按执行频率调整权重，也支持手动按快捷键调整（`ctrl + n`权重加一，`ctrl + p`权重减一）。

除了权重，有时我们需要查看或执行某一条历史命令，可以按`ctrl + h`查看历史。

此外也可以直接修改配置文件`Conf\RunZ.auto.ini`来调整命令的权重和历史记录，但注意要在 RunZ 关闭时调整，以免被覆盖。

## 热键功能

从前边贴出的配置文件可以看出，RunZ 可以灵活为各种功能配置全局热键。RunZ 自身的所有功能热键也可以在配置文件调整。写扩展时也可以通过参数绑定热键。

## 灵活的配置

RunZ 的配置文件很灵活，支持丰富的选项，比如是否显示托盘图标，是否运行一次命令就退出，是否失去焦点就退出，是否搜索结果只有一条时自动运行，是否运行在后台等等。之后我也会不断添加其他有用的选项。

## 自带一些十分方便的扩展

有道在线词典和翻译：

![词典1](Images/dict1.png)

![词典2](Images/dict2.png)

功能强大的计算器，不只支持简单的四则计算：

![计算器](Images/calc.png)

生成二维码，单击二维码可以保存到文件：

![生成二维码](Images/qr.png)

控制面板相关功能：

![控制面板](Images/control.png)

更多其他内置功能：

![更多内置功能](Images/more.png)

## 可以很容易地扩展

内置功能只是我根据喜好添加的，别人未必用的到。但如果想为 RunZ 新增功能，也是非常方便的。

`Conf\UserFunctions.ahk.help.txt`文件中有几个例子，直接将此文件复制为`UserFunctions.ahk`即可使用：

```
﻿; 复制此文件为 UserFunctions.ahk 即可使用

global Arg

UserFunctions:
    ; 第一个参数为标签名
    ; 第二个为搜索项（内容随意）
    ; 第三个参数为 true 时，当搜索无结果也会显示，默认为 false
    ; 第四个参数为绑定的全局热键，默认无
    @("UserTest1", "用户测试（ut1）", false, "#p")
    @("UserTest2", "用户测试（ut2）")
    @("UserTest3", "用户测试（ut3）")
    @("UserTest4", "用户测试（ut4）")
    @("UserTest5", "用户测试（ut5）")
return

UserTest1:
    ; 在指定目录启动软件
    Run, notepad, c:
return

UserTest2:
    ; DisplayResult(text) 内置函数用来在列表框展示文本
    DisplayResult(clipboard)
return

UserTest3:
    ; RunWithCmd(cmd) 函数用来在 cmd.exe 里运行命令并暂停
    RunWithCmd("ipconfig")
return

UserTest4:
    ; Arg 是用户在编辑框输入的参数，输入的内容空格之后为参数，可根据自己的喜好分割
    MsgBox, % Arg
return

UserTest5:
    ; UrlDownloadToString(url) 内置函数用来下载文件内容到字符串
    DisplayResult(UrlDownloadToString(Arg))
return
```

可以使用 AHK 强大的 API 完成各种自己想要的功能。

## 关于名字

前三个字母 Run 自然无需解释，最后一个 Z，是字母表最后一个字母。RunZ 的含义就是一步运行到位，不需要去各种地方找软件来运行。

## 接受新需求

可以查看 [更新历史](https://github.com/goreliu/runz/wiki/HISTORY) 中是否有你感兴趣的功能。

如果有新需求，或者发现 bug，可以直接和我反馈，在 [Issues](https://github.com/goreliu/runz/issues) 页面添加，我会及时回复。
