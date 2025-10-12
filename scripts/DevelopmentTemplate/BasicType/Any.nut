class Any {
	static Type = "Any";

	function run(f) {
		f.bindenv(this);
		f();
	}

	function let(f) {
		f(this);
	}

	function apply(f) {
		run(f);
		return this;
	}

	function also(f) {
		f(this);
		return this;
	}

	function applyIf(bool, f) {
		if(bool) {
			run(f);
		}
		return this;
	}

	function takeIf(f) {
		return f(this) ? this : null;
	}

	function safeCall(f) {
        return this != null ? f(this) : null;
    }

	function log(f = print) {
		f(this.tostring());
	}

	function _typeof() {
		return Type;
	}
}