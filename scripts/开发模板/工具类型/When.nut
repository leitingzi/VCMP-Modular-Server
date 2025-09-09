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

local x = 55;
local result = when(x)
	.is(1, function() {
		return "1";
	})
	.is(5, function() {
		return "5";
	})
	.is(10, function() {
		return "10";
	})
	.is(55, function() {
		return "55";
	})
	.otherwise(function() {
		return "?";
	});

print(result);