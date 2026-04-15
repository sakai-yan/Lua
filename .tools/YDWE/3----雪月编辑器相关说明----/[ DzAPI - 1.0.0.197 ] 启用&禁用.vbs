include "template.vbs"

'--------------------------
'      插件基础信息定义
'--------------------------
plugin_name = "DzAPI"
plugin_version = "1.0.0.197"
' -* 安装说明
plugin_msg_tip = "自动的将插件复制到魔兽，免去手动复制过程，你也可以在以下目录中找到插件包，手动解压到魔兽目录" + vbCrLf + vbCrLf  + vbs_path + "\plugins\DzAPI" _
+ vbcrlf+ vbcrlf +  "该KK版雪月编辑器与DzAPI冲突!!!!"_
+ vbcrlf+ vbcrlf +  "不需要安装该插件，否则可能无法测试"

plugin_msg_uninstall_tip = ""

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
dim file(3)

file(0) = "version.dll"
file(1) = "dz_w3_plugin_x64.dll"
file(2) = "dz_w3_plugin.dll"

'   ***  定义插件文件  ***
' 一个 源文件 紧跟一个 目标文件

For i = 0 To 2
	plugin_files.Add( ydwe_path & "\XueYue\dzPlugin\" & file(i) )
	plugin_files.Add( war3_path & "\" & file(i) )
Next

'   ***  定义插件文件夹  ***
' 一个 源目录 紧跟一个 目标目录

' plugin_folders.Add( ydwe_path & "\XueYue\JassDebug\" )
' plugin_folders.Add( war3_path & "\" )

'   ***  定义插件压缩包  ***
' 一个 zip源文件 紧跟一个 解压目标目录

'plugin_zips.Add( vbs_path & "\plugins\DzAPI\Lua_1.0.0.168.zip" )
'plugin_zips.Add( war3_path & "\" )

' -> 插件是否已安装 检查条件
Function isInstalled()
	For i = 0 To 2
		If Not fs.FileExists( war3_path & "\" & file(i) ) Then
			isInstalled = true
			Exit For
		else
			plugin_msg_uninstall_tip = "该KK版雪月编辑器与可能存在DzAPI冲突" _
			+ chr(10) +"当前已安装:" + getVersion(war3_path & "\dz_w3_plugin.dll") _
			+ chr(10) + chr(10) + "是否禁用当前版本？" + chr(10)+ "禁用前请先关闭编辑器，否则正在被使用的插件文件无法删除."
			Exit For
		End if
	Next

	isInstalled = Not isInstalled
End Function


' -> 额外的安装内容[安装时会调用]
Function extraInstall()
	'If ws.RegRead( reg_path & "\Allow Local Files" ) <> 1 Then
	'	Call ws.RegWrite( reg_path & "\Allow Local Files" , 1 )
	'End If
	extraInstall = ""
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