class Nullable {
	value = null;

	constructor(value = null) {
		this.value = value;
	}

	function _get(key) {
		return::NullableSafeGet(this, key);
	}

	function _call(...) {
		local arr = [::getroottable(), this];
		arr.extend(vargv);
		return::NullableSafeCall.acall(arr);
	}

	function get() {
		return value;
	}

	static function CheckValue(value) {
		return ::Nullable(value);
		// local vtype = typeof(value);
		// if (vtype == "integer" || vtype == "string" || vtype == "float" || vtype == "bool") {
		// 	return value;
		// } else {
		// 	return::Nullable(value);
		// }
	}

	function safeGet(propertyName) {
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
				local arr = [value];
				arr.extend(vargv);
				local value = method.acall(arr);
				return CheckValue(value);
			}
		}
		return::Nullable(null);
	}

	function _tostring() {
		return "Nullable(" + (value == null ? "null" : value) + ")";
	}

	function isNull() {
        return value == null;
    }

	function isNotNull() {
        return value != null;
    }

	// 如果值为空则返回默认值，否则返回当前值
    function orElse(defaultValue) {
        if (isNull()) {
            return defaultValue;
        }
        return value;
    }

	// 如果值为空则返回另一个Nullable，否则返回当前实例
    function or(otherNullable) {
        if (isNull()) {
            return otherNullable;
        }
        return this;
    }

	// 如果值不为空则应用映射函数，否则返回空的Nullable
    function map(mapper) {
        if (isNotNull()) {
            return Nullable(mapper(value));
        }
        return Nullable(null);
    }

	// 如果值不为空则应用映射函数（返回Nullable），否则返回空的Nullable
    function flatMap(mapper) {
        if (isNotNull()) {
            local result = mapper(value);
            return result instanceof "Nullable" ? result : Nullable(result);
        }
        return Nullable(null);
    }

	// 如果值不为空且满足条件则返回当前实例，否则返回空
    function filter(predicate) {
        if (isNotNull() && predicate(value)) {
            return this;
        }
        return Nullable(null);
    }

	// 如果值不为空则执行消费者函数，返回当前实例
    function ifPresent(consumer) {
        if (isNotNull()) {
            consumer(value);
        }
        return this;
    }

	// 如果值为空则执行 Runnable，返回当前实例
	function ifNull(runnable) {
        if (isNull()) {
            runnable();
        }
        return this;
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

function nullable(value = null) {
	return Nullable(value);
}

local user = nullable({
	address = {
		city = {
			name = {
				x = "x123"
			},
			getNameX = function() {
				return {
					x = "123",
					y = {
						y2 = "y2123"
					}
				};
			}
		}
	}
});

local x = user.safeGet("address").safeGet("city").safeGet("name").safeGet("x");
print(x);

local x = user.address.city.safeCall("getNameX").safeGet("y").safeGet("y2");
print(x);

local x = user.address.city.name.x.ifPresent(print);
print(x);

local x = user.address.city.getNameX().y.y2;
print(x);

local user = nullable({
	address = null
});

local x = user.safeGet("address").safeGet("city").safeGet("name").safeGet("x");
print(x);

local x = user.address.city.safeCall("getNameX").safeGet("y").safeGet("y2");
print(x);

local x = user.address.city.name.x;
print(x);

local x = user.address.city.getNameX().y.y2;
print(x);