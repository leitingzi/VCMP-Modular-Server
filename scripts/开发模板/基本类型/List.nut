class List extends Any {
	static Type = "List";
	entity = null;
	size = null;

	constructor(...) {
		entity = vargv.len() > 0 ? vargv : [];
		size = entity.len();
	}

	function create(size, f = @(v) v) {
		entity = [];
		for (local i = 0; i < size; i++) {
			entity.append(f(i));
		}
		this.size = entity.len();
		return this;
	}

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
				local value = TypeConversion.Conver(valueType, valueArray[i]);
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
			data += TypeConversion.getSaveString(entity[i]) + (i + 1 < entity.len() ? "#" : "");
		}
		return data + "!" + getSameType() + "$" + Type;
	}

	function _tostring() {
		return "[" + joinString() + "]";
	}

	function _add(other) {
		return addAll(other);
	}

	function _sub(other) {
		local f = @(v) !other.contain(v) ? v : null;
		return map(f.bindenv(this)).filterNotNull();
	}

	function toArray() {
		local arr = [];
		forEach(@(v) arr.append(v));
		return arr;
	}

	function get(index = 0) {
		return index < size ? entity[index] : null;
	}

	function getTop() {
		return get(size - 1);
	}

	function take(n) {
		local result = List();
		local count = n >= size ? size : n;
		for (local i = 0; i < count; i++) {
			result.add(entity[i]);
		}
		return result;
	}

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

	function find(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return i;
			}
		}
		return null;
	}

	function findFrom(f) {
		for (local i = 0; i < size; i++) {
			if (f(entity[i])) {
				return i;
			}
		}
		return null;
	}

	function findOrDefault(e, d) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return i;
			}
		}
		return d;
	}

	function contain(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				return true;
			}
		}
		return false;
	}

	function has(e) {
		return contain(e);
	}

	function distinct() {
		local result = List();
		forEach(function(v) {
			if (!result.contain(v)) {
				result.add(v);
			}
		});
		return result;
	}

	function union(otherList) {
		return addAll(otherList).distinct();
	}

	function add(e) {
		addIn(size, e);
	}

	function addIn(index, e) {
		entity.insert(index, e);
		size = entity.len();
	}

	function addWith(...) {
		for (local i = 0; i < vargv.len(); i++) {
			add(vargv[i]);
		}
	}

	function addAll(otherList) {
		for (local i = 0; i < otherList.size; i++) {
			add(otherList.get(i));
		}
		return this;
	}

	function addWithArray(arr) {
		for (local i = 0; i < arr.len(); i++) {
			add(arr[i]);
		}
	}

	function remove(e) {
		for (local i = 0; i < size; i++) {
			if (entity[i] == e) {
				removeIndex(i);
				break;
			}
		}
	}

	function removeAll(e) {
		local find = false;
		do {
			find = false;
			for (local i = 0; i < size; i++) {
				if (i < entity.len()) {
					if (entity[i] == e) {
						removeIndex(i);
						find = true;
					}
				} else {
					break;
				}
			}
		}
		while (find);
	}

	function removeFrom(f) {
		local find = false;
		do {
			find = false;
			for (local i = 0; i < size; i++) {
				if (i < entity.len()) {
					if (f(entity[i])) {
						removeIndex(i);
						find = true;
					}
				} else {
					break;
				}
			}
		}
		while (find);
	}

	function removeIndex(index) {
		entity.remove(index);
		size = entity.len();
	}

	function reverse() {
		entity.reverse();
		return this;
	}

	function sort() {
		entity.sort();
		return this;
	}

	function sortBy(f = @(a, b) a <=> b) {
		entity.sort(f);
		return this;
	}

	function clear() {
		entity.clear();
		size = 0;
	}

	function forEach(f) {
		for (local i = 0; i < size; i++) {
			f(entity[i]);
		}
	}

	function forEachIndex(f) {
		for (local i = 0; i < size; i++) {
			f(i, entity[i]);
		}
	}

	function forEachReverse(f) {
		for (local i = size - 1; i >= 0; i--) {
			f(entity[i]);
		}
	}

	function map(f) {
		local newList = List();
		forEach(@(v) newList.add(f(v)));
		return newList;
	}

	function filter(f) {
		local newList = List();
		forEach(function(v) {
			if (f(v)) {
				newList.add(v);
			}
		});
		return newList;
	}

	function filterNotNull() {
		return filter(@(v) v != null);
	}

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

	function reduce(initial, operation) {
		local accumulator = initial;
		for (local i = 0; i < size; i++) {
			accumulator = operation(accumulator, entity[i]);
		}
		return accumulator;
	}

	function isEmpty() {
		return size == 0;
	}

	function isBlank() {
		local find = true;
		for (local i = 0; i < entity.len(); i++) {
			if (entity[i] != null) {
				find = false;
				break;
			}
		}
		return find;
	}

	function isSameType() {
		local find = true, lastType = null;
		for (local i = 0; i < entity.len(); i++) {
			if (lastType == null) {
				lastType = typeof entity[i];
				continue;
			}

			if (lastType != typeof entity[i]) {
				find = false;
				break;
			}
		}
		return find;
	}

	function getSameType() {
		return isSameType() ? typeof get() : null;
	}

	function any(predicate = null) {
		if (predicate == null) {
			return size > 0;
		}
		for (local i = 0; i < size; i++) {
			if (predicate(entity[i])) {
				return true;
			}
		}
		return false;
	}

	function all(predicate) {
		for (local i = 0; i < size; i++) {
			if (!predicate(entity[i])) {
				return false;
			}
		}
		return true;
	}

	function joinString(string = ", ") {
		local data = "";
		local f = @(i, v) data += i < size - 1 ? v.tostring() + string : v.tostring();
		forEachIndex(f.bindenv(this));
		return data;
	}

	function joinStringFor(string = ", ", f = @(v) v.tostring()) {
		local data = "";
		local f = @(i, v) data += i < size - 1 ? f(v) + string : f(v);
		forEachIndex(f.bindenv(this));
		return data;
	}

	function zip(otherList) {
		if (size != otherList.size) {
			return null;
		}

		local map = Map();
		forEachIndex(@(i, v) map.add(Pair(v, otherList.get(i))));
		return map;
	}

	function flatten() {
		local newList = List();
		forEach(function(v) {
			if (typeof v == List.Type) {
				newList.addAll(v);
			} else if (typeof v == "array") {
				newList.addWithArray(v);
			} else {
				newList.add(v);
			}
		});
		return newList;
	}

	function flatMap(f) {
		local newList = List();
		forEach(function(v) {
			if (typeof v == List.Type) {
				v.forEach(@(b) newList.add(f(b)));
			} else {
				newList.add(f(v));
			}
		});
		return newList;
	}
}