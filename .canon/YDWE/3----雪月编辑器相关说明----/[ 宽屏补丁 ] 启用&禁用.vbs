include "template.vbs"

'--------------------------
'      插件基础信息定义
'--------------------------
plugin_name = "宽屏补丁"
' -* 安装说明
plugin_msg_tip = "▲说明：" 
plugin_msg_tip = plugin_msg_tip + vbCrLf
plugin_msg_tip = plugin_msg_tip + "这个宽屏补丁彻底解决了“伪宽屏、强制拉伸”的问题，消除了画面变形，增大了游戏视野，游戏体验非常好，强烈推荐大家使用。" + vbCrLf
plugin_msg_tip = plugin_msg_tip + vbCrLf
plugin_msg_tip = plugin_msg_tip + "这款宽屏补丁来自：https://www.nexusmods.com/warcraft3/mods/12" + vbCrLf
plugin_msg_tip = plugin_msg_tip + vbCrLf
plugin_msg_tip = plugin_msg_tip + "▲注意：" + vbCrLf
plugin_msg_tip = plugin_msg_tip + vbCrLf
plugin_msg_tip = plugin_msg_tip + "这个宽屏补丁是可以在任意对战平台上正常使用的。" + vbCrLf
plugin_msg_tip = plugin_msg_tip + vbCrLf
plugin_msg_tip = plugin_msg_tip + "这个宽屏补丁只适用于这些版本的《魔兽争霸Ⅲ》：1.23a、1.24e、1.26a、1.27a、1.27b、1.28.0、1.28.2、1.28.4、1.28.5。" + vbCrLf
plugin_msg_tip = plugin_msg_tip + vbCrLf
plugin_msg_tip = plugin_msg_tip + "版本低于1.23a的《魔兽争霸Ⅲ》均无法识别这个宽屏补丁。" + vbCrLf
plugin_msg_tip = plugin_msg_tip + "版本高于1.28.5的《魔兽争霸Ⅲ》（即1.29.0和之后的所有版本）都自带原生宽屏，也就根本不需要这个宽屏补丁了。" + vbCrLf
plugin_msg_tip = plugin_msg_tip + vbCrLf + vbCrLf + "该补丁会造成关闭编辑器时崩溃导致不能及时关闭程序" + vbCrLf


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

	plugin_files.Add( vbs_path & "\plugins\war3Widescreen\RenderEdge_Widescreen.mix" )
	plugin_files.Add( war3_path & "\RenderEdge_Widescreen.mix" )

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