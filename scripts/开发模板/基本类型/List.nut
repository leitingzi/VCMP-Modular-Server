class List extends Any {
	static Type = "List";
	entity = null;
	size = null;

	constructor(...) {
		entity = vargv.len() > 0 ? vargv : [];
		size = entity.len();
	}

	// ����ָ����С���б�ʹ���ṩ�ĺ�������Ԫ��
	function create(size, f = @(v) v) {
		entity = [];
		for (local i = 0; i < size; i++) {
			entity.append(f(i));
		}
		this.size = entity.len();
		return this;
	}

	// �����鴴���б�
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

	// �б�ϲ���+ �������
	function _add(other) {
		return addAll(other);
	}

	// �б���-�������
	function _sub(other) {
		return filter(@(v) !other.contain(v));
	}

	// ת��Ϊԭ������
	function toArray() {
		local arr = [];
		forEach(@(v) arr.append(v));
		return arr;
	}

	// ��ȡָ��������Ԫ��
	function get(index = 0) {
		return index < size ? entity[index] : null;
	}

	// ��ȡ���һ��Ԫ��
	function getTop() {
		return get(size - 1);
	}

	// ��ȡǰn��Ԫ��
	function take(n) {
		local result = List();
		local count = n >= size ? size : n;
		for (local i = 0; i < count; i++) {
			result.add(entity[i]);
		}
		return result;
	}

	// ��ȡָ����Χ��Ԫ��
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

	// ����Ԫ�ص�����
	function find(e) {
		return findFrom(@(v) v == e);
	}

	// ������������Ԫ������
	function findFrom(f) {
		for (local i = 0; i < size; i++) {
			if (f(entity[i])) {
				return i;
			}
		}
		return null;
	}

	// ����Ԫ��������δ�ҵ�����Ĭ��ֵ
	function findOrDefault(e, d) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return i;
			}
		}
		return d;
	}

	// ����Ƿ����Ԫ��
	function contain(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return true;
			}
		}
		return false;
	}

	// contain�ı���
	function has(e) {
		return contain(e);
	}

	// ��ȡȥ�غ���б�
	function distinct() {
		local result = List();
		forEach(function(v) {
			if (!result.contain(v)) {
				result.add(v);
			}
		});
		return result;
	}

	// ����һ���б�Ĳ���
	function union(otherList) {
		return addAll(otherList).distinct();
	}

	// ��ĩβ���Ԫ��
	function add(e) {
		addIn(size, e);
	}

	// ��ָ��λ�����Ԫ��
	function addIn(index, e) {
		local insertIndex = index < 0 ? 0 : (index > size ? size : index);
		entity.insert(insertIndex, e);
		size = entity.len();
	}

	// ��Ӷ��Ԫ��
	function addWith(...) {
		for (local i = 0; i < vargv.len(); i++) {
			add(vargv[i]);
		}
	}

	// �����һ���б������Ԫ��
	function addAll(otherList) {
		for (local i = 0; i < otherList.size; i++) {
			add(otherList.get(i));
		}
		return this;
	}

	// ��ԭ���������Ԫ��
	function addWithArray(arr) {
		for (local i = 0; i < arr.len(); i++) {
			add(arr[i]);
		}
	}

	// �Ƴ�ָ��Ԫ�أ���һ��ƥ���
	function remove(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				removeIndex(i);
				break;
			}
		}

		return this;
	}

	// �Ƴ�����ƥ���Ԫ��
	function removeAll(e) {
		return removeFrom(@(v) v == e);
	}

	// ���������Ƴ�Ԫ��
	function removeFrom(f) {
		for (local i = size - 1; i >= 0; i--) {
			if (f(entity[i])) {
				removeIndex(i);
			}
		}
		return this;
	}

	// �Ƴ�ָ��������Ԫ��
	function removeIndex(index) {
		if (index >= 0 && index < size) {
			entity.remove(index);
			size = entity.len();
		}

		return this;
	}

	// ��ת�б�
	function reverse() {
		entity.reverse();
		return this;
	}

	// ����ʹ��Ĭ�ϱȽ�����
	function sort() {
		entity.sort();
		return this;
	}

	// ʹ���Զ���Ƚ�������
	function sortBy(f = @(a, b) a <=> b) {
		entity.sort(f);
		return this;
	}

	// ����б�
	function clear() {
		entity.clear();
		size = 0;
	}

	// ��������Ԫ��
	function forEach(f) {
		for (local i = 0; i < size; i++) {
			f(entity[i]);
		}
	}

	// �������ı���
	function forEachIndex(f) {
		for (local i = 0; i < size; i++) {
			f(i, entity[i]);
		}
	}

	// �������
	function forEachReverse(f) {
		for (local i = size - 1; i >= 0; i--) {
			f(entity[i]);
		}
	}

	// ӳ��ת��
	function map(f) {
		local newList = List();
		forEach(@(v) newList.add(f(v)));
		return newList;
	}

	// ����Ԫ��
	function filter(f) {
		local newList = List();
		forEach(function(v) {
			if (f(v)) {
				newList.add(v);
			}
		});
		return newList;
	}

	// ���˵�nullԪ��
	function filterNotNull() {
		return filter(@(v) v != null);
	}

	// ����������б�
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

	// ��Ԫ�����ͷ���
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

	// ���Զ��庯������
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

	// ��Լ����
	function reduce(initial, operation) {
		local accumulator = initial;
		for (local i = 0; i < size; i++) {
			accumulator = operation(accumulator, entity[i]);
		}
		return accumulator;
	}

	// ����Ƿ�Ϊ��
	function isEmpty() {
		return size == 0;
	}

	// ����Ƿ�����Ԫ�ض�Ϊnull
	function isBlank() {
		return all(@(v) v == null);
	}

	// �������Ԫ���Ƿ�Ϊ��ͬ����
	function isSameType() {
		if (isEmpty()) {
			return true;
		}
		local firstType = typeof get(0);
		return all(@(v) typeof v == firstType);
	}

	// ��ȡ����Ԫ�صĹ������ͣ����һ�£�
	function getSameType() {
		return isSameType() ? typeof get(0) : null;
	}

	// ����Ƿ���Ԫ����������
	function any(predicate = null) {
		if (predicate == null) {
			return isEmpty();
		}
		return findFrom(predicate) != null
	}

	 // ����Ƿ�����Ԫ�ض���������
	function all(predicate) {
		for (local i = 0; i < size; i++) {
			if (!predicate(entity[i])) {
				return false;
			}
		}
		return true;
	}

	// ����Ԫ��Ϊ�ַ���
	function joinString(string = ", ") {
		return joinStringFor(separator);
	}

	// ʹ���Զ���ת����������Ԫ��Ϊ�ַ���
	function joinStringFor(string = ", ", f = @(v) v.tostring()) {
		local data = "";
		local f = @(i, v) data += i < size - 1 ? f(v) + string : f(v);
		forEachIndex(f.bindenv(this));
		return data;
	}

	// ����һ���б���������
	function zip(otherList) {
		if (size != otherList.size) {
			return null;
		}

		local map = Map();
		forEachIndex(@(i, v) map.add(Pair(v, otherList.get(i))));
		return map;
	}

	// ��ƽ���б�
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

	// ��ӳ����ƽ��
	function flatMap(f) {
		return map(f).flatten();
	}
}

local a = List(null, 1, null);
local b = List(1, 3, 4);
print(b.any(@(v) v == 3));