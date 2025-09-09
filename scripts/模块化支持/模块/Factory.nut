class Factory {
	moduleName = null;
	constructor(moduleName) {
		this.moduleName = moduleName;
	}

	function _typeof() {
		return "Factory";
	}
}

function injectModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring(key + " <-" + moduleName + "();");
	script();

	local script = compilestring("moduleArray.append(\"" + moduleName + "\");");
	script();

	print("×¢ÈëÄ£¿é: " + moduleName);
}

function getModule(moduleName) {
	local root = getroottable(), e = null;
	if (root.rawin(lowerFirst(moduleName))) {
		e = root.rawget(lowerFirst(moduleName));
	} else if (root.rawin("factory" + moduleName)) {
		e = root.rawget("factory" + moduleName);
	}

	if (e == null) {
		return e;
	}

	if (typeof(e) == "Factory") {
		local script = compilestring("FactoryGet <- function() { return " + moduleName + "() };");
		script();
		return FactoryGet();
	} else {
		return e;
	}
}

function factoryModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring("factory" + moduleName + " <- Factory(\"" + moduleName + "\");");
	script();
}

function lowerFirst(name) {
	return name.slice(0, 1).tolower() + name.slice(1, name.len());
}

class B {
	test = 123;

	function log() {
		print(test);
	}
}

factoryModule("B");

local b1 = getModule("B");
b1.test = 4;

local b2 = getModule("B");
b2.test = 5;

b1.log();
b2.log();

