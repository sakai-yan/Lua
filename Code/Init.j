#define MEMHACK_DISABLE_WENHAO 1

#include "../memory_hack/memory_hack.j"
#include "../memory_hack/memory_hack_addon.j"
#include "../AsphodelusUI/AsphodelusUI.j"


<?
local main_path = "Lua"

local gsub = string.gsub

local function importlua(path, isCN)
    local converted_path = gsub(path, "%.", "\\")
    local archive_path = converted_path .. ".lua"
    local file_path = main_path .. "\\" .. archive_path
    local importer = import(archive_path)
    importer(file_path, true)
end

importlua("Runtime")
importlua("Debug")
importlua("Game")

--Lib

--API
importlua("Lib.API.Jass")
importlua("Lib.API.Constant")
importlua("Lib.API.Tool")

--Base
importlua("Lib.Base.table")
importlua("Lib.Base.string")
importlua("Lib.Base.BitSet")
importlua("Lib.Base.DataType")
importlua("Lib.Base.Array")
importlua("Lib.Base.Stack")
importlua("Lib.Base.Queue")
importlua("Lib.Base.LinkedList")
importlua("Lib.Base.Set")
importlua("Lib.Base.Class")
importlua("Lib.Base.Csv")
importlua("Lib.Base.Vector3")
importlua("Lib.Base.HandleId")

--FrameWork

--GameSetting
importlua("FrameWork.GameSetting.AttachPosition")
importlua("FrameWork.GameSetting.Attribute")
importlua("FrameWork.GameSetting.State")
importlua("FrameWork.GameSetting.CastType")
importlua("FrameWork.GameSetting.TargetType")

--Manager
importlua("FrameWork.Manager.Point")
importlua("FrameWork.Manager.IDGenerator")
importlua("FrameWork.Manager.Timer")
importlua("FrameWork.Manager.Async")
importlua("FrameWork.Manager.Event")

--Core

--Entity
importlua("Core.Entity.Unit")
importlua("Core.Entity.Item")
importlua("Core.Entity.Effect")
importlua("Core.Entity.Buff")
importlua("Core.Entity.Ability")
importlua("Core.Entity.Player")
importlua("Core.Entity.Region")

--UI
importlua("Core.UI.Frame")
importlua("Core.UI.Panel")
importlua("Core.UI.Texture")
importlua("Core.UI.Text")
importlua("Core.UI.Slider")
importlua("Core.UI.Sprite")
importlua("Core.UI.Model")
importlua("Core.UI.Portrait")
importlua("Core.UI.SimpleText")
importlua("Core.UI.Button")
importlua("Core.UI.TextArea")
importlua("Core.UI.Watcher")
importlua("Core.UI.Tween")
importlua("Core.UI.Style")
importlua("Core.UI.Component")

--View

--Logic
importlua("Logic.Define.Attribute")

importlua("Logic.Process.Unit.Create")
importlua("Logic.Process.Unit.Delete")
importlua("Logic.Process.Unit.Exp")

importlua("Logic.Process.Ability.Add")
importlua("Logic.Process.Ability.Remove")
importlua("Logic.Process.Ability.Spell")

importlua("Logic.Process.Item.Create")
importlua("Logic.Process.Item.Delete")
importlua("Logic.Process.Item.Get")
importlua("Logic.Process.Item.Lose")
importlua("Logic.Process.Item.Use")

importlua("Logic.Process.Damage")
importlua("Logic.Process.Trade")

--Resource
import("Data.csv")("Lua\\Unit\\Data.csv", true)

--Entry
importlua("Main")



---------生成属性物编---------
local slk = require 'slk' 
local a1 = slk.ability.AItg:new 'ASG1' 
a1.Name = "[系统]攻击力增加"
a1.DataA1 = 0

a1 = slk.ability.AId1:new 'ASG2' 
a1.Name = "[系统]护甲增加"
a1.DataA1 = 0

a1 = slk.ability.Aamk:new 'ASG3' 
a1.Name = "[系统]属性增加 力量"
a1.DataA1 = 0
a1.DataB1 = 0
a1.DataC1 = 0
a1.Art = ""
a1.hero = "0"
a1.race = "unknow"
a1.levels = 1
a1.DataD1 = 1
a1.item = 1

a1 = slk.ability.Aamk:new 'ASG4' 
a1.Name = "[系统]属性增加 敏捷"
a1.DataA1 = 0
a1.DataB1 = 0
a1.DataC1 = 0
a1.Art = ""
a1.hero = "0"
a1.race = "unknow"
a1.levels = 1
a1.DataD1 = 1
a1.item = 1

a1 = slk.ability.Aamk:new 'ASG5' 
a1.Name = "[系统]属性增加 智力"
a1.DataA1 = 0
a1.DataB1 = 0
a1.DataC1 = 0
a1.Art = ""
a1.hero = "0"
a1.race = "unknow"
a1.levels = 1
a1.DataD1 = 1
a1.item = 1

a1 = slk.ability.AIms:new 'ASG6' 
a1.Name = "[系统]移动速度增加"
a1.DataA1 = 0

a1 = slk.ability.AIsx:new 'ASG7' 
a1.Name = "[系统]攻击速度增加"
a1.DataA1 = 0

--生成技能马甲物编
--最大技能数量
local abilitymax = 8

--技能马甲
for index = 1, abilitymax do
    local id = tostring(index)
    local activeCode = "MFA" .. id
    local activeName = "[系统]主动技能马甲" .. id
    local abil = slk.ability.ANcl:new(activeCode)
    abil.DataA1 = 0
    abil.DataB1 = 0
    abil.DataC1 = 1
    abil.Art = ""
    abil.hero = "0"
    abil.race = "unknow"
    abil.levels = 1
    abil.DataD1 = 5.00
    abil.DataE1 = 0
    abil.item = 0
end

a1 = slk.ability.ANcl:new 'MFHS'
a1.Name = "[系统]隐藏技能"
a1.DataA1 = 0
a1.DataB1 = 1
a1.DataC1 = 0
a1.DataD1 = 5.00
a1.DataE1 = 0
a1.DataF1 = "forceofnature"
a1.EffectArt = ""
a1.TargetArt = ""
a1.Targetattach = ""
a1.item = 1
a1.levels = 1
a1.hero = 0
a1.race = "unknow"
a1.CasterArt = ""
a1.Casterattach = ""
a1.Animnames = ""

--物品马甲

a1 = slk.ability.ANcl:new 'MFIS'
a1.Name = "[系统]物品技能"
a1.DataA1 = 0
a1.DataB1 = 1
a1.DataC1 = 0
a1.DataD1 = 5.00
a1.DataE1 = 0
a1.DataF1 = "forceofnature"
a1.EffectArt = ""
a1.TargetArt = ""
a1.Targetattach = ""
a1.item = 1
a1.levels = 1
a1.hero = 0
a1.race = "unknow"
a1.CasterArt = ""
a1.Casterattach = ""
a1.Animnames = ""

local a1 = slk.item.ratc:new 'MFIt' 
a1.Name = "[系统]物品马甲"
a1.cooldownID = ""
a1.abilList = "MFIS"
a1.usable = 1

?>

library MFLuas initializer Init

    //单位是否存活
    function MFLua_UnitAlive takes unit Unit returns boolean
        return UnitAlive(Unit)
    endfunction

    function MFLua_ExecuteCode takes nothing returns nothing
        call GetTriggerUnit()
    endfunction

    //Lua选取
    function MFLua_EnumUnitInRange takes real x, real y, real radius returns nothing
        call MHUnit_EnumInRangeEx(x, y, radius, function MFLua_ExecuteCode)
    endfunction

    function MFLua_EnumUnitAbility takes unit Unit returns nothing
        //call MHUnit_EnumAbility(Unit, LuaCode)
    endfunction

    private function Init takes nothing returns nothing
        //call MHTool_Clock()     //先调用一次mh，不然lua中无法使用mh
        //call Cheat( "exec-lua:\"main\"")
        call MHLua_RunScript("Lua\\Main.lua")
    endfunction

endlibrary
