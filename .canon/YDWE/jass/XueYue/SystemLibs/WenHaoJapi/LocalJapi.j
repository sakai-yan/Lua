#ifndef WenHaoLocalJapiIncluded
#define WenHaoLocalJapiIncluded

#define FLAG_FIFO       1 //队列  指令进入队列,相当于按住shift发布指令
#define FLAG_INSTANT    2 //瞬发  瞬发指令,该指令会立即触发发布命令事件(即使单位处于晕眩状态)
#define FLAG_ONLY       4 //独立  单独施放,当选中多个单位时只有一个单位会响应该指令
#define FLAG_RESTORE    32//恢复 恢复指令,该指令完成后会恢复之前的指令
// 这4个消息标志可以相加组合

//使用方法 本地坐标命令(命令id,坐标x轴,坐标y轴,FLAG_INSTANT + FLAG_ONLY) flag标签为   瞬发+独立
library WenHaoLocalActionLib requires WenHaoJapi
    globals
        private constant hashtable ht=WenHaoJapi_ht
        private constant integer key=StringHash("jass")
    endglobals
    private function Call takes string str returns nothing
        call UnitId(str)
    endfunction
    
    //本地发布无目标命令
    function LocalOrder takes integer order,integer flags returns nothing
        call SaveStr(ht,key,0,"(II)V")
        call SaveInteger(ht,key,1,order)
        call SaveInteger(ht,key,2,flags)
        call Call("LocalOrder")
    endfunction
    
    //本地发布坐标命令
    function LocalPointOrder takes integer order,real x,real y,integer flags returns nothing
        call SaveStr(ht,key,0,"(IRRI)V")
        call SaveInteger(ht,key,1,order)
        call SaveReal(ht,key,2,x)
        call SaveReal(ht,key,3,y)
        call SaveInteger(ht,key,4,flags)
        call Call("LocalPointOrder")
    endfunction
    
    //本地发布目标命令
    function LocalTargetOrder takes integer order,unit u,integer flags returns nothing
        call SaveStr(ht,key,0,"(III)V")
        call SaveInteger(ht,key,1,order)
        call SaveInteger(ht,key,2,GetHandleId(u))
        call SaveInteger(ht,key,3,flags)
        call Call("LocalTargetOrder")
    endfunction
    
    //获取玩家当前选择的单位
    function GetPlayerSelectedUnit takes player p returns unit
        call SaveStr(ht,key,0,"(I)Hunit;")
        call RemoveSavedHandle(ht,key,0)
        call SaveInteger(ht,key,1,GetHandleId(p))
        call Call("GetPlayerSelectedUnit")
        return         LoadUnitHandle(ht,key,0)
    endfunction
    
    //获取玩家当前鼠标指向的单位
    function GetTargetUnit takes nothing returns unit
        call SaveStr(ht,key,0,"(V)Hunit;")
        call RemoveSavedHandle(ht,key,0)
        call Call("GetTargetObject")
        return         LoadUnitHandle(ht,key,0)
    endfunction
    
    //获取玩家当前鼠标指向的物品
    function GetTargetItem takes nothing returns item
        call SaveStr(ht,key,0,"(V)Hitem;")
        call RemoveSavedHandle(ht,key,0)
        call Call("GetTargetObject")
        return         LoadItemHandle(ht,key,0)
    endfunction
    
    //获取玩家当前鼠标指向的 可选择的可破坏物
    function GetTargetDestructable takes nothing returns destructable
        call SaveStr(ht,key,0,"(V)Hdestructable;")
        call RemoveSavedHandle(ht,key,0)
        call Call("GetTargetObject")
        return LoadDestructableHandle(ht,key,0)
    endfunction
    
    // 设置单位技能按钮是否显示   false 即隐藏 隐藏之后无法发布命令 跟玩家禁用相同
    //使用不会打断命令  可以 在发布命令的时候  显示 发布命令 隐藏 即可
    function SetUnitAbilityButtonShow takes unit u,integer id,boolean show returns nothing
        call SaveStr(ht,key,0,"(IIB)V")
        call SaveInteger(ht,key,1,GetHandleId(u))
        call SaveInteger(ht,key,2,id)
        call SaveBoolean(ht,key,3,show)
        call Call("SetUnitAbilityButtonShow")
    endfunction
    
    //设置 是否显示FPS  显示状态下 调用false 可以隐藏 ，相反可以显示
    function ShowFpsText takes boolean Open returns nothing
        call SaveStr(ht,key,0,"(B)V")
        call SaveBoolean(ht,key,1,Open)
        call Call("ShowFpsText")
    endfunction
    
    //获取当前游戏的 fps值  即 游戏画面的帧数
    function GetFps takes nothing returns real
        call SaveStr(ht,key,0,"()R")
        call Call("GetFps")
        return LoadReal(ht,key,0)
    endfunction
    
    //获取聊天状态  有聊天输入框的情况下 返回true  没有返回false 
    //可以通过 d3d库里的模拟按键 模拟按下ESC 或者enter 来禁止玩家聊天
    function GetChatState takes nothing returns boolean
        call SaveStr(ht,key,0,"()B")
        call Call("GetChatState")
        return LoadBoolean(ht,key,0)
    endfunction
  
endlibrary

#endif
