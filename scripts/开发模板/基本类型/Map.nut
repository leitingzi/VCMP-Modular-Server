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

	static function fromSaveString(string, f = @(v) v) {
		local arr = split(string, "&"), map = Map();
		foreach (v in arr) {
			local pair = Pair.fromSaveString(v, f);
			map.add(pair);
		}
		return map;
	}

	function getSaveString(f = @(v) v) {
		local data = "";
		forEach(@(pair) data += pair.getSaveString(f) + "&");
		return data;
	}

	function _tostring() {
		return list.tostring();
	}
}