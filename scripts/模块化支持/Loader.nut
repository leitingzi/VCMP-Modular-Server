// 模块注入

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

	print("移除模块: " + moduleName);
}

function injectModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring(key + " <-" + moduleName + "();");
	script();

	local script = compilestring("moduleArray.append(\"" + moduleName + "\");");
	script();

	print("注入模块: " + moduleName);
}

// 工具函数

function lowerFirst(name) {
	return name.slice(0, 1).tolower() + name.slice(1, name.len());
}

function getFilePath(basePath, fileName, startPath = "", addPath = "/") {
	local pathParts = split(basePath, "/");
	pathParts[pathParts.len() - 1] = fileName;

	local newPath = startPath;
	for (local i = 0; i < pathParts.len(); i++) {
		newPath += pathParts[i];
		if (i + 1 < pathParts.len()) {
			newPath += addPath;
		}
	}
	return newPath;
}

function ReadTextFromFile(path) {
	local f = file(path, "rb"), s = "";
	while (!f.eos()) {
		s += format("%c", f.readn('b'));
	}
	f.close();
	return s;
}

function FileIsExist(path) {
	try {
		local f = file(path, "rb");
		f.close();
	} catch (exception) {
		return false;
	}
	return true;
}

function loadNutFiles(basePath) {
	if (basePath != "模块化支持") {
		local loaderPath = "scripts/" + basePath + "/Loader.nut"
		if (FileIsExist(loaderPath)) {
			dofile(loaderPath);
		}
	}

	basePath = "scripts/" + basePath + "/nutFiles.txt"
	local data = ReadTextFromFile(getFilePath(basePath, "nutFiles.txt"));
	local array = split(data, "\n");

	foreach(value in array) {
		if (strip(value) != "") {
			local path = getFilePath(basePath, strip(value));
			print("加载: " + path);
			try {
				dofile(path);
			} catch (exception) {
				print(exception);
			}
		}
	}
}

// 加载模块中的nut文件

loadNutFiles("开发模板");
loadNutFiles("模块化支持");


// 测试模块

injectModule("A");
print("模块A 是否存在: " + hasModule("A"));

local a = get("A");
a.test()

function test() {

}

moduleEvent(test);

removeModule("A");
print("模块A 是否存在: " + hasModule("A"));