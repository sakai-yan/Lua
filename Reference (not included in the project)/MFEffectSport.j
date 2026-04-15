

library MFESport requires TimerPool, EffectPool, MFLua, MFBase, MFEUnit

	
	#define MFESport_CYCLE		0.02	//循环周期
	#define MFESport_STRUCT	<?=StringHash("MFESport_Struct")?>

	//特效运动
	struct ESport
		
		boolean Pause		//是否暂停运动 true为暂停
		effect SportE // 运动特效
		real range // 碰撞检测半径
		real cd // 碰撞冷却时间
		real cded // 当前冷却时间
		real time // 持续时间
		real high //初始高度
		real angle // 当前角度（弧度）
		string cback // 碰撞时触发
		string Eback // 运动（持续时间/命中目标）结束时触发
		group ReKnoG // 防止重复碰撞的组
		integer Loop // 计时器任务
		boolean IsDes	//环绕结束是否删除特效，true删除
		boolean IsEU	//是否特效投射物
		unit OriU	//来源单位
		unit TarU	//目标单位
		//环绕板块
		unit SurU // 环绕目标单位
		real aspd // 角速度
		real rad // 环绕半径
		//冲锋板块
		real Spd		//三维速度
		real Acrat		//三维加速度
		real dx // X方向上的速度分量（实际上就是每0.02秒移动的距离）
		real dy // Y方向上的速度分量
		real dz // Z方向上的速度分量
		real acX // X方向上的加速度分量
		real acY // Y方向上的加速度分量
		real acZ // Z方向上的加速度分量
		real Dis	//冲锋距离
		real DisNow		//移动过的距离
		//贝塞尔曲线冲锋板块
		real SPx	//起点
		real SPy	//起点
		real SPz	//起点
		real EPx	//终点
		real EPy	//终点
		real EPz	//终点
		real ConX1	//控制点1
		real ConY1	//控制点1
		real ConZ1	//控制点1
		real ConX2	//控制点2
		real ConY2	//控制点2
		real ConZ2	//控制点2
		real ConT	//t
		
	endstruct
		
globals
    
	public hashtable Hash = InitHashtable()   //存储结构体的哈希表
	public integer EventID = 0    //回调事件ID, 1-碰撞, 2-运动结束
	public unit SKnockU = null   //碰撞目标
	public ESport OnES = 0	//触发事件的运动实例
endglobals

		
	// 创建新实例	//angleY-仰角（输入的角度皆为角度制）
	public function Create takes effect SportE, unit SurU, unit TarU, unit OriU, string cFunc, string eFunc returns ESport		
		local ESport this = ESport.create()
		local EUnit eu
		local integer id = GetHandleId(SportE)
		set this.SportE = SportE
		set this.OriU = OriU
		set this.TarU = TarU
		set this.cback = cFunc
		set this.Eback = eFunc
		set this.SurU = SurU
		//记录实例
		set eu = LoadInteger(MFEUnit_Hash, id, MFEUnit_STRUCT)
		if eu != 0 then	//判断是否特效投射物
			set this.IsEU = true
			set eu.Sport = this
		else
			set this.IsEU = false
			set this.ReKnoG = MFGroup_Get()
		endif
		call SaveInteger(Hash, id, MFESport_STRUCT, this) //可通过特效id寻址	
		return this
	endfunction

	// 销毁实例
	public function Des takes ESport this returns nothing			
		local integer effectid = GetHandleId(this.SportE)
		//释放哈希表存储的数据
		call RemoveSavedInteger(Hash, effectid, MFESport_STRUCT)		
		//释放成员变量为初始值
		if this.IsEU == false then		//不是特效投射物
			call GroupClear(this.ReKnoG)
			call DestroyGroup(this.ReKnoG)
			call MFCTimer_Des(this.Loop)
			if this.IsDes then
				call EffectPool_Recycle(this.SportE, true)
			endif
		else	//如果是特效投射物
			set EUnit(LoadInteger(MFEUnit_Hash, effectid, MFEUnit_STRUCT)).SpoFunc = null
			set EUnit(LoadInteger(MFEUnit_Hash, effectid, MFEUnit_STRUCT)).Sport = 0
		endif
		set this.SportE = null
		set this.SurU = null
		set this.OriU = null
		set this.TarU = null
		set this.cback = null
		set this.Eback = null
		set this.ReKnoG = null
		set this.Loop = 0
		set this.high = 0
		set this.aspd = 0
		set this.rad = 0
		set this.angle = 0
		set this.range = 0
		set this.cd = 0
		set this.cded = 0
		set this.time = 0
		set this.IsDes = false
		set this.IsEU = false
		//冲锋板块
		set this.Spd = 0
		set this.Acrat = 0
		set this.dx = 0
		set this.dy = 0
		set this.dz = 0
		set this.acX = 0
		set this.acY = 0
		set this.acZ = 0
		set this.Dis = 0
		set this.DisNow = 0
		//贝塞尔板块
		set this.SPx = 0	//起点
		set this.SPy = 0	//起点
		set this.SPz = 0	//起点
		set this.EPx = 0	//终点
		set this.EPy = 0	//终点
		set this.EPz = 0	//终点
		set this.ConX1 = 0	//控制点1
		set this.ConY1 = 0	//控制点1
		set this.ConZ1 = 0	//控制点1
		set this.ConX2 = 0	//控制点2
		set this.ConY2 = 0//控制点2
		set this.ConZ2 = 0	//控制点2
		set this.ConT = 0	//t
		call ESport.destroy(this)
	endfunction
	
	//单位碰撞方法
	private function SKnock takes nothing returns nothing
		local ESport this = OnES
		local unit ku = MHUnit_GetEnumUnit()
		if UnitAlive(ku) and not IsUnitInGroup(ku, this.ReKnoG) then					
			//设置碰撞事件全局变量		
			set SKnockU = ku
			// 执行碰撞回调
			if this.cback != null then
				call MHGame_ExecuteFunc(this.cback)
			endif
			call GroupAddUnit(this.ReKnoG, ku)
		endif
		set ku = null
	endfunction
	
	//设置特效运动高度
	public function setESHigh takes ESport this, real high returns nothing
		set this.high = high
	endfunction
	
	////////////////////////通用
	//终止特效所有运动
	#define MFESport_BreakESports(SportE)			Des(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT))	
	//获取特效环绕单位
	#define MFESport_GetSportsSurU(SportE)		ESport(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT)).SurU	
	//获取事件特效来源单位
	#define MFESport_GetSportsOriU(SportE)			ESport(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT)).OriU	
	//获取事件特效目标单位
	#define MFESport_GetSportsTarU(SportE)			ESport(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT)).TarU

	////////////////////////事件
	//获取特效运动事件类型
	#define MFESport_GetEventID()			MFESport_EventID	
	//转换特效运动事件类型为整数ID
	#define MFESport_GetEventIDToInt(n)	n
	//获取触发事件的运动实例
	#define MFESport_GetOnES()			MFESport_OnES
	//获取事件特效碰撞单位
	#define MFESport_GetSKnockU()			MFESport_SKnockU
	//获取事件实例的运动特效
	#define MFESport_GetEffect(this)		ESport(this).SportE

	
	//环绕运动方法
	#include "EffectSport/MyFucEffectSportSurround.j"
	
	//冲锋运动方法
	#include "EffectSport/MyFucEffectSportCharge.j"
	
	//三阶贝塞尔曲线运动方法
	#include "EffectSport/MyFucEffectSportBezier3.j"
	
	//垂直下落方法
	#include "EffectSport/EffectSportDown.j"
	
	#define MFESport_GetDataU(this, type)					MFESport_GetDataU_##type##(this)
	#define MFESport_GetDataU_MFESport_ORIU(this)		ESport(this).OriU						//获取事件实例的来源单位
	#define MFESport_GetDataU_MFESport_TARU(this)		ESport(this).TarU						//获取事件实例的目标单位
	#define MFESport_GetDataU_MFESport_SURU(this)		ESport(this).SurU						//获取事件实例的环绕单位
	
	#define MFESport_GetEffectDataU(Effect, type)			MFESport_GetEffectDataU_##type##(Effect)
	#define MFESport_GetEffectDataU_MFESport_ORIU(this)		ESport(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT)).OriU						//获取运动特效的来源单位
	#define MFESport_GetEffectDataU_MFESport_TARU(this)		ESport(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT)).TarU						//获取运动特效的目标单位
	#define MFESport_GetEffectDataU_MFESport_SURU(this)		ESport(LoadInteger(MFESport_Hash, GetHandleId(SportE), MFESport_STRUCT)).SurU						//获取运动特效的环绕单位
	
	#define MFESport_ORIU		1
	#define MFESport_TARU		2
	#define MFESport_SURU		3

endlibrary




		


		
