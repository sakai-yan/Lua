if msgbox("重置为YDWE默认颜色?" + vblf + "", vbyesno, "来源:雪糕雪糕") <> vbyes then
   WScript.Quit
end if
Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\Root\Default:StdRegProv")
Const HKEY_CURRENT_USER = &H80000001
Const KEY_CREATE_SUB_KEY = &H0004
Const KEY_CREATE = 32
function RestoreColors( item, value )
   objReg.SetDWORDValue HKEY_CURRENT_USER, "Software\Blizzard Entertainment\WorldEdit\Trigger Display Colors", item, CLNG(value)
end function

'objReg.CheckAccess HKEY_CURRENT_USER, "Software\Blizzard Entertainment\WorldEdit", KEY_CREATE_SUB_KEY, bHasAccessRight
'if bHasAccessRight <> true then
'	msgbox "无创建项目权限"
'	WScript.Quit
'end if

objReg.DeleteKey HKEY_CURRENT_USER, "Software\Blizzard Entertainment\WorldEdit\Trigger Display Colors"

objReg.CreateKey HKEY_CURRENT_USER, "Software\Blizzard Entertainment\WorldEdit\Trigger Display Colors"

RestoreColors "TC_YDHIDE", -65536
RestoreColors "TC_COMMENT", -16744448
RestoreColors "TC_DEPRECATED", -65536
msgbox "完成 ^ ^"

