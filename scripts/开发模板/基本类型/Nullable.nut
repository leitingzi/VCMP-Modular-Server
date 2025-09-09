class Nullable {
	value = null;

	constructor(value) {
		this.value = value;
	}

	function get() {
        return value;
    }

	function safeGet(propertyName) {
		if (value != null) {
			return Nullable(value[propertyName]);
		} else {
			return Nullable(null);
		}
	}

	function safeCall(methodName, ...) {
        if (value != null) {
            local method = value[methodName];
            if (typeof(method) == "function") {
				local arr = [value].extend(vargv);
                return Nullable(method.acall(arr));
            }
        }
        return Nullable(null);
    }
}

function nullable(value) {
    return Nullable(value);
}

local user = nullable({
	name = "Bob",
	address = {
		city = "New York",
		zipCode = "10001"
	},
	getFullName = function() {
		return this.name;
	}
});

local city = user.safeGet("address").safeGet("city").get();
print("City: " + city);

local fullName = user.safeCall("getFullName").get();
print("Full name: " + fullName);