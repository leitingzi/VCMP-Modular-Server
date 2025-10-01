class List extends Any {
	static Type = "List";
	entity = null;
	size = null;

	constructor(...) {
		entity = vargv.len() > 0 ? vargv : [];
		size = entity.len();
	}

	// 创建指定大小的列表，使用提供的函数生成元素
	function create(size, f = @(v) v) {
		entity = [];
		for (local i = 0; i < size; i++) {
			entity.append(f(i));
		}
		this.size = entity.len();
		return this;
	}

	// 从数组创建列表
	function createFrom(arr) {
		entity = [];
		for (local i = 0; i < arr.len(); i++) {
			entity.append(arr[i]);
		}
		this.size = entity.len();
		return this;
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string, "$", "!");
		if (e.type == Type) {
			local valueType = e.valueArray[1];
			local valueArray = split(e.valueArray[0], "#");
			local list = List();

			for (local i = 0; i < valueArray.len(); i++) {
				local value = TypeConver.Conver(valueType, valueArray[i]);
				list.add(value);
			}
			return list;
		} else {
			return null;
		}
	}

	function getSaveString() {
		local data = "";
		for (local i = 0; i < entity.len(); i++) {
			data += TypeConver.getSaveString(entity[i]) + (i + 1 < entity.len() ? "#" : "");
		}
		return data + "!" + getSameType() + "$" + Type;
	}

	function _tostring() {
		return "[" + joinString() + "]";
	}

	// 列表合并（+ 运算符）
	function _add(other) {
		return addAll(other);
	}

	// 列表差集（-运算符）
	function _sub(other) {
		return filter(@(v) !other.contain(v));
	}

	// 转换为原生数组
	function toArray() {
		local arr = [];
		forEach(@(v) arr.append(v));
		return arr;
	}

	// 获取指定索引的元素
	function get(index = 0) {
		return index < size ? entity[index] : null;
	}

	// 获取最后一个元素
	function getTop() {
		return get(size - 1);
	}

	// 获取前n个元素
	function take(n) {
		local result = List();
		local count = n >= size ? size : n;
		for (local i = 0; i < count; i++) {
			result.add(entity[i]);
		}
		return result;
	}

	// 获取指定范围的元素
	function takeIn(n, m = null) {
		if (m == null) {
			m = size;
		}
		local result = List();
		local count = n >= size ? size : n;
		for (local i = n; i < m; i++) {
			result.add(entity[i]);
		}
		return result;
	}

	// 查找元素的索引
	function find(e) {
		return findFrom(@(v) v == e);
	}

	// 根据条件查找元素索引
	function findFrom(f) {
		for (local i = 0; i < size; i++) {
			if (f(entity[i])) {
				return i;
			}
		}
		return null;
	}

	// 查找元素索引，未找到返回默认值
	function findOrDefault(e, d) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return i;
			}
		}
		return d;
	}

	// 检查是否包含元素
	function contain(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return true;
			}
		}
		return false;
	}

	// contain的别名
	function has(e) {
		return contain(e);
	}

	// 获取去重后的列表
	function distinct() {
		local result = List();
		forEach(function(v) {
			if (!result.contain(v)) {
				result.add(v);
			}
		});
		return result;
	}

	// 与另一个列表的并集
	function union(otherList) {
		return addAll(otherList).distinct();
	}

	// 在末尾添加元素
	function add(e) {
		addIn(size, e);
	}

	// 在指定位置添加元素
	function addIn(index, e) {
		local insertIndex = index < 0 ? 0 : (index > size ? size : index);
		entity.insert(insertIndex, e);
		size = entity.len();
	}

	// 添加多个元素
	function addWith(...) {
		for (local i = 0; i < vargv.len(); i++) {
			add(vargv[i]);
		}
	}

	// 添加另一个列表的所有元素
	function addAll(otherList) {
		for (local i = 0; i < otherList.size; i++) {
			add(otherList.get(i));
		}
		return this;
	}

	// 从原生数组添加元素
	function addWithArray(arr) {
		for (local i = 0; i < arr.len(); i++) {
			add(arr[i]);
		}
	}

	// 移除指定元素（第一个匹配项）
	function remove(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				removeIndex(i);
				break;
			}
		}

		return this;
	}

	// 移除所有匹配的元素
	function removeAll(e) {
		return removeFrom(@(v) v == e);
	}

	// 根据条件移除元素
	function removeFrom(f) {
		for (local i = size - 1; i >= 0; i--) {
			if (f(entity[i])) {
				removeIndex(i);
			}
		}
		return this;
	}

	// 移除指定索引的元素
	function removeIndex(index) {
		if (index >= 0 && index < size) {
			entity.remove(index);
			size = entity.len();
		}

		return this;
	}

	// 反转列表
	function reverse() {
		entity.reverse();
		return this;
	}

	// 排序（使用默认比较器）
	function sort() {
		entity.sort();
		return this;
	}

	// 使用自定义比较器排序
	function sortBy(f = @(a, b) a <=> b) {
		entity.sort(f);
		return this;
	}

	// 清空列表
	function clear() {
		entity.clear();
		size = 0;
	}

	// 遍历所有元素
	function forEach(f) {
		for (local i = 0; i < size; i++) {
			f(entity[i]);
		}
	}

	// 带索引的遍历
	function forEachIndex(f) {
		for (local i = 0; i < size; i++) {
			f(i, entity[i]);
		}
	}

	// 反向遍历
	function forEachReverse(f) {
		for (local i = size - 1; i >= 0; i--) {
			f(entity[i]);
		}
	}

	// 映射转换
	function map(f) {
		local newList = List();
		forEach(@(v) newList.add(f(v)));
		return newList;
	}

	// 过滤元素
	function filter(f) {
		local newList = List();
		forEach(function(v) {
			if (f(v)) {
				newList.add(v);
			}
		});
		return newList;
	}

	// 过滤掉null元素
	function filterNotNull() {
		return filter(@(v) v != null);
	}

	// 按条件拆分列表
	function match(f) {
		local a = List(), b = List();
		for (local i = 0; i < size; i++) {
			if (f(entity[i])) {
				a.add(entity[i]);
			} else {
				b.add(entity[i]);
			}
		}
		return {
			match = a,
			matchNot = b
		};
	}

	// 按元素类型分组
	function group() {
		local table = {};
		local f = function(v) {
			local t = typeof v;
			if (!table.rawin(t)) {
				table.rawset(t, List());
			}
			table[t].add(v);
		}
		forEach(f);
		return table;
	}

	// 按自定义函数分组
	function groupFrom(func) {
		local map = Map();
		local f = function(v) {
			local key = func(v);
			if (!map.hasKey(key)) {
				map.put(key, List());
			}
			map.get(key).add(v);
		}
		forEach(f);
		return map;
	}

	// 归约操作
	function reduce(initial, operation) {
		local accumulator = initial;
		for (local i = 0; i < size; i++) {
			accumulator = operation(accumulator, entity[i]);
		}
		return accumulator;
	}

	// 检查是否为空
	function isEmpty() {
		return size == 0;
	}

	// 检查是否所有元素都为null
	function isBlank() {
		return all(@(v) v == null);
	}

	// 检查所有元素是否为相同类型
	function isSameType() {
		if (isEmpty()) {
			return true;
		}
		local firstType = typeof get(0);
		return all(@(v) typeof v == firstType);
	}

	// 获取所有元素的公共类型（如果一致）
	function getSameType() {
		return isSameType() ? typeof get(0) : null;
	}

	// 检查是否有元素满足条件
	function any(predicate = null) {
		if (predicate == null) {
			return isEmpty();
		}
		return findFrom(predicate) != null
	}

	 // 检查是否所有元素都满足条件
	function all(predicate) {
		for (local i = 0; i < size; i++) {
			if (!predicate(entity[i])) {
				return false;
			}
		}
		return true;
	}

	// 连接元素为字符串
	function joinString(string = ", ") {
		return joinStringFor(separator);
	}

	// 使用自定义转换函数连接元素为字符串
	function joinStringFor(string = ", ", f = @(v) v.tostring()) {
		local data = "";
		local f = @(i, v) data += i < size - 1 ? f(v) + string : f(v);
		forEachIndex(f.bindenv(this));
		return data;
	}

	// 与另一个列表拉链操作
	function zip(otherList) {
		if (size != otherList.size) {
			return null;
		}

		local map = Map();
		forEachIndex(@(i, v) map.add(Pair(v, otherList.get(i))));
		return map;
	}

	// 扁平化列表
	function flatten() {
		local newList = List();
		forEach(function(v) {
			if (typeof v == List.Type) {
				newList.addAll(v.flatten());
			} else if (typeof v == "array") {
				newList.addWithArray(v);
			} else {
				newList.add(v);
			}
		});
		return newList;
	}

	// 先映射后扁平化
	function flatMap(f) {
		return map(f).flatten();
	}
}

local a = List(null, 1, null);
local b = List(1, 3, 4);
print(b.any(@(v) v == 3));