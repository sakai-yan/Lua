WScript.CreateObject("WScript.Shell").CurrentDirectory = CreateObject("Scripting.filesystemobject").GetFile(Wscript.ScriptFullName).ParentFolder
If Not WScript.Arguments.Named.Exists("elevate") Then
  CreateObject("Shell.Application").ShellExecute WScript.FullName _
    ,"""" & WScript.ScriptFullName & """" + " /elevate", "", "runas", 1
  WScript.Quit
End If

include "template.vbs"

'--------------------------
'      插件基础信息定义
'--------------------------
plugin_name = "Lua控制台"

' -* 安装说明
plugin_msg_tip = _
"开启后如果你启用了JAPI优化，则会显示Lua控制台，能看到一些debug信息，一般情况下不需要启用" _
+ chr(10) _
+ chr(10) _
+ "该版本主要新增了以下debug函数的中文支持:" _ 
+ chr(10) _
+ "assert,error,warn" _
+ chr(10) _
+ chr(10) _
+ "该版本需要引用编辑器内的文件，如安装时的编辑器目录无效后将会出错，如非特殊情况，强烈建议不要使用该版本，如发生错误请卸载插件使用另一个纯净版" _
+ vbcrlf _
+ vbcrlf _
+ "收到反馈该版本有[异次元]的bug,请使用另一版！" _


' -* 安装成功 提示
plugin_msg_install_success = "安装成功！"
' -* 安装失败 附加提示[失败时会提示哪些文件复制失败]
plugin_msg_install_defeat = ""

' -* 禁用成功 提示
plugin_msg_uninstall_success = "禁用成功！"
' -* 禁用失败 附加提示[失败时会提示哪些文件以及目录删除失败]
plugin_msg_uninstall_defeat = ""


'--------------------------
'      插件文件信息定义
'--------------------------

'   ***  定义插件文件  ***
' 一个 源文件 紧跟一个 目标文件

plugin_files.Add( vbs_path & "\plugins\LuaDebug\GBKsupport.lua" )
plugin_files.Add( "C:\XGEDITOR_DEBUG.lua" )


'   ***  定义插件文件夹  ***
' 一个 源目录 紧跟一个 目标目录

' plugin_folders.Add( ydwe_path & "\XueYue\JassDebug\" )
' plugin_folders.Add( war3_path & "\" )

'   ***  定义插件压缩包  ***
' 一个 zip源文件 紧跟一个 解压目标目录

'plugin_zips.Add( vbs_path & "\plugins\LYFinder\LYFinder.zip" )
'plugin_zips.Add( ydwe_path & "\plugin\LYFinder" )

' -> 插件是否已安装 检查条件
Function isInstalled()
	isInstalled = fs.FileExists( plugin_files(1) )
End Function


' -> 额外的安装内容[安装时会调用]
Function extraInstall()
	'If ws.RegRead( reg_path & "\Allow Local Files" ) <> 1 Then
	'	Call ws.RegWrite( reg_path & "\Allow Local Files" , 1 )
	'End If
	Const ForReading = 1
	Const ForWriting = 2
	Dim objFile,strText,strNewText
	Set objFile = fs.OpenTextFile("C:\XGEDITOR_DEBUG.lua",ForReading)
	strText = objFile.ReadAll
	objFile.Close

	strNewText = Replace(strText, "##VBS_REPLACE_1##", vbs_path & "\plugins\LuaDebug")

	Set objFile = fs.OpenTextFile("C:\XGEDITOR_DEBUG.lua",ForWriting)
	objFile.WriteLine strNewText
	objFile.Close

	extraInstall = "写入插件路径完成"
End Function

' -> 额外的卸载内容[卸载时会调用]
Function extraUninstall()

	extraUninstall = ""
End Function

' -> 载入安装询问
Main()

'-------------------------------------------------------
Sub include(sInstFile)
Dim oFSO, f, s
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set f = oFSO.OpenTextFile(sInstFile)
s = f.ReadAll
f.Close
ExecuteGlobal s
End Sub