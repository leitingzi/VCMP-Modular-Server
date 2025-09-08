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