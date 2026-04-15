tip = "是否进行修复?" + vbcrlf + _
   vbcrlf + _
   "用于修复在编辑框中打的汉字变成问号的问题" + vbcrlf + _
   vbcrlf + _
   "修复后请重启雪月编辑器, 如重启编辑器后问题依旧, 请重启电脑." + vbcrlf + _
   vbcrlf + _
   vbcrlf + _
   "来源: 寒泉组(布偶猫)"
if msgbox(tip, vbyesno, "雪糕雪糕???") <> vbyes then
   WScript.Quit
end if
Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\Root\Default:StdRegProv")
Const HKEY_CURRENT_USER = &H80000001
Const KEY_CREATE_SUB_KEY = &H0004
Const KEY_CREATE = 32

objReg.SetStringValue HKEY_CURRENT_USER, "Keyboard Layout\Preload", "1", "d0000804"

objReg.SetStringValue HKEY_CURRENT_USER, "Keyboard Layout\Substitutes", "d0000804", "00000409"

objReg.DeleteValue HKEY_CURRENT_USER, "Keyboard Layout\Substitutes", "00000804"
objReg.DeleteValue HKEY_CURRENT_USER, "Keyboard Layout\Substitutes", "d0010804"

objReg.SetStringValue HKEY_CURRENT_USER, "Control Panel\International\User Profile", "InputMethodOverride", "0804:00000409"

objReg.SetDWORDValue HKEY_CURRENT_USER, "Control Panel\International\User Profile\zh-Hans-CN", "0804:00000409", CLNG(1)


msgbox "完成 ^ ^"