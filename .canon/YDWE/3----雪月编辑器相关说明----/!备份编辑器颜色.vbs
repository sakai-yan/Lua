Rem On Error Resume Next

Const HKEY_CLASSES_ROOT = &H80000000 '''HKCR
Const HKEY_CURRENT_USER = &H80000001 '''HKCU
Const HKEY_LOCAL_MACHINE = &H80000002 '''HKLM
Const HKEY_Users = &H80000003 '''HKU
Const HKEY_Current_Config = &H80000005 '''HKCC

Dim regPath, objReg
regPath = "Software\Blizzard Entertainment\WorldEdit\Trigger Display Colors"
Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\Root\Default:StdRegProv")

'EnumRegistry HKEY_CURRENT_USER, regPath
Dim name
name = InputBox("备份编辑器颜色?确认前请输入名字,用以区分不同的分享者.", "雪糕雪糕?")
if name <> "" then
    BackupColors HKEY_CURRENT_USER, regPath, name
end if

Function BackupColors( HKEY, regPath, userName )
    Dim arrName, arrType, s, i, regType, regValue
    objReg.EnumValues HKEY, regPath, arrName, arrType                         '枚举注册表值名
    If not isArray(arrName) Then
        msgbox "备份了个寂寞,请至少启动一次编辑器进行初始化"
        exit function
    End If
    
    s = "if msgbox(""是否恢复编辑器颜色?"", vbyesno, ""来源:" + userName + """) <> vbyes then" + vbLf + _
        "   WScript.Quit" + vbLf + _
        "end if" + vbLf + _
        "Set objReg = GetObject(""winmgmts:{impersonationLevel=impersonate}!\\.\Root\Default:StdRegProv"")" + vbLf + _
        "Const HKEY_CURRENT_USER = &H80000001" + vbLf + _
        "function RestoreColors( item, value )" + vbLf + _
        "   objReg.SetDWORDValue " + _
                "HKEY_CURRENT_USER, " + _
                """Software\Blizzard Entertainment\WorldEdit\Trigger Display Colors""," + _
                " item," + _
                " CLNG(value)" + _
                vbLf + _
        "end function" + vbLf + _
        "objReg.CreateKey HKEY_CURRENT_USER, ""Software\Blizzard Entertainment\WorldEdit\Trigger Display Colors""" + vbLf 

    For i = 0 To UBound(arrName)
        'regType  = GetRegType(arrType(i))                                    '获取类型
        regValue = GetRegValue( HKEY, regPath, arrName(i), arrType(i) )   '获取注册表值
        if arrType(i) = 4 then
            s = s & "RestoreColors """ & arrName(i) & """, " & regValue & vbLf
        else
        end if
    Next
    s = s & "msgbox ""还原完成""" & vbLf

    Set objFSO = CreateObject("Scripting.FileSystemObject")
    '写在当前目录
    Set objFile = objFSO.CreateTextFile( userName & " 的编辑器配色.vbs", True)
    objFile.WriteLine s
    objFile.Close
    msgbox "备份完成,请检查运行目录"
End Function

Function EnumRegistry(HKLM, regSubPath)
    Dim arrName, arrType, s, i, regType, regValue
    objReg.EnumValues HKLM, regSubPath, arrName, arrType                         '枚举注册表值名
    If isArray(arrName) Then
        s = ""
        For i=0 To UBound(arrName)
            regType  = GetRegType(arrType(i))                                    '获取类型
            regValue = GetRegValue( HKLM, regSubPath, arrName(i), arrType(i) )   '获取注册表值
            s = s & arrName(i) & vbTab & regType & vbTab & regValue & vbLf
        Next
        WSH.Echo regSubPath & vbLf & s
    Else
        WSH.Echo regSubPath
    End If
 
    'objReg.EnumKey HKLM, regSubPath, arrName                                     '枚举注册表项
    'If isArray(arrName) Then
    '    For i=0 To UBound(arrName)
    '        EnumRegistry HKLM, regSubPath & "\" & arrName(i)    '递归
    '    Next
    'End If
End Function
 
Function GetRegType(n)
    Select Case n
        Case 1 GetRegType = "REG_SZ"
        Case 2 GetRegType = "REG_EXPAND_SZ"
        Case 3 GetRegType = "REG_BINARY"
        Case 4 GetRegType = "REG_DWORD"
        Case 7 GetRegType = "REG_MULTI_SZ"
        Case 11 GetRegType = "REG_QWORD"
    End Select
End Function
 
Function GetRegValue( HKLM, regSubPath, regName, n )
    Select Case n
        Case 1
            objReg.GetStringValue HKLM, regSubPath, regName, sValue
            GetRegValue = sValue
        Case 2
            objReg.GetExpandedStringValue HKLM, regSubPath, regName, sValue
            GetRegValue = sValue
        Case 3
            objReg.GetBinaryValue HKLM, regSubPath, regName, uValue
            GetRegValue = Join(uValue, ",")
        Case 4
            objReg.GetDWORDValue HKLM, regSubPath, regName, uValue
            GetRegValue = uValue
        Case 7
            objReg.GetMultiStringValue HKLM, regSubPath, regName, sValue
            GetRegValue = Join(sValue, ",")
        Case 11
            objReg.GetQWORDValue HKLM, regSubPath, regName, uValue
            GetRegValue = uValue
    End Select
End Function
