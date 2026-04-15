#ifndef HcGetDistanceBetweenCoordAndLine_Used
#define HcGetDistanceBetweenCoordAndLine_Used

library HcGetDistanceBetweenCoordAndLine

function XG_GetDistanceBetweenCoordAndLine takes \
    real x_source, real y_source, \
    real x_segment_a, real y_segment_a, \
    real x_segment_b, real y_segment_b \
returns real
    //https://blog.csdn.net/u012138730/article/details/79779996
    // 先计算r的值 看r的范围 （p相当于A点，q相当于B点，pt相当于P点）
    // AB 向量
	local real pqx = x_segment_b - x_segment_a
	local real pqy = y_segment_b - y_segment_a
	//local real pqz = z_segment_b - z_segment_a
    // AP 向量
	local real dx = x_source - x_segment_a
	local real dy = y_source - y_segment_a
	//local real dz = z_source - z_segment_a

    // qp线段长度的平方=上面公式中的分母：AB向量的平方。
	local real d = pqx*pqx + pqy*pqy //+ pqz*pqz
    // （p pt向量）点积 （pq 向量）= 公式中的分子：AP点积AB
	local real t = pqx*dx + pqy*dy //+ pqz*dz

    // t 就是 公式中的r了 
	if (d > 0.00) then        // 除数不能为0; 如果为零 t应该也为零。下面计算结果仍然成立。                   
		set t = t / d    // 此时t 相当于 上述推导中的 r。
    endif

    // 分类讨论 
    if (t < 0.00) then
		set t = 0.00     // 当t（r）< 0时，最短距离即为 pt点 和 p点（A点和P点）之间的距离。
	elseif (t > 1.00) then
		set t = 1.00   // 当t（r）> 1时，最短距离即为 pt点 和 q点（B点和P点）之间的距离。
    endif

	// t = 0，计算 pt点 和 p点的距离; （A点和P点）
    // t = 1, 计算 pt点 和 q点 的距离; （B点和P点）
    // 否则计算 pt点 和 投影点 的距离。（C点和P点 ，t*（pqx，pqy，pqz）就是向量AC）
	set dx = x_segment_a + t*pqx - x_source
	set dy = y_segment_a + t*pqy - y_source
	//dz = z_segment_a + t*pqz - z_source

    // 算出来是距离的平方，后续自行计算距离
    // dist = dx*dx + dy*dy + dz*dz
    return SquareRoot( dx*dx + dy*dy )
endfunction

function XG_IsCoordPerpendicularToLine takes \
    real x_source, real y_source, \
    real x_segment_a, real y_segment_a, \
    real x_segment_b, real y_segment_b \
returns boolean
    //https://blog.csdn.net/u012138730/article/details/79779996
	local real pqx = x_segment_b - x_segment_a
	local real pqy = y_segment_b - y_segment_a
	//local real pqz = z_segment_b - z_segment_a

	local real dx = x_source - x_segment_a
	local real dy = y_source - y_segment_a
	//local real dz = z_source - z_segment_a

	local real d = pqx*pqx + pqy*pqy //+ pqz*pqz
	local real t = pqx*dx + pqy*dy //+ pqz*dz

	if (d > 0.00) then 
		set t = t / d
    endif

    return 0.00 <= t and t <= 1.00
endfunction

endlibrary
#endif

