

	//限制距离的冲锋运动方法
	public function DisC takes nothing returns nothing
		local real ux
		local real uy
		local real uz
		local ESport this = OnES
		if this.SportE != null then
			// 更新速度（距离变化分量）
			set this.dx = this.dx + this.acX
			set this.dy = this.dy + this.acY
			set this.dz = this.dz + this.acZ				
			// 更新特效位置				
			set ux = MHEffect_GetX(this.SportE) + this.dx				
			set uy = MHEffect_GetY(this.SportE) + this.dy
			set uz = MHEffect_GetZ(this.SportE) + this.dz
			call MHEffect_SetPosition(this.SportE, ux, uy, uz)
			// 更新移动距离
			set this.DisNow = this.DisNow + SquareRoot((this.dx * this.dx) + (this.dy * this.dy) + (this.dz * this.dz))				
			if this.IsEU == false and this.cback != null then
				// 碰撞检测
				if (this.cd > 0) then
					set EventID = 1					
					set OnES = this
					call MHUnit_EnumInRangeEx(ux, uy, this.range, function SKnock)
					//清除各类变量
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
			if this.DisNow >= this.Dis then
				//设置碰撞事件全局变量
				set EventID = 2
				set OnES = this
				// 执行回调
				if this.Eback != null then
					call MHGame_ExecuteFunc(this.Eback)
				endif
				//清除各类变量
				set OnES = 0
				set EventID = 0				
				call Des(this)
			endif
		else
			call Des(this)
		endif
	endfunction
	
	
	//锁定目标冲锋运动方法
	public function ELockTarC takes nothing returns nothing
		local real ux
		local real uy
		local real uz			
		local real x
		local real y
		local real z
		local real yaw
		local real pitch
		local real distance	
		local real dis3D
		local real Dangle
		local real limit
		local ESport this = OnES
		if this.SportE != null and UnitAlive(this.TarU) then
			set x = GetUnitX(this.TarU)
			set y = GetUnitY(this.TarU)
			set z = MFLua_GetUnitZ(this.TarU)
			//特效位置
			set ux = MHEffect_GetX(this.SportE)		
			set uy = MHEffect_GetY(this.SportE)
			set uz = MHEffect_GetZ(this.SportE)
			set distance = MFBase_GetCoordDistance(ux, uy, x, y)
			set yaw = Atan2(y - uy, x - ux)	//更新水平角度
			set pitch = Atan2(z - uz, distance)		//更新仰角
			// 更新速度（距离变化分量）
			set this.acX = Cos(pitch) * Cos(yaw) * this.Acrat
			set this.acY = Cos(pitch) * Sin(yaw) * this.Acrat
			set this.acZ = Sin(pitch) * this.Acrat
			set this.dx = Cos(pitch) * Cos(yaw) * (this.Spd + this.acX)
			set this.dy = Cos(pitch) * Sin(yaw) * (this.Spd + this.acY)
			set this.dz = Sin(pitch) * (this.Spd + this.acZ)		
			// 更新特效位置				
			set ux = ux + this.dx				
			set uy = uy + this.dy
			set uz = uz + this.dz
			set Dangle = MFBase_Rad2Deg(yaw)
			call MHEffect_SetYaw( this.SportE, Dangle - this.angle )		//更新特效方向
			set this.angle = Dangle
			call MHEffect_SetPosition(this.SportE, ux, uy, uz)
			// 更新移动距离
			set this.DisNow = this.DisNow + SquareRoot((this.dx * this.dx) + (this.dy * this.dy) + (this.dz * this.dz))
			if (this.IsEU == false) then
				set limit = 96
				if (this.cback != null) then
					// 碰撞检测
					if (this.cd > 0) then
						set EventID = 1
						
						set OnES = this
						call MHUnit_EnumInRangeEx(ux, uy, this.range, function SKnock)
						//清除各类变量
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
			else
				set limit = MFEUnit_EffectToEU(this.SportE).KRange
			endif
			set dis3D = MFBase_Get3DCoordsDistance(ux, uy, uz, x, y, z)
			if dis3D < limit then
				set EventID = 2				
				set OnES = this
				if this.Eback != null then
					call MHGame_ExecuteFunc(this.Eback)
				endif
				//清除各类变量
				set OnES = 0
				set EventID = 0
				//结束特效运动
				call Des(this)
			endif
		else
			call Des(this)
		endif
	endfunction

	
	private function EPbaCha takes ESport this returns nothing		//抛物线运动
		local real x
		local real y
		local real z					
		local real yaw
		local real pitch
		local real distance	
		local real dis3D
		local real Dangle
		local real limit
		if this.SportE != null then
			// 更新时间增量			
			// 更新速度分量（欧拉积分）
			set this.dx = this.dx + this.acX
			set this.dy = this.dy + this.acY
			set this.dz = this.dz + this.acZ		
			// 更新位置（使用二阶运动方程）
			set x = MHEffect_GetX(this.SportE) + this.dx
			set y = MHEffect_GetY(this.SportE) + this.dy
			set z = MHEffect_GetZ(this.SportE) + this.dz
			call MHEffect_SetPosition(this.SportE, x, y, z)			
			if this.IsEU == false then
				set limit = 96
				if this.cback != null then
					// 碰撞检测
					if (this.cd > 0) then
						set EventID = 1					
						set OnES = this
						call MHUnit_EnumInRangeEx(x, y, this.range, function SKnock)
						//清除各类变量
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
			else
				set limit = MFEUnit_EffectToEU(this.SportE).KRange
			endif
			set dis3D = MFBase_Get3DCoordsDistance(this.EPx, this.EPy, this.EPz, x, y, z)
			if dis3D < limit then
				set EventID = 2
				
				set OnES = this
				if this.Eback != null then
					call MHGame_ExecuteFunc(this.Eback)
				endif
				//清除各类变量
				set OnES = 0
				set EventID = 0			
				//结束特效运动
				call Des(this)
			endif
		else
			call Des(this)
		endif
	endfunction
	
	
		
	//创建限制距离的冲锋(特效)
	public function EDisC takes effect SportE, unit OriU, real range, real cd, real high, string func, string func2, boolean IsDes, real angle, real Spd, real Acrat, real angleY, real Dis returns nothing	
		local ESport this = Create(SportE, null, null, OriU, func, func2)
		local EUnit EU = LoadInteger(MFEUnit_Hash, GetHandleId(SportE), MFEUnit_STRUCT)
		local real yaw = angle * bj_DEGTORAD // 将水平角度转换为弧度
		local real pitch = angleY * bj_DEGTORAD // 将仰角转换为弧度
		local real speed = Spd / 50
		local real acrat = Acrat / 50
		//冲锋板块
		set this.Spd = speed
		set this.Acrat = acrat
		set this.dx = Cos(pitch) * Cos(yaw) * speed
		set this.dy = Cos(pitch) * Sin(yaw) * speed
		set this.dz = Sin(pitch) * speed
		set this.acX = Cos(pitch) * Cos(yaw) * acrat
		set this.acY = Cos(pitch) * Sin(yaw) * acrat
		set this.acZ = Sin(pitch) * acrat
		set	this.DisNow = 0
		set this.range = range
		set this.cd = cd
		set this.high = high
		set this.IsDes = IsDes
		set this.angle = angle
		set this.Dis = Dis
		call MHEffect_SetYaw( SportE, angle )
		call MHEffect_SetZ( SportE, high)
		if EU != 0 then
			set EU.Sport = this
			call MFCTimer_EUSport(EU.Loop, "MFESport_DisC", this)
		else
			set this.Loop = MFCTimer_ESport(this, "MFESport_DisC", MFESport_CYCLE, false)
		endif
	endfunction
	
	//创建限制距离的冲锋(特效投射物)
	#define MFESport_EUDisCCreate( eu, high, func2, angle, speed, acrat, angleY, dis)   MFESport_EDisC(MFEUnit_EUToEffect(eu), null, 0, 0, high, null, func2, false, angle, speed, acrat, angleY, dis)
	
	//创建锁定单位的冲锋(特效)
	public function ELocTarC takes effect SportE, unit TarU, unit OriU, real range, real cd, real high, string func2, boolean IsDes, real Spd, real Acrat returns nothing	
		local ESport this = Create(SportE, null, TarU, OriU, null, func2)
		local EUnit EU = LoadInteger(MFEUnit_Hash, GetHandleId(SportE), MFEUnit_STRUCT)
		local real yaw = Atan2(GetUnitY(TarU) - MHEffect_GetY(SportE), GetUnitX(TarU) - MHEffect_GetX(SportE))
		local real pitch = Atan2(MFLua_GetUnitZ(TarU) - MHEffect_GetZ(SportE), MFBase_GetCoordDistance(GetUnitX(TarU), GetUnitY(TarU), MHEffect_GetX(SportE), MHEffect_GetY(SportE)))	//Z轴差, 坐标间距离
		local real speed = Spd / 50
		local real acrat = Acrat / 50
		////冲锋板块
		set this.angle = MFBase_Rad2Deg(yaw)
		set this.Spd = speed
		set this.Acrat = acrat
		set this.dx = Cos(pitch) * Cos(yaw) * speed
		set this.dy = Cos(pitch) * Sin(yaw) * speed
		set this.dz = Sin(pitch) * speed
		set this.acX = Cos(pitch) * Cos(yaw) * acrat
		set this.acY = Cos(pitch) * Sin(yaw) * acrat
		set this.acZ = Sin(pitch) * acrat
		set	this.DisNow = 0
		set this.range = range
		set this.cd = cd
		set this.high = high
		set this.IsDes = IsDes
		call MHEffect_SetYaw( this.SportE, this.angle )
		call MHEffect_SetZ( SportE, high)
		if EU != 0 then
			set EU.Sport = this
			call MFCTimer_EUSport(EU.Loop, "MFESport_ELockTarC", this)
		else
			set this.Loop = MFCTimer_ESport(this, "MFESport_ELockTarC", MFESport_CYCLE, false)
		endif
	endfunction
	
	//创建锁定单位的冲锋(特效投射物)
	#define MFESport_EULoTarCCreate( eu, tu, high, func2, speed, acrat)  MFESport_ELocTarC(MFEUnit_EUToEffect(eu), tu, null, 0, 0, high, func2, false, speed, acrat)

		
		