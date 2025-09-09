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