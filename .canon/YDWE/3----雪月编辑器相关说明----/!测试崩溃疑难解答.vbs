include "template.vbs"

msg = ""
do
	ver_War3 = getVersion(war3_path & "\war3.exe")
	ver_Game = getVersion(war3_path & "\game.dll")
	msg = msg & " ○ war3.exe版本：" & vbcrlf
	if ver_War3 <> ver_Game then
		msg = msg & "× war3.exe和game.dll版本不一致，请重新下载游戏。请勿使用版本转换器。" + vbcrlf
	elseif ver_War3 <> "1.27.0.52240" then
		msg = msg & "× war3.exe和game.dll版本不是1.27.0.52240，请重新下载游戏。请勿使用版本转换器。" + vbcrlf
	Else
		msg = msg & "√ " + ver_War3 + vbcrlf
	end if

	msg = msg & vbcrlf & " ○ Warcraft III.exe：" & vbcrlf
	if fs.FileExists(war3_path & "\Warcraft III.exe") then
		msg = msg & "× 魔兽目录存在Warcraft III.exe，如果冲突请删除该文件或改名。" + vbcrlf
	Else
		msg = msg & "√ 不存在" + vbcrlf
	end if

	msg = msg & vbcrlf & " ○ DZAPI插件：" & vbcrlf
	if fs.FileExists(war3_path & "\version.dll") then
		msg = msg & "× kk版编辑器不兼容DZAPI插件，请卸载DZAPI插件。" + vbcrlf
	Else
		msg = msg & "√ 未安装" + vbcrlf
	end if

	exit do
loop


MsgBox msg, vbInformation , "雪月 测试地图崩溃 检测"
'-------------------------------------------------------
Sub include(sInstFile)
Dim oFSO, f, s
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set f = oFSO.OpenTextFile(sInstFile)
s = f.ReadAll
f.Close
ExecuteGlobal s
End Sub