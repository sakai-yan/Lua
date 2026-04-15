include "template.vbs"

'--------------------------
'      插件基础信息定义
'--------------------------
plugin_name = "大内存魔兽"
' -* 安装说明
plugin_msg_tip = "让魔兽能够使用更多的内存以防止崩溃" + vbCrLf

' -* 安装成功 提示
plugin_msg_install_success = "结果请看附加内容！"
' -* 安装失败 附加提示[失败时会提示哪些文件复制失败]
plugin_msg_install_defeat = ""

' -* 禁用成功 提示
plugin_msg_uninstall_success = "结果请看附加内容！"
' -* 禁用失败 附加提示[失败时会提示哪些文件以及目录删除失败]
plugin_msg_uninstall_defeat = ""


'--------------------------
'      插件文件信息定义
'--------------------------

bak_exe = war3_path &  "\war3MoreMem_orig.bak"
war3_exe = war3_path & "\war3.exe"

'   ***  定义插件文件  ***
' 一个 源文件 紧跟一个 目标文件

	'plugin_files.Add( ydwe_path & "\XueYue\war3MoreMem\WarcraftHelper_fps_only.mix" )
	'plugin_files.Add( war3_path & "\WarcraftHelper_fps_only.mix" )


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
	isInstalled =  fs.FileExists( bak_exe  )
End Function


' -> 额外的安装内容[安装时会调用]
Function extraInstall()
	fs.CopyFile war3_exe , bak_exe 
	if Not fs.FileExists(bak_exe) then
		extraInstall = "备份原魔兽失败！已取消安装！"
		exit function
	end if

	fs.CopyFile vbs_path & "\plugins\war3MoreMem\War3.txt"  , war3_exe 

	if Not fs.FileExists(war3_exe) then
		extraInstall = "安装失败！"
		exit function
	end if
	
	extraInstall = "大内存魔兽安装成功！"
End Function

' -> 额外的卸载内容[卸载时会调用]
Function extraUninstall()
	fs.DeleteFile war3_exe 
	if fs.FileExists(war3_exe) then
		extraUninstall = "删除大内存魔兽失败！已取消卸载！"
		exit function
	end if

	fs.MoveFile bak_exe, war3_exe 
	if not fs.FileExists(war3_exe) then
		extraUninstall = "还原魔兽失败！请手动还原！" + vbCrLf
		extraUninstall = extraUninstall + "将 " + bak_exe + vbCrLf
		extraUninstall = extraUninstall + "重命名为 "  + vbCrLf
		extraUninstall = extraUninstall + + war3_exe + vbCrLf
		exit function
	end if

	extraUninstall = "还原完成！"
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