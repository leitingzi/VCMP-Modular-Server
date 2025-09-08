function getModule(moduleName) {
	local root = getroottable();
	return root[lowerFirst(moduleName)];
}

function get(moduleName) {
	return getModule(moduleName);
}

function hasModule(moduleName) {
	local root = getroottable();
	return root.rawin(lowerFirst(moduleName))
}

function removeModule(moduleName) {
	local key = lowerFirst(moduleName);
	local script = compilestring("delete " + key + ";");
	script();

	println("ÒÆ³ýÄ£¿é: " + moduleName);
}

function injectModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring(key + " <-" + moduleName + "();");
	script();

	println("×¢ÈëÄ£¿é: " + moduleName);
}

function lowerFirst(name) {
	return name.slice(0, 1).tolower() + name.slice(1, name.len());
}

function println(msg) {
	print(msg + "\n");
}