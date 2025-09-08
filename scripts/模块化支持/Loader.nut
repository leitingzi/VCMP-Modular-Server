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

system("nutLoader.bat");

function ReadTextFromFile(path) {
	local f = file(path, "rb"), s = "";
	while (!f.eos()) {
		s += format(@"%c", f.readn('b'));
	}
	f.close();
	return s;
}

local text = ReadTextFromFile("nutFiles.nut");

function stringToArray(string) {
	local array = split(string, "\n");
	return array;
}

println(1);


local array = stringToArray(text);
foreach (value in array) {
	if(strip(value) != "" && value.tolower().find("loader") == null) {
		dofile(strip(value));
	}
}

remove("nutFiles.nut");

injectModule("A");
local a = get("A");
a.test();
