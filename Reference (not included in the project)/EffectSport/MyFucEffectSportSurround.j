	
	//普通环绕运动方法
	public function ComSur takes nothing returns nothing
		local real x1
		local real y1
		local real nx
		local real ny
		local real ux
		local real uy
		local real angle
		local real dis
		local unit eu
		local ESport this = OnES
		if this.SportE != null and UnitAlive(this.SurU) then
			if not this.Pause then
				// 更新角度
				set this.angle = this.angle + this.aspd				
				// 计算目标位置
				set x1 = GetUnitX(this.SurU) + this.rad * Cos(MFBase_Deg2Rad(this.angle))
				set y1 = GetUnitY(this.SurU) + this.rad * Sin(MFBase_Deg2Rad(this.angle))
				call MHEffect_SetYaw( this.SportE, this.aspd )	//特效转动方向
				call MHEffect_SetPosition(this.SportE, x1, y1, this.high)	
				if not this.IsEU then
					// 碰撞检测
					if (this.cd > 0) then
						set EventID = 1
						
						set OnES = this
						call MHUnit_EnumInRangeEx(x1, y1, this.range, function SKnock)
						//清除事件变量
						set OnES = 0
						set EventID = 0						
						set SKnockU = null
					endif
					// 更新冷却时间
					set this.cded = this.cded + MFESport_CYCLE
					if (this.cded >= this.cd) then			
						call GroupClear(this.ReKnoG)
						set this.cded = 0
					endif
				endif
				// 更新持续时间
				set this.time = this.time - MFESport_CYCLE
				if this.time <= 0 then
					//设置事件全局变量
					set EventID = 2				
					set OnES = this
					// 执行回调	
					if this.Eback != null then
						call MHGame_ExecuteFunc(this.Eback)
					endif
					//清除事件变量
					set OnES = 0
					set EventID = 0				
					call Des(this)
				endif
			endif
		else
			call Des(this)
		endif
	endfunction

	//创建普通环绕(特效)
	public function EComSur takes effect SportE, unit SurU, unit OriU, real range, real cd, real time, real high, string func, string func2, boolean IsDes, real aspd, real rad, real angle returns nothing	
		local ESport this = Create(SportE, SurU, null, OriU, func, func2)
		local EUnit EU = LoadInteger(MFEUnit_Hash, GetHandleId(SportE), MFEUnit_STRUCT)
		set this.range = range
		set this.cd = cd
		set this.time = time
		set this.high = high
		set this.IsDes = IsDes
		set this.aspd = aspd
		set this.rad = rad
		set this.angle = angle
		call MHEffect_SetYaw( SportE, angle + 90 )
		call MHEffect_SetZ(SportE, high)
		if EU != 0 then
			set EU.Sport = this
			call MFCTimer_EUSport(EU.Loop, "MFESport_ComSur", this)
		else
			set this.Loop = MFCTimer_ESport(this, "MFESport_ComSur", MFESport_CYCLE, false)
		endif
	endfunction
	
	//创建普通环绕(特效投射物)
	#define MFESport_EUComSurCreate(eu, SurU, time, high, func2, aspd, rad, angle)  MFESport_EComSur(MFEUnit_EUToEffect(eu), SurU, null, 0, 0, time, high, null, func2, false, aspd, rad, angle)	
		