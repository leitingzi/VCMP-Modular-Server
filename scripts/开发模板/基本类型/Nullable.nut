class Nullable {
	value = null;

	constructor(value = null) {
		this.value = value;
	}

	function _get(key) {
		return::NullableSafeGet(this, key);
	}

	function _call(...) {
		local arr = [::getroottable(), this].extend(vargv);
		return::NullableSafeCall.acall(arr);
	}

	function get() {
		return value;
	}

	function safeGet(propertyName) {
		if (value != null) {
			return::Nullable(value[propertyName]);
		} else {
			return::Nullable(null);
		}
	}

	function safeCall(methodName, ...) {
		if (value != null) {
			local method = value[methodName];
			if (typeof(method) == "function") {
				local arr = [value].extend(vargv);
				return::Nullable(method.acall(arr));
			}
		}
		return::Nullable(null);
	}

	function _tostring() {
		return "Nullable(" + value + ")";
	}
}

function NullableSafeGet(obj, key) {
	if (obj.value != null) {
		return Nullable(obj.value[key]);
	} else {
		return Nullable(obj.value);
	}
}

function NullableSafeCall(...) {
	local f = vargv[0].get();
	if (f == null) {
		return Nullable(f);
	} else {
		local v = f.acall(vargv.slice(1, vargv.len()));
		return Nullable(v.value);
	}
}

function dump(var, indent = 0) {
	if (indent == 0) {
		println(typeof(var) + " " +
			var);
		try {
			dump(var, indent + 1);
		} catch (exception) {

		}
	} else {
		foreach(idx, value in
			var) {
			local isindexable = function(v) {
				try {
					if (typeof v == "string") {
						return false;
					}

					v.len();
					return true;
				} catch (e) {
					return false;
				}
			}

			local indents = "";
			for (local i = 0; i < indent; ++i) indents += "\t";
			println(indents + idx + ":\t" + typeof value + "\t" + value);
			if (isindexable(value)) dump(value, indent + 1);
		}
	}
}

function println(msg) {
	print(msg + "\n");
}

function nullable(value) {
	return Nullable(value);
}

local user = nullable({
	address = {
		city = {
			name = {
				x = "x",
				y = "y"
			}
		}
	}
});

local x = user.address.city.name.x.get();
print(x)