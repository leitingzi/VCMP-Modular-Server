class When {
	value = null;
	found = false;
	result = null;

	constructor(value) {
		this.value = value;
	}

	function is(expected, action) {
		if (!found && value == expected) {
			found = true;
			result = action();
		}
		return this;
	}

	function isNot(expected, action) {
		if (!found && value != expected) {
			found = true;
			result = action();
		}
		return this;
	}

	function inRange(min, max, action) {
		if (!found && value >= min && value <= max) {
			found = true;
			result = action();
		}
		return this;
	}

	function match(condition, action) {
		if (!found && condition(value)) {
			found = true;
			result = action();
		}
		return this;
	}

	function otherwise(action) {
		if (!found) {
			result = action();
		}
		return result;
	}
}

function when(value) {
	return When(value);
}

local x = 65;
local result = when(x)
	.is(100, @() "Max")
	.inRange(0, 35, @() "0~35")
	.inRange(35, 70, @() "35~70")
	.match(@(v) v * 2 > 150 && v < 80, @() "75~80")
	.otherwise(@() ">80");

print(result);

local x = 65;
local result;

switch (true) {
	case (x == 100):
		result = "Max";
		break;
	case (x >= 0 && x <= 35):
		result = "0~35";
		break;
	case (x >= 35 && x <= 70):
		result = "35~70";
		break;
	case (x * 2 > 150 && x < 80):
		result = "75~80";
		break;
	default:
		result = ">80";
		break;
}

print(result);