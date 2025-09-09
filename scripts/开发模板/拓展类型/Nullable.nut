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

	static function CheckValue(value) {
		local vtype = typeof(value);
		if (vtype == "integer" || vtype == "string" || vtype == "float" || vtype == "bool") {
			return value;
		} else {
			return::Nullable(value);
		}
	}

	function safeGet(propertyName) {
		::println(propertyName);
		if (value != null) {
			local value = value[propertyName];
			return CheckValue(value);
		} else {
			return::Nullable(null);
		}
	}

	function safeCall(methodName, ...) {
		if (value != null) {
			local method = value[methodName];
			if (typeof(method) == "function") {
				local arr = [value].extend(vargv);
				local value = method.acall(arr);
				return CheckValue(value);
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
		local value = obj.value[key];
		return Nullable.CheckValue(value);
	} else {
		return Nullable(null);
	}
}

function NullableSafeCall(...) {
	local f = vargv[0].get();
	if (f != null) {
		local value = f.acall(vargv.slice(1, vargv.len()));
		return Nullable.CheckValue(value);
	} else {
		return Nullable(null);
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

function nullable(value = null) {
	return Nullable(value);
}

// local user = nullable({
// 	address = {
// 		city = {
// 			name = {
// 				x = "x123"
// 			},
// 			getNameX = function() {
// 				return {
// 					x = "123",
// 					y = {
// 						y2 = "y2123"
// 					}
// 				};
// 			}
// 		}
// 	}
// });

// local x = user.safeGet("address").safeGet("city").safeGet("name").safeGet("x");
// println(x);

// local x = user.address.city.safeCall("getNameX").safeGet("y").safeGet("y2");
// println(x);

// local x = user.address.city.name.x;
// println(x);

// local x = user.address.city.getNameX().y;
// println(x);

local user = nullable({
	address = null
});

local x = user.safeGet("address").safeGet("city").safeGet("name").safeGet("x");
println(x);

local x = user.address.city.safeCall("getNameX").safeGet("y").safeGet("y2");
println(x);

local x = user.address.city.name.x;
println(x);

local x = user.address.city.getNameX().y.y2;
println(x);