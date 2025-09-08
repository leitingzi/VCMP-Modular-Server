moduleArray <- [];

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

	local index = moduleArray.find(moduleName);
	if (index != null) {
		moduleArray.remove(index);
	}

	print("ÒÆ³ýÄ£¿é: " + moduleName);
}

function injectModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring(key + " <-" + moduleName + "();");
	script();

	local script = compilestring("moduleArray.append(\"" + moduleName + "\");");
	script();

	print("×¢ÈëÄ£¿é: " + moduleName);
}

function lowerFirst(name) {
	return name.slice(0, 1).tolower() + name.slice(1, name.len());
}

class EventModule {
	function onScriptLoad() {}
	function onScriptUnload() {}
	function onServerStart() {}
	function onServerStop() {}

	function onPlayerJoin(player) {}
	function onPlayerPart(player, reason) {}
	function onPlayerRequestClass(player, classID, team, skin) {}
	function onPlayerRequestSpawn(player) {}
	function onPlayerSpawn(player) {}
	function onPlayerDeath(player, reason) {}
	function onPlayerKill(player, killer, reason, bodypart) {}
	function onPlayerChat(player, text) {}
	function onPlayerCommand(player, cmd, text) {}
}

function moduleEvent(func, ...) {
	local funcInfo = func.getinfos();
	local funcName = funcInfo.name;
	local returnDefaultValue = true;
	local returnValue = returnDefaultValue;

	for (local i = 0; i < moduleArray.len(); i++) {
		local module = moduleArray[i];
		local moduleClass = get(module);

		if (moduleClass.rawin(funcName)) {
			local moduleFuncInfo = moduleClass[funcName].getinfos();
			local parameters = moduleFuncInfo.parameters;
			local defparams = moduleFuncInfo.defparams;

			local varr = [moduleClass];
			for (local i = 0; i < vargv.len(); i++) {
				varr.append(vargv[i]);
			}

			if (vargv.len() < parameters.len()) {
				local len = parameters.len() - vargv.len();
				for (local i = len; i < defparams.len(); i++) {
					varr.append(defparams[i]);
				}
			}

			returnValue = moduleClass[funcName].acall(varr);
			if (returnValue == null) {
				returnValue = returnDefaultValue;
			}
		}
		break;
	}

	return returnValue;
}

print(__FILE__);

local data = split(__FILE__, "/");
data[data.len() - 1] = "nutLoader.bat";
local newData = @".\";
for (local i = 0; i < data.len(); i++) {
	newData += data[i]
	if(i + 1 < data.len()) {
		newData += @"\";
	}
}

system(newData);

function ReadTextFromFile(path) {
	local f = file(path, "rb"), s = "";
	while (!f.eos()) {
		s += format(@"%c", f.readn('b'));
	}
	f.close();
	return s;
}

local data = split(__FILE__, "/");
data[data.len() - 1] = "nutFiles.nut";
local newData = "";
for (local i = 0; i < data.len(); i++) {
	newData += data[i]
	if(i + 1 < data.len()) {
		newData += "/";
	}
}

local text = ReadTextFromFile(newData);

print(text);

function stringToArray(string) {
	local array = split(string, "\n");
	return array;
}

local array = stringToArray(text);
foreach(value in array) {
	if (strip(value) != "" && value.tolower().find("loader") == null) {

		local data = split(__FILE__, "/");
		data[data.len() - 1] = strip(value);
		local newData = "";
		for (local i = 0; i < data.len(); i++) {
			newData += data[i]
			if(i + 1 < data.len()) {
				newData += "/";
			}
		}

		dofile(newData);
	}
}

// remove("nutFiles.nut");

injectModule("A");
local a = get("A");
print(moduleArray[0]);
print(moduleArray.len());


function test() {

}

moduleEvent(test);

removeModule("A");
print(moduleArray.len());

function ClientInputReturn(editbox, text) {

}