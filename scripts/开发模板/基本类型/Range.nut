
/*
Range 类说明文档
概述
	Range 类是用于管理数值范围（整数或浮点数）的工具类，提供范围检查、随机值生成、序列化等功能，适用于需要数值区间约束的场景。
核心属性
	static Type = "Range": 类标识，用于类型判断和序列化
	value1: 范围的起始值（整数或浮点数）
	value2: 范围的结束值（整数或浮点数）
构造方法
	Range(value1, value2)

参数要求：value1 和 value2 必须是整数（integer）或浮点数（float）
异常抛出：若参数类型不符合要求，抛出 Range的参数必须是整数或浮点数 异常

静态方法
WithIn(v1, v2, i)		检查数值 i 是否在 [v1, v2] 闭区间内	- v1：范围起始值- v2：范围结束值- i：待检查数值			 布尔值（true 表示在范围内，false 反之）
fromSaveString(string)	从序列化字符串解析为 Range 实例	string：通过 getSaveString() 生成的保存字符串				解析成功返回 Range 实例，失败返回 null

实例方法
_tostring()			转换为易读的字符串格式													无						字符串（格式：Range(起始值 .. 结束值)，如 Range(1 .. 10)）
checkIn(v)			检查数值 v 是否在当前实例的 [value1, value2] 闭区间内					v：待检查数值				布尔值（true 表示在范围内，false 反之）
untilIn(v)			检查数值 v 是否在当前实例的 (value1, value2) 开区间内（不包含边界）		v：待检查数值				布尔值（true 表示在范围内，false 反之）
rand()				在当前实例的 [value1, value2] 范围内生成随机值							无						随机整数 / 浮点数（与 value1/value2 类型一致）
getSaveString()		将当前 Range 实例序列化为字符串，用于保存或传输							无							序列化字符串（格式：value1_value2:Range，如 1_10:Range）

核心特性
	类型安全：强制限制范围值为整数或浮点数，避免非法类型传入
	区间灵活检查：支持闭区间（checkIn）和开区间（untilIn）两种范围判断逻辑
	序列化支持：通过 fromSaveString 和 getSaveString 实现实例的保存与恢复
	随机值便捷生成：直接调用 rand() 即可获取范围内的随机值，无需额外处理
*/

class Range extends Any {
	static Type = "Range";
	value1 = null;
	value2 = null;

	constructor(value1, value2) {
		if ((typeof value1 == "integer" || typeof value1 == "float") && (typeof value2 == "integer" || typeof value2 == "float")) {
			this.value1 = value1;
			this.value2 = value2;
		} else {
			throw Type + "的参数必须是整数或浮点数";
		}
	}

	static function WithIn(v1, v2, i) {
		return i >= v1 && i <= v2;
	}

	function _tostring() {
		return Type + "(" + value1 + " .. " + value2 + ")";
	}

	function checkIn(v) {
		return v >= value1 && v <= value2;
	}

	function untilIn(v) {
		return v > value1 && v < value2;
	}

	function rand() {
		return Rand.inRanger(this);
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string);
		if (e.type == Type) {
			local value1 = e.valueArray[0].tofloat();
			local value2 = e.valueArray[1].tofloat();
			return Range(value1, value2);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return value1 + "_" + value2 + ":" + Type;
	}
}