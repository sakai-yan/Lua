
	//三阶贝塞尔运动方法
	public function Bez3C takes nothing returns nothing
		local real x
		local real y
		local ESport this = OnES
		if this.SportE != null then			
			//计算贝塞尔曲线位置
			set this.ConT = this.ConT + MFESport_CYCLE
			if this.ConT >= 1 then
				call MHEffect_SetPosition(this.SportE, this.EPx, this.EPy, this.EPz)
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
			else
				//set x = Pow(1 - t, 3) * this.StartP[0] + 3 * t * Pow(1 - t, 2) * this.ConX1 + 3 * Pow(t, 2) * (1 - t) * this.ConX2 + Pow(t, 3) * this.EndP[0]			//12ms-13ms
				set x = MHMath_Bezier3(this.SPx, this.ConX1, this.ConX2, this.EPx, this.ConT)
				set y = MHMath_Bezier3(this.SPy, this.ConY1, this.ConY2, this.EPy, this.ConT)
				set this.high = MHMath_Bezier3(this.SPz, this.ConZ1, this.ConZ2, this.EPz, this.ConT)
				call MHEffect_SetPosition(this.SportE, x, y, this.high)
				if not this.IsEU then
					// 碰撞检测
					if (this.cd > 0) then
						set EventID = 1
						set OnES = this
						call MHUnit_EnumInRangeEx(x, y, this.range, function SKnock)
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
			endif
		else
			call Des(this)
		endif
	endfunction
	
	//三阶贝塞尔运动方法（锁定单位）
	private function BezChaTarU takes nothing returns nothing
		local real x
		local real y
		local ESport this = OnES
		if this.SportE != null then			
			// 计算贝塞尔曲线位置
			set this.ConT = this.ConT + MFESport_CYCLE
			if this.ConT >= 1 then
				call MHEffect_SetPosition(this.SportE, GetUnitX(this.TarU), GetUnitY(this.TarU), MFLua_GetUnitZ(this.TarU))
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
			else
				//set x = Pow(1 - t, 3) * this.StartP[0] + 3 * t * Pow(1 - t, 2) * this.ConX1 + 3 * Pow(t, 2) * (1 - t) * this.ConX2 + Pow(t, 3) * this.EndP[0]			//12ms-13ms
				set x = MHMath_Bezier3(this.SPx, this.ConX1, this.ConX2, GetUnitX(this.TarU), this.ConT)
				set y = MHMath_Bezier3(this.SPy, this.ConY1, this.ConY2, GetUnitY(this.TarU), this.ConT)
				set this.high = MHMath_Bezier3(this.SPz, this.ConZ1, this.ConZ2, MFLua_GetUnitZ(this.TarU), this.ConT)
				call MHEffect_SetPosition(this.SportE, x, y, this.high)
				if not this.IsEU then
					// 碰撞检测
					if this.cd > 0 then
						set EventID = 1
						set OnES = this
						call MHUnit_EnumInRangeEx(x, y, this.range, function SKnock)
						//清除事件变量
						set OnES = 0
						set EventID = 0
						set SKnockU = null
					endif
					// 更新冷却时间
					set this.cded = this.cded + MFESport_CYCLE
					if this.cded >= this.cd then			
						call GroupClear(this.ReKnoG)
						set this.cded = 0
					endif
				endif
			endif
		else
			call Des(this)
		endif
	endfunction
		
	//创建三阶贝塞尔曲线运动的冲锋(特效)（坐标为终点）
	public function EBez3C takes effect SportE, unit OriU, real range, real cd, real high, string func, string func2, boolean IsDes, real SPx, real SPy, real EPx, real EPy, real EPz returns nothing	
		local EUnit EU = LoadInteger(MFEUnit_Hash, GetHandleId(SportE), MFEUnit_STRUCT)
		//随机控制点部分
		local real dx = EPx - SPx
		local real dy = EPy - SPy
		local real angle = bj_RADTODEG * Atan2(dy, dx)
		local real dis = SquareRoot(dx * dx + dy * dy)
		local ESport this = Create(SportE, null, null, OriU, func, func2)
		//计算控制点1
		local real Rangle = GetRandomReal(-180, 180)
		local real Rdis = GetRandomReal(0.3, 0.6) * dis
		local real Rangle1 = GetRandomReal(-180, 180)
		local real Rdis1 = GetRandomReal(0.2, 0.5) * dis
		set this.ConT = 0
		set this.ConX1 = MFBase_GetCoordDisCos(SPx, Rangle, Rdis) 
		set this.ConY1 = MFBase_GetCoordDisSin(SPy, Rangle, Rdis)
		set this.ConZ1 = GetRandomReal(500, 900)
		//计算控制点2
		set this.ConX2 = MFBase_GetCoordDisCos(this.ConX1, Rangle1, Rdis1) 
		set this.ConY2 = MFBase_GetCoordDisSin(this.ConY1, Rangle1, Rdis1)
		set this.ConZ2 = GetRandomReal(500, this.ConZ1)
		//
		set this.SPx = SPx
		set this.SPy = SPy
		set this.SPz = high
		set this.EPx = EPx
		set this.EPy = EPy
		set this.EPz = EPz
		set this.high = high
		set this.angle = angle
		set this.IsDes = IsDes		
		call MHEffect_SetYaw( SportE, angle)
		call MHEffect_SetZ( SportE, high)
		if EU != 0 then
			set EU.Sport = this
			call MFCTimer_EUSport(EU.Loop, "MFESport_Bez3C", this)
		else
			set this.Loop = MFCTimer_ESport(this, "MFESport_Bez3C", MFESport_CYCLE, false)
		endif
	endfunction
	
	//创建三阶贝塞尔曲线运动的冲锋(特效投射物)（坐标为终点）
	#define MFESport_EUBez3CCreate( eu, high, func2, SPx, SPy, EPx, EPz)  MFESport_EBez3C(MFEUnit_EUToEffect(eu), null, 0, 0, high, null, func2, false, SPx, SPy, EPx, EPz)

		