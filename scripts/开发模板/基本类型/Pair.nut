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
			local value = TypeConversion.Conver(valueType, e.valueArray[0]);
			return Pair(key, value);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return TypeConversion.getSaveString(value) + "*" + key + "*" + typeof value + "&" + Type;
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