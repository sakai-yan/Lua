--单下划线表示只读、不允许外部修改，双下划线表示私有、不允许外部访问，前后双下划线表示类的特殊字段

require 'Runtime'
require 'Debug'
local Game = require 'Game'

--Lib基础层初始化

--API
require 'Lib.API.Jass'
require 'Lib.API.Constant'
require 'Lib.API.Tool'

--Base

--表
require 'Lib.Base.table'
--字符串
require 'Lib.Base.string'
--位集
require 'Lib.Base.BitSet'
--数据类型管理
require 'Lib.Base.DataType'
--数组
require 'Lib.Base.Array'
--栈
require 'Lib.Base.Stack'
--队列
require 'Lib.Base.Queue'
--链表
require 'Lib.Base.LinkedList'
--集合
require 'Lib.Base.Set'
--类
require 'Lib.Base.Class'
--CSV
require 'Lib.Base.Csv'
--三维向量
require 'Lib.Base.Vector3'
--对象ID
require 'Lib.Base.HandleId'




--框架层初始化

--GameSetting
require 'FrameWork.GameSetting.AttachPosition'
require 'FrameWork.GameSetting.Attribute'
require 'FrameWork.GameSetting.State'
require 'FrameWork.GameSetting.CastType'
require 'FrameWork.GameSetting.TargetType'

--Manager
require 'FrameWork.Manager.Point'
require 'FrameWork.Manager.IDGenerator'
require 'FrameWork.Manager.Timer'
require 'FrameWork.Manager.Async'
require 'FrameWork.Manager.Event'


--Core层初始化

--Entity
require 'Core.Entity.Unit'
require 'Core.Entity.Item'
require 'Core.Entity.Effect'
require 'Core.Entity.Buff'
require 'Core.Entity.Ability'
require 'Core.Entity.Player'
require 'Core.Entity.Region'

--UI
require 'Core.UI.Frame'
require 'Core.UI.Panel'
require 'Core.UI.Texture'
require 'Core.UI.Text'
require 'Core.UI.Slider'
require 'Core.UI.Sprite'
require 'Core.UI.Model'
require 'Core.UI.Portrait'
require 'Core.UI.SimpleText'
require 'Core.UI.Button'
require 'Core.UI.TextArea'
require 'Core.UI.Style'
require 'Core.UI.Watcher'
require 'Core.UI.Tween'
require 'Core.UI.Component'

--View表现层

--Logic层
require 'Logic.Define.Attribute'

require 'Logic.Process.Unit.Create'
require 'Logic.Process.Unit.Delete'
require 'Logic.Process.Unit.Exp'

require 'Logic.Process.Ability.Add'
require 'Logic.Process.Ability.Remove'
require 'Logic.Process.Ability.Spell'

require 'Logic.Process.Item.Create'
require 'Logic.Process.Item.Delete'
require 'Logic.Process.Item.Get'
require 'Logic.Process.Item.Lose'
require 'Logic.Process.Item.Use'


require 'Logic.Process.Damage'
require 'Logic.Process.Trade'

Game.execute()    --执行初始化回调
