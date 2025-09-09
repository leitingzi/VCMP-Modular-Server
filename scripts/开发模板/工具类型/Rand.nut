class Rand {
	INT32_MAX = 0x7FFFFFFF;
	INT32_MIN = 0x80000000;
	FLOAT32_MAX = 0x7FFFFFFF.tofloat();
	FLOAT32_MIN = 0x80000000.tofloat();

	static function Next(max) {
		return inRange(0, max);
	}

	static function inRange(min, max) {
		local m = min.tofloat(), n = max.tofloat();
		local r = (n - m) * ((rand() % 0x7FFF).tofloat() / (RAND_MAX).tofloat()) + m;
		if (typeof min == "float" || typeof max == "float") {
			return r;
		} else {
			return intRange(min, max);
		}
	}

	static function inRanger(range) {
		local min = range.value1, max = range.value2;
		return inRange(min, max);
	}

	static function intRange(min, max) {
		return rand() % (max - min + 1) + min;
	}
}