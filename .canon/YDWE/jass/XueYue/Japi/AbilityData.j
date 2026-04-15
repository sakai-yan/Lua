#ifndef XGAbilityDataIncluded
#define XGAbilityDataIncluded

#include "japi\\YDWEAbilityState.j"
library XGAbilityData requires YDWEAbilityState

	function XG_GetAbilityDataInteger takes ability abil, integer level, integer data_type returns integer
		return EXGetAbilityDataInteger(abil, level, data_type)
	endfunction

	function XG_SetAbilityDataInteger takes ability abil, integer level, integer data_type, integer value returns boolean
		return EXSetAbilityDataInteger(abil, level, data_type, value)
	endfunction

	function XG_GetAbilityDataReal takes ability abil, integer level, integer data_type returns real
		return EXGetAbilityDataReal(abil, level, data_type)
	endfunction

	function XG_SetAbilityDataReal takes ability abil, integer level, integer data_type, real value returns boolean
		return EXSetAbilityDataReal(abil, level, data_type, value)
	endfunction

	function XG_GetAbilityDataString takes ability abil, integer level, integer data_type returns string
		return EXGetAbilityDataString(abil, level, data_type)
	endfunction

	function XG_SetAbilityDataString takes ability abil, integer level, integer data_type, string value returns boolean
		return EXSetAbilityDataString(abil, level, data_type, value)
	endfunction

	//冷却等通用属性
	function XG_GetAbilityState takes ability abil, integer state_type returns real
		return EXGetAbilityState(abil, state_type)
	endfunction

	function XG_SetAbilityState takes ability abil, integer state_type, real value returns boolean
		return EXSetAbilityState(abil, state_type, value)
	endfunction

	function XG_GetUnitAbilityByIndex takes unit u, integer index returns ability
		return EXGetUnitAbilityByIndex(u, index)
	endfunction
	
	function XG_GetUnitAbility takes unit u, integer abilcode returns ability
		return EXGetUnitAbility(u, abilcode)
	endfunction

	function XG_GetAbilityId takes ability abil returns integer
		return EXGetAbilityId(abil)
	endfunction

	
endlibrary

#endif
