
/*
Pair 类说明文档
概述
	Pair 类是一个键值对容器，用于存储和管理键值关联数据，提供了键值对的创建、转换、比较等功能。
核心属性
	static Type = "Pair": 类标识
	key: 键值对的键（不可为 null）
	value: 键值对的值
构造方法
	Pair(key, value = null)
	参数:
		key: 键（必填，不能为空）
		value: 值（可选，默认为 null）
	异常：当 key 为 null 时抛出异常 "Pair 类型的 Key 不能为空"

静态方法
	fromSaveString(string): 从保存的字符串中解析并创建 Pair 实例
	Type: 类静态标识属性

实例方法
	getSaveString(): 将 Pair 实例转换为可保存的字符串格式
	create(table): 从表格数据创建 Pair 实例（提取第一个有效键值对）
	_tostring(): 转换为字符串表示（格式: "key to value"）
	_cmp(other): 与另一个 Pair 实例比较（基于 value 值）
	equal(other): 判断与另一个 Pair 实例是否相等（键和值都需相等）
	toTable(): 转换为表格形式（{key, value}）
	reverse(): 交换键和值并返回当前实例
	copy(newKey = null, newValue = null): 创建副本，可指定新的键和值

主要功能
	安全的键值对管理（确保键不为空）
	支持序列化和反序列化（保存和恢复数据）
	提供多种格式转换（字符串、表格）
	支持比较和复制操作
	可交换键值关系
*/

class Pair extends Any {
	static Type = "Pair";
	key = null;
	value = null;

	constructor(key, value = null) {
		if (key == null) {
			throw "Pair类型的Key不能为空";
		}

		this.key = key;
		this.value = value;
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string, "&", "*");
		if (e.type == Type) {
			local valueType = e.valueArray[2];
			local key = e.valueArray[1];
			local value = TypeConver.Conver(valueType, e.valueArray[0]);
			return Pair(key, value);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return TypeConver.getSaveString(value) + "*" + key + "*" + typeof value + "&" + Type;
	}

	function create(table) {
		foreach(i, value in table) {
			if (i == null) {
				continue;
			}
			this.key = i;
			this.value = value;
			break;
		}
		if (this.key == null) {
			throw "Pair类型的Key不能为空";
		}
		return this;
	}

	function _tostring() {
		return key + " to " + value;
	}

	function _cmp(other) {
		if (value < other.value) return -1;
		if (value > other.value) return 1;
		return 0;
	}

	function equal(other) {
		return value == other.value && key == other.key;
	}

	function toTable() {
		return {
			key = this.key,
			value = this.value
		};
	}

	function reverse() {
		local key = this.key;
		this.key = this.value;
		this.value = key;
		return this;
	}

	function copy(newKey = null, newValue = null) {
		return Pair(newKey != null ? newKey : this.key, newValue != null ? newValue : this.value);
	}
}