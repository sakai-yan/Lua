	
	//垂直下落运动函数
	public function DirectDown takes nothing returns nothing
		local real z
		local real gap
		local ESport this = OnES
		if this.SportE != null then
			set this.dz = this.dz + this.acZ
			set gap = this.Dis - this.DisNow
			if gap < this.dz then
				set gap = gap / this.dz
				set z = MHEffect_GetZ(this.SportE) + (this.dz * gap)
				call MHEffect_SetZ(this.SportE, z)
			else
				set z = MHEffect_GetZ(this.SportE) + this.dz
				call MHEffect_SetZ(this.SportE, z)
			endif
			// 更新移动距离
			set this.DisNow = this.DisNow - this.dz
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
	
	
		
	//创建垂直下落(特效)
	public function EDown takes effect SportE, unit OriU, real high, string endT, boolean IsDes, real Spd, real Acrat, real Dis returns nothing	
		local ESport this = Create(SportE, null, null, OriU, null, endT)
		local EUnit EU = LoadInteger(MFEUnit_Hash, GetHandleId(SportE), MFEUnit_STRUCT)
		local real speed = (Spd / 50) * -1
		local real acrat = (Acrat / 50) * -1
		//冲锋板块
		set this.Spd = speed
		set this.Acrat = acrat
		set this.dx = 0
		set this.dy = 0
		set this.dz = speed
		set this.acX = 0
		set this.acY = 0
		set this.acZ = acrat
		set	this.DisNow = 0
		set this.range = 0
		set this.cd = 0
		set this.high = high
		set this.IsDes = IsDes
		set this.angle = 0
		set this.Dis = Dis
		call MHEffect_SetZ( SportE, high)
		if EU != 0 then
			set EU.Sport = this
			call MFCTimer_EUSport(EU.Loop, "MFESport_DirectDown", this)
		else
			set this.Loop = MFCTimer_ESport(this, "MFESport_DirectDown", MFESport_CYCLE, false)
		endif
	endfunction
	
	//创建垂直下落(特效投射物)
	#define MFESport_EUDownCreate( eu, high, endT, speed, acrat, dis)  MFESport_EDisC(MFEUnit_EUToEffect(eu), null, 0, 0, high, null, endT, false, 0, speed, acrat, 0, dis)
		