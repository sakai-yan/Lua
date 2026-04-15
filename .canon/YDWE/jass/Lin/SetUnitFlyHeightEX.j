#ifndef Lib_SetUnitFlyHeightEX_Included
#define Lib_SetUnitFlyHeightEX_Included


library SetUnitFlyHeightEX
    globals
        private timer Timer = CreateTimer()
        private integer index = 0
        private unit array Units
        private real array Heights
        private integer array Types
        private real array Speeds
        private real array SpeedsX
        private real array FlyHeights
        private integer array SpeedTypes
        private real array Acceleration
    endglobals

    function UnitHeightUpdate takes nothing returns nothing
        local integer I = 1
        local integer S
        loop
            exitwhen I > index
            if ((Speeds[I] != 0) or (SpeedsX[I] != 0)) then
                call SetUnitFlyHeight(Units[I], GetUnitFlyHeight(Units[I]) + (Speeds[I] * TimerGetTimeout(GetExpiredTimer())), 0)
                set Speeds[I] = (Speeds[I] + (Acceleration[I] * TimerGetTimeout(GetExpiredTimer())))
            else
                call SetUnitFlyHeight(Units[I], Heights[I], 0)
            endif
            if (RAbsBJ((GetUnitFlyHeight(Units[I]) - Heights[I])) < (RMaxBJ(RAbsBJ(Speeds[I]), RAbsBJ(SpeedsX[I])) * TimerGetTimeout(GetExpiredTimer()))) then
                call SetUnitFlyHeight(Units[I], Heights[I], 0)
                set S = I
                loop
                    exitwhen S == index
                    set Units[S] = Units[S + 1]
                    set Heights[S] = Heights[S + 1]
                    set Types[S] = Types[S + 1]
                    set Speeds[S] = Speeds[S + 1]
                    set SpeedsX[S] = SpeedsX[S + 1]
                    set SpeedTypes[S] = SpeedTypes[S + 1]
                    set Acceleration[S] = Acceleration[S + 1]
                    set FlyHeights[S] = FlyHeights[S + 1]
                    set S = S + 1
                endloop
                set Units[index] = null
                set Heights[index] = 0
                set Types[index] = 0
                set Speeds[index] = 0
                set SpeedsX[index] = 0
                set SpeedTypes[index] = 0
                set Acceleration[index] = 0
                set FlyHeights[index] = 0
                set index = index - 1
            endif
            set I = I + 1
        endloop
        if index == 0 then
            call PauseTimer(Timer)
        endif
    endfunction

    function SetUnitFlyHeightEX takes unit Unit, real Height, integer Type, real Speed, integer SpeedType returns nothing
        local integer I = 1
        local boolean Repeat = false
        local integer S
        if GetUnitFlyHeight(Unit) == Height then
            return
        endif
        if index == 0 then
            call TimerStart(Timer, 0.01, true, function UnitHeightUpdate)
        endif
        if index > 0 then
            loop 
                exitwhen I > index
                if Units[I] == Unit then
                    set Repeat = true
                    set S = I
                endif
                set I = I + 1
            endloop
        endif
        if Repeat then
            set I = S
        else
            //计数自增
            set index = index + 1
            //记录单位
            set Units[index] = Unit
            set I = index
        endif
        //重设0高度 Tip:如果直接设置高度为0则实际触发返回结果为0.001 
        if Height <= 0.001 then
            set Heights[I] = 0.0001
        else
            set Heights[I] = Height
        endif
        //记录高度变化参数 1 为按速度 2 为按时间
        set Types[I] = Type
        //记录高度变化类型 0 为匀速 1为加速 2为减速
        set SpeedTypes[I] = SpeedType
        //根据高度变化类型记录速度
        if Speed > 0 then
            if SpeedType == 0 then //匀速变化
                if Type == 1 then //按速度变化
                    set Speeds[I] = RSignBJ(Height - GetUnitFlyHeight(Unit)) * Speed //初速度为Speed
                    set SpeedsX[I] = RSignBJ(Height - GetUnitFlyHeight(Unit)) * Speed //末速度为Speed
                else //按时间变化
                    set Speeds[I] = ((Height - GetUnitFlyHeight(Unit)) / Speed) 
                    set SpeedsX[I] = ((Height - GetUnitFlyHeight(Unit)) / Speed) 
                endif
                set Acceleration[I] = 0 //加速度为0
            elseif SpeedType == 1 then //加速变化
                if Type == 1 then //按速度变化
                    set Acceleration[I] = (Pow(Speed , 2) / (2 * (Height - GetUnitFlyHeight(Unit)))) //已知初速度为零，末速度为v，位移距离为x则加速度为(v^2/2x)
                else
                    set Acceleration[I] = ((2 * (Height - GetUnitFlyHeight(Unit))) / Pow(Speed , 2)) //已知初速度为零，时间为t，位移距离为x则加速度为(2x/t^2)
                endif
                set Speeds[I] = 0 //初速度为0
                set SpeedsX[I] = Speed //末速度为Speed
            elseif SpeedType == 2 then //减速变化
                if Type == 1 then //按速度变化
                    set Speeds[I] = (RSignBJ((Height - GetUnitFlyHeight(Unit))) * Speed) //初速度为Speed
                    set SpeedsX[I] = 0 //末速度为0
                    set Acceleration[I] = (-1 * (Pow(Speed , 2) / (2 * (Height - GetUnitFlyHeight(Unit))))) //已知初速度为v，末速度为0，位移距离为x则加速度为(-(v^2/2x))
                else //按时间变化
                    set Speeds[I] = ((2 * (Height - GetUnitFlyHeight(Unit))) / Speed) //已知末速度为0， 运动时间为t，位移距离为x则初速度为(2x/t)
                    set SpeedsX[I] = 0 //末速度为0
                    set Acceleration[I] =  (-1 * (2 * (Height - GetUnitFlyHeight(Unit))) / Pow(Speed , 2)) //已知末速度为0， 运动时间为t，位移距离为x则加速度为(-(2x/t^2))
                endif
            endif
        else
            set Speeds[I] = 0 //时间或速度为0则立即改变高度
            set SpeedsX[I] = 0 //时间或速度为0则立即改变高度
        endif
        //记录单位当前飞行高度
        set FlyHeights[I] = GetUnitFlyHeight(Unit)
        //让地面单位可以飞行
        call UnitAddAbility(Unit,'Amrf')
        call UnitRemoveAbility(Unit,'Amrf')
    endfunction

endlibrary

#endif
