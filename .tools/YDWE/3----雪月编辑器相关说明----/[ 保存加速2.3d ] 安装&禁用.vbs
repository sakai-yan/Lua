Set fs = CreateObject("Scripting.FileSystemObject")
Set f = fs.GetFile(WScript.ScriptFullName)

Set ws = WScript.CreateObject("WScript.Shell")
ws.CurrentDirectory = f.ParentFolder

' f.ParentFolder

'msgbox WScript.Path + vbCrlf + f.ParentFolder
'msgbox CStr(WScript.Arguments.Length)
include "template.vbs"

Set WshShell = WScript.CreateObject("WScript.Shell")
If WScript.Arguments.Length = 0 Then
    Set ObjShell = CreateObject("Shell.Application")
    ObjShell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ 1",  "", "runas", 1
    WScript.Quit
End If

'--------------------------
'      插件基础信息定义
'--------------------------
plugin_name = "保存加速 2.3d"
' -* 安装说明
plugin_msg_tip = "该插件是较稳定的最新版本，支持增量、快速保存，加快地图保存速度" 

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

'plugin_files.Add( vbs_path & "\plugin\JassDebug\JassDebug.asi" )
'plugin_files.Add( war3_path & "\JassDebug.asi" )


'   ***  定义插件文件夹  ***
' 一个 源目录 紧跟一个 目标目录

' plugin_folders.Add( ydwe_path & "\XueYue\JassDebug\" )
' plugin_folders.Add( war3_path & "\" )

'   ***  定义插件压缩包  ***
' 一个 zip源文件 紧跟一个 解压目标目录

plugin_zips.Add( vbs_path & "\plugins\MapHelper\2.3d.zip" )
plugin_zips.Add( war3_path )

' -> 插件是否已安装 检查条件
Function isInstalled()
	isInstalled = fs.FileExists( war3_path & "\MapHelper.asi" )
End Function


' -> 额外的安装内容[安装时会调用]
Function extraInstall()

	Call ws.RegWrite( reg_path & "\Allow Local Files" , 1 )

	extraInstall = "注册表: 允许魔兽读取本地文件"
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