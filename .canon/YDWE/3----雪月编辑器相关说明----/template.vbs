'  **************************
'	  自动安装插件模板 1.0
'	by 雪月灬雪歌
'  **************************

'--------------------------
'        环境初始化
'--------------------------
Set fs = CreateObject("Scripting.filesystemobject")
Set ws = WScript.CreateObject("WScript.Shell")
Set objShell = CreateObject("Shell.Application")


reg_path = "HKEY_CURRENT_USER\Software\Blizzard Entertainment\Warcraft III"
war3_path = ws.RegRead( reg_path & "\InstallPath" )
ydwe_path = fs.GetFile(Wscript.ScriptFullName).ParentFolder
vbs_path = fs.GetFile(Wscript.ScriptFullName).ParentFolder

do
	if fs.FileExists (ydwe_path + "\bin\worldedit.exe")  then
		exit do
	end if

	if fs.GetFolder(ydwe_path).ParentFolder is nothing then
		MsgBox "找不到编辑器路径，请确认脚本在编辑器目录或子目录下"
		WScript.Quit
	end if

	ydwe_path = fs.GetFolder(ydwe_path).ParentFolder
loop


Set plugin_files = CreateObject("System.Collections.ArrayList")
Set plugin_folders = CreateObject("System.Collections.ArrayList")
Set plugin_zips = CreateObject("System.Collections.ArrayList")

plugin_msg_uninstall_tip = ""
plugin_version = ""

' oooooooooooooooooooooooooooooooooooooooooooooooo
'					程序入口
' oooooooooooooooooooooooooooooooooooooooooooooooo

Function Main()

	If plugin_files.Count mod 2 = 1 Then
		plugin_files.removeAt(plugin_files.Count)
	End If
	If plugin_folders.Count mod 2 = 1 Then
		plugin_folders.removeAt(plugin_folders.Count)
	End If

	Dim SelectValue
	If Not isInstalled() Then
		msg = "你确定要安装[ " + plugin_name + " ]吗?" + Chr(10) & Chr(10) & Chr(10)
		if StrComp (plugin_msg_tip, "" ) Then
			msg = msg + plugin_msg_tip & Chr(10) & Chr(10) & Chr(10) & "你确定要继续安装吗?"
		end if

		SelectValue = Msgbox (msg, vbyesno + vbExclamation, plugin_name + plugin_version +" 安装确认" )

		If SelectValue = 6 Then
			Call install()
			
		ElseIf SelectValue = 7 Then
			'取消安装
		End If

	Else
		' v 
		' >  反安装插件
		' ^
		if plugin_msg_uninstall_tip = "" Then
			msg = "检测到你已经安装[ " + plugin_name + " ]" + Chr(10) & Chr(10) 
			msg = msg + "此次是否要禁用[ " + plugin_name + " ] ?" & Chr(10)
			msg = msg + "禁用前请先关闭编辑器，否则正在被使用的插件文件无法删除."
		Else
			msg = plugin_msg_uninstall_tip & Chr(10)
		end if
		
		SelectValue = Msgbox (msg , vbyesno + vbQuestion, plugin_name + " 禁用确认")

		If SelectValue = 6 Then

			call uninstall()

		End If

	End If
End Function
' ==================================================================



' -> 安装过程
Sub install()
	Dim i
	Dim iMax
	err_file = 0
	err_folder = 0
	err_zip = 0
	err_extra = 0
	errMsg = ""

	iMax = plugin_files.Count / 2
	For i = 0 To iMax - 1
		source = plugin_files(i * 2)
		target = plugin_files(i * 2 + 1)
		Call fs.CopyFile ( source, target  )
		If Not fs.FileExists( target ) Then
			err_file = err_file + 1
			errMsg = errMsg + "文件: " + target + vbCrLf
		End if
	Next

	iMax = plugin_folders.Count / 2
	For i = 0 To iMax - 1
		source = plugin_folders(i * 2)
		target = plugin_folders(i * 2 + 1)
		If Not fs.FolderExists( target ) Then
			fs.CreateFolder( target )
		End If
		Call fs.CopyFolder ( source, target  )
		If Not fs.FolderExists( target ) Then
			err_folder = err_folder + 1
			errMsg = errMsg + "目录: " + target + vbCrLf
		End if
	Next

	iMax = plugin_zips.Count / 2
	For i = 0 To iMax - 1
		source = plugin_zips(i * 2)
		target = plugin_zips(i * 2 + 1)
		Call UnZip ( source, target  )
		' zip无法验证是否解压成功(遍历文件浪费时间)
		' 需要重写CopyHere 自己 Copy
		'If Not fs.FolderExists( target ) Then
		'	err_zip = err_zip + 1
		'	errMsg = errMsg + "zip: " + target + vbCrLf
		'End if
	Next
	ret_extra = extraInstall()
	if VarType (ret_extra) <= 1 then
		err_extra = err_extra + 1
	end if

	msg = ""
	button = 0 + 64 + 4096
	If err_file + err_folder + err_zip + err_extra > 0 Then
		msg = msg + "安装插件过程中发生错误！" + vbCrLf

		msg = msg + plugin_msg_install_defeat + vbCrLf

		msg = msg  + errMsg
		button = vbCtritical
	Else
		msg = plugin_msg_install_success + vbCrLf + vbCrLf + msg
	End if

	count = plugin_files.Count / 2
	msg = msg + "复制文件:  " + cstr( count - err_file ) + "  /  " + cstr(count) + vbCrLf

	count = plugin_folders.Count / 2
	msg = msg + "复制文件夹:  " + cstr( count - err_folder ) + "  /  " + cstr(count) + vbCrLf

	count = plugin_zips.Count / 2
	msg = msg + "解压zip:  " + cstr( count - err_zip ) + "  /  " + cstr(count) + vbCrLf

	msg = msg + vbCrLf + "附加内容: " + vbCrLf + ret_extra + vbCrLf


	msgbox msg + "                                                               ", button,  plugin_name + " 安装结果"
End Sub

' -> 卸载过程
Sub uninstall()
	Dim iMax
	err_file = 0
	err_folder = 0
	err_zip = 0
	err_extra = 0

	errMsg = ""

	iMax = plugin_files.Count / 2
	For i = 0 To iMax - 1
		source = plugin_files(i * 2)
		target = plugin_files(i * 2 + 1)

			Call delFile ( target  )

			If fs.FileExists( target ) Then
				err_file = err_file + 1
				errMsg = errMsg + "文件: " + target + vbCrLf
			End if

	Next


	' 删除目录需要特殊处理，参照原目录来删除目标目录的文件，而非直接删除目录
	iMax = plugin_folders.Count / 2
	For i = 0 To iMax - 1
		source = plugin_folders(i * 2)
		target = plugin_folders(i * 2 + 1)
		dim filelist
		call listFolder( source, filelist )
		if filelist.Count > 0 then
			b = false
			For j = 0 To filelist.Count - 1
				filename = target + "\" + filelist(j)


					Call delFile ( filename  )

					If fs.FileExists( target ) Then

						if Not b then
							b = true
							err_folder = err_folder + 1
							errMsg = errMsg + "目录: " + target + vbCrLf
						end if

						err_file = err_file + 1
						errMsg = errMsg + "  -> " + filename + vbCrLf
					End if


			Next

		end if
		
	Next

	' 压缩包需要特殊处理
	iMax = plugin_zips.Count / 2
	For i = 0 To iMax - 1
		source = plugin_zips(i * 2)
		target = plugin_zips(i * 2 + 1)
		dim ziplist
		call listZip( source, ziplist )
		if ziplist.Count > 0 then
			b_folder = false
			b_zip = false
			For j = 0 To ziplist.Count - 1
				filename = target + "\" + ziplist(j)

					Call delFile ( filename  )

					If fs.FileExists( target ) Then

						if Not b_zip then
							b_zip = true
							err_zip = err_zip + 1
							errMsg = errMsg + "zip: " + ziplist(j) + vbCrLf
						end if

						if Not b_folder then
							b_folder = true
							err_folder = err_folder + 1
							errMsg = errMsg + "->目录: " + target + vbCrLf
						end if

						err_file = err_file + 1
						errMsg = errMsg + "   >> " + filename + vbCrLf

					End if


				
			Next

		end if
		
	Next

	ret_extra = extraUninstall()
	if VarType (ret_extra) <= 1 then
		err_extra = err_extra + 1
	end if

	msg = ""
	button = 0 + 64 + 4096
	If err_file + err_folder + err_zip > 0 Then
		msg = msg + "禁用插件过程中发生错误！" + vbCrLf

		msg = msg  + errMsg
		button = vbCtritical
	Else
		msg = plugin_msg_uninstall_success + vbCrLf + vbCrLf + msg
	End if

	msg = msg + plugin_msg_uninstall_defeat + vbCrLf

	count = plugin_files.Count / 2
	msg = msg + "删除文件:    " + cstr( count - err_file ) + "   /   " + cstr(count) + vbCrLf

	count = plugin_folders.Count / 2
	msg = msg + "删除文件夹:    " + cstr( count - err_folder ) + "   /   " + cstr(count) + vbCrLf

	count = plugin_zips.Count / 2
	msg = msg + "反解压缩:    " + cstr( count - err_zip ) + "   /   " + cstr(count) + vbCrLf

	msg = msg  + vbCrLf  + vbCrLf + "附加内容: "  + vbCrLf + ret_extra + vbCrLf

	msgbox msg + "                                                               ", button,  plugin_name + " 禁用结果"

End Sub



Sub private_SearchFolder(folderPath, out_filelist, length)
	Set ObjFolder = fs.GetFolder(folderPath)
	Set SubFolders = ObjFolder.SubFolders

	Set files = fs.GetFolder(folderPath).files
	For Each file In files
		'file = folderPath + "\" + file
		'MsgBox right(file, len(file) - length)
		out_filelist.Add right(file, len(file) - length)
	Next

	if SubFolders.Count = 0 then
		exit Sub
	end if

	For Each subFolder In SubFolders
		Call private_SearchFolder(subFolder.path, out_filelist, length)
	Next
End Sub

Sub listFolder(folderPath, out_filelist)
	Set out_filelist = CreateObject("System.Collections.ArrayList")
	length = len( folderPath ) + 1
	Call private_SearchFolder(folderPath, out_filelist, length)
End Sub

Function private_listZip( items, parentFolder, out_filelist )
	For Each file in items
		if file.IsFolder then
			if StrComp(parentFolder, "") then
				file = parentFolder + "\" + file
			end if

			call private_listZip( objShell.NameSpace(file).Items() , file, out_filelist)

		else

			if StrComp(parentFolder, "") then
				file = parentFolder + "\" + file
			end if
			out_filelist.Add file
		end if
		
	Next
End Function

Function listZip(ByVal myZipFile, out_filelist)
	Set objSource = objShell.NameSpace(myZipFile)
    Set objFolderItem = objSource.Items()

	Set out_filelist = CreateObject("System.Collections.ArrayList")
	call private_listZip(objFolderItem, "", out_filelist)
End Function
dim list

Sub UnZip(ByVal myZipFile, ByVal myTargetDir)
    If NOT fs.FolderExists(myTargetDir) Then
        fs.CreateFolder(myTargetDir)
    End If
    Set objSource = objShell.NameSpace(myZipFile)
    Set objFolderItem = objSource.Items()
    Set objTarget = objShell.NameSpace(myTargetDir)
    objTarget.CopyHere objFolderItem, 16 + 256 + 512
	'16  对于显示的任何对话框，请响应“全部是”。
	'256 显示进度对话框，但不显示文件名。
	'512 如果操作需要创建一个目录，请不要确认新目录的创建。

End Sub

Function ZipFolder(sSourceFolder, sTargetZIPFile) 
	'This function will add all of the files in a source folder to a ZIP file 
	'using Windows' native folder ZIP capability. 
	Dim iErr, sErrSource, sErrDescription 

	' 文件夹以\结尾
	If Right(sSourceFolder,1) <> "\" Then sSourceFolder = sSourceFolder & "\" 
	On Error Resume Next

	'如果目标 ZIP 存在则先删除
	If fs.FileExists(sTargetZIPFile) Then fs.DeleteFile sTargetZIPFile,True  

	iErr = Err.Number 
	sErrSource = Err.Source 
	sErrDescription = Err.Description 

	On Error GoTo 0
	If iErr <> 0 Then
		ZipFolder = Array(iErr,sErrSource,sErrDescription) 
		Exit Function 
	End If 

	On Error Resume Next

	'写zip文件头
	fs.OpenTextFile(sTargetZIPFile, 2, True).Write "PK" & Chr(5) & Chr(6) & String(18, Chr(0)) 
	iErr = Err.Number 
	sErrSource = Err.Source 
	sErrDescription = Err.Description 
	On Error GoTo 0 

	If iErr <> 0 Then    
		ZipFolder = Array(iErr,sErrSource,sErrDescription) 
		Exit Function 
	End If

	On Error Resume Next
	'拷贝文件进入zip
	objShell.NameSpace(sTargetZIPFile).CopyHere objShell.NameSpace(sSourceFolder).Items 
	iErr = Err.Number
	sErrSource = Err.Source
	sErrDescription = Err.Description 
	On Error GoTo 0

	If iErr <> 0 Then    
		ZipFolder = Array(iErr,sErrSource,sErrDescription) 
		Exit Function 
	End If 
	
	
	'因为复制是在一个单独的过程中进行的，所以脚本将继续。运行DO…LOOP以阻止该函数。直到压缩完成
	Do Until objShell.NameSpace(sTargetZIPFile).Items.Count = objShell.NameSpace(sSourceFolder).Items.Count 
		WScript.Sleep 1500'如果不成功，增加一下秒数 
	Loop

	ZipFolder = Array(0,"","") 
End Function

Sub Zip(ByVal mySource, ByVal myZipFile, ByVal path) 
	If fs.GetExtensionName(myZipFile) <> "zip" Then 
		Exit Sub 
	ElseIf fs.FolderExists(mySource) Then 
		FType = "Folder"
	ElseIf fs.FileExists(mySource) Then 
		FType = "File"
		FileName = fs.GetFileName(mySource) 
		FolderPath = Left(mySource, Len(mySource) - Len(FileName)) 
	Else
		Exit Sub
	End If

	If not fs.FileExists(myZipFile) Then
		Set f = fs.CreateTextFile(myZipFile, True) 
		f.Write "PK" & Chr(5) & Chr(6) & String(18, Chr(0)) 
		f.Close
	end if

	dim arr

	Select Case Ftype
	Case "Folder"
		Set objSource = objShell.NameSpace(mySource) 
		Set objFolderItem = objSource.Items() 
	Case "File"
		Set objSource = objShell.NameSpace(FolderPath)
		Set objFolderItem = objSource.ParseName(FileName )
		'msgbox FolderPath + "|" + FileName
	End Select


	Set objTarget = objShell.NameSpace(myZipFile)

	intOptions = 4

	objTarget.CopyHere objFolderItem, intOptions
	dim count 
	count = objTarget.Items.Count
	Do
		WScript.Sleep 1000
	Loop Until objTarget.Items.Count > count + 1

End Sub

Function delFile( filename )

	If not fs.FileExists( filename ) Then
		delFile = true
		exit Function
	End If

	fs.DeleteFile( filename )

	If not fs.FileExists( filename ) Then
		delFile = true
		exit Function
	End If

end Function

function getVersion( filename )
	If not fs.FileExists( filename ) Then
		getVersion = "0.0.0.0"
		exit Function
	End If
	getVersion = fs.GetFileVersion( filename )
end function
