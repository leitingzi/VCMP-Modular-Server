class Range extends Any {
	static Type = "Range";
	value1 = null;
	value2 = null;

	constructor(value1, value2) {
		if ((typeof value1 == "integer" || typeof value1 == "float") && (typeof value2 == "integer" || typeof value2 == "float")) {
			this.value1 = value1;
			this.value2 = value2;
		} else {
			throw Type + "�Ĳ��������������򸡵���";
		}
	}

	static function WithIn(i, v1, v2) {
		return i >= v1 && i <= v2;
	}

	static function CoerceIn(i, v1, v2) {
		if (i < v1) {
			return v1;
		} else if (i > v2) {
			return v2;
		} else {
			return i;
		}
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

	function len() {
		return value2 - value1;
	}

	function shift(amount) {
		return Range(value1 + amount, value2 + amount);
	}

	function scale(factor, center = null) {
		local c = center || (this.value1 + this.value2) / 2;
		local newStart = c - (c - this.value1) * factor;
		local newEnd = c + (this.value2 - c) * factor;
		return Range(newStart, newEnd);
	}

	// ����������
	function forEach(count, f) {
		local d = len().tofloat() / count.tofloat();
		for (local i = 0; i < count; i++) {
			f(d * (i + 1) + value1);
		}
	}

	function splitArray(count) {
		local arr = [];
		forEach(count, function(v) {
			arr.append(v);
		});
		return arr;
	}

	// ��鵱ǰ��Χ�Ƿ���ȫ������һ����Χ
	function containsRange(other) {
		return value1 <= other.value1 && value2 >= other.value2;
	}

	// ���������Χ�Ƿ����ص�
	function overlapsWith(other) {
		return !(value2 < other.value1 || value1 > other.value2);
	}

	// ��������һ����Χ�Ľ���
	function intersection(other) {
		if (!overlapsWith(other)) {
			return null;
		}
		local newStart = max(value1, other.value1);
		local newEnd = min(value2, other.value2);
		return Range(newStart, newEnd);
	}

	// ��������һ����Χ�ĺϲ�������ص���
    function union(other) {
        if (!overlapsWith(other)) {
			return null;
		}
        local newStart = min(value1, other.value1);
        local newEnd = max(value2, other.value2);
        return Range(newStart, newEnd);
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

local a = Range(2, 5);
local b = Range(4, 7);
print(a.union(b));