
/*
Map 类说明文档
概述
	Map 类是基于键值对（Pair）的映射容器，用于存储和管理键值关联数据集合，提供了丰富的操作方法。
核心属性
	static Type = "Map": 类标识
	list: 内部存储的 Pair 列表
	size: 映射中键值对的数量
构造方法
	Map(...)
	可接收多个 Pair 实例作为参数初始化映射

主要方法
	添加操作
		add(pair): 添加 Pair 实例（若键已存在则替换）
		addAll(otherMap): 合并另一个 Map（键冲突时累加值）
		put(key, e): 通过键值直接添加（自动创建 Pair）
	查询操作
		get(key): 获取指定键的值
		getOrDefault(key, d): 获取值，不存在则返回默认值 d
		getOrNull(key): 获取值，不存在则返回 null
		hasKey(key): 判断是否包含指定键
		contain(pair): 判断是否包含指定 Pair
		keys(): 返回所有键的列表
		values(): 返回所有值的列表
	修改与删除
		remove(key): 移除指定键的键值对
		clear(): 清空所有键值对
	遍历与转换
		forEach(f): 遍历所有 Pair 并执行函数 f
		forEachValue(f): 遍历所有值并执行函数 f
		map(f): 对每个值应用函数 f，返回新 Map
		filter(f): 过滤符合条件的 Pair，返回新 Map
		isEmpty(): 判断映射是否为空
		_tostring(): 转换为字符串表示
	序列化
		static fromSaveString(string, f): 从保存字符串解析为 Map 实例
		getSaveString(f): 转换为可保存的字符串格式
特性说明
	内部基于 List 存储 Pair 实例
	键具有唯一性，添加重复键会自动替换旧值
	所有操作会自动维护 size 属性的准确性
	仅支持 Pair 类型数据存储，确保类型安全
*/

class Map extends Any {
	static Type = "Map";
	list = null;
	size = null;

	constructor(...){
		list = List();
		for (local i = 0; i < vargv.len(); i++) {
			add(vargv[i]);
		}
		size = list.size;
	}

	function add(pair) {
		if(typeof pair != Pair.Type) {
			throw "Map只能存入" + Pair.Type + "类型的数据";
		}
		if(contain(pair)) {
			remove(pair.key);
		}
		list.add(pair);
		size = list.size;
	}

	function addAll(otherMap) {
		local thisPack = this;
		otherMap.forEach(function (pair) {
			if(thisPack.hasKey(pair.key)) {
				thisPack.put(pair.key, thisPack.get(pair.key) + pair.value);
			} else {
				thisPack.add(pair);
			}
		});
	}

	function put(key, e) {
		return add(Pair(key, e));
	}

	function contain(pair) {
		return hasKey(pair.key);
	}

	function remove(key) {
		local findIndex = list.findFrom(@(v) v.key == key);
		if(findIndex != null) {
			list.removeIndex(findIndex);
			size = list.size;
		}
	}

	function get(key) {
		return getOrNull(key);
	}

	function getOrDefault(key, d) {
		local findIndex = list.findFrom(@(v) v.key == key);
		return findIndex != null ? list.get(findIndex).value : d
	}

	function getOrNull(key) {
		return getOrDefault(key, null);
	}

	function hasKey(key) {
		return list.filter(@(v) v.key == key).size > 0 ? true : false;
	}

	function keys() {
		return list.map(@(v) v.key);
	}

	function values() {
		return list.map(@(v) v.value);
	}

	function clear() {
		list.clear();
	}

	function isEmpty() {
		return list.size == 0;
	}

	function forEach(f) {
		list.forEach(f);
	}

	function forEachValue(f) {
		for (local i = 0; i < list.size; i++) {
			f(list.get(i).value);
		}
	}

	function map(f) {
		local newMap = Map();
		for (local i = 0; i < list.size; i++) {
			local pair = list.get(i);
			newMap.put(pair.key, f(pair.value));
		}
		return newMap;
	}

	function filter(f) {
		local newMap = Map();
		for (local i = 0; i < list.size; i++) {
			local pair = list.get(i);
			if(f(pair)) {
				newMap.add(pair);
			}
		}
		return newMap;
	}

	function _tostring() {
		return list.tostring();
	}
}