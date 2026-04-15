include "template.vbs"

'--------------------------
'      插件基础信息定义
'--------------------------
plugin_name = "帧率突破60插件"
' -* 安装说明
plugin_msg_tip = "燃烧你的显卡吧！让魔兽的帧率突破60帧！" + vbCrLf

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

	plugin_files.Add( vbs_path & "\plugins\war3FPS\WarcraftHelper_fps_only.mix" )
	plugin_files.Add( war3_path & "\WarcraftHelper_fps_only.mix" )


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
	isInstalled =  fs.FileExists( plugin_files(1) )
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