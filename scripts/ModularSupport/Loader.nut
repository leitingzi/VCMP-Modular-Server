// 模块注入

moduleArray <- [];

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

// 同getModule
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

	print("Remove Module: " + moduleName);
}

function injectModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring(key + " <-" + moduleName + "();");
	script();

	local script = compilestring("moduleArray.append(\"" + moduleName + "\");");
	script();

	print("Inject Module: " + moduleName);
}

function factoryModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring("factory" + moduleName + " <- Factory(\"" + moduleName + "\");");
	script();
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
	if (basePath != "ModularSupport") {
		local loaderPath = "scripts/" + basePath + "/Loader.nut"
		if (FileIsExist(loaderPath)) {
			dofile(loaderPath);
		}
	}

	basePath = "scripts/" + basePath + "/nutFiles.txt"
	local filePath = getFilePath(basePath, "nutFiles.txt")
	local data = ReadTextFromFile(filePath);
	local array = split(data, "\n");

	local errorPath = [];

	foreach(value in array) {
		if (strip(value) != "") {
			local path = getFilePath(basePath, strip(value));
			print("Load Module: " + path);
			try {
				dofile(path);
			} catch (exception) {
				errorPath.append(path);
				print(exception);
			}
		}
	}

	local errorPath2 = [];

	// 首次加载失败的文件 会重新加载
	foreach(value in errorPath) {
		try {
			print("Reload Module: " + value);
			dofile(value);
		} catch (exception) {
			errorPath2.append(value);
			print(exception);
		}
	}

	if(errorPath2.len() > 0) {
		print("Load Failed: ")
		foreach (value in errorPath2) {
			print(value);
		}
	}
}


// 定义模块列表
local myModule = [
	"DevelopmentTemplate", "ModularSupport"
];

// 加载模块中的nut文件，加载中首次报错是正常现象
foreach(value in myModule) {
	loadNutFiles(value);
}

local injectSingles = [
	"ConsoleInput",
]

foreach(value in injectSingles) {
	injectModule(value);
}

// 模块测试代码

// 注入模块
injectModule("A");
print("Module A is Exist: " + hasModule("A"));

// 执行模块函数
local a = get("A"); //获取注入的模块
a.test();

// 测试模块事件
function test() {

}
moduleEvent(test);

// 移除模块
removeModule("A");
print("Module A is Exist: " + hasModule("A"));


class B {
	test = 123;

	function log() {
		print(test);
	}
}

// 注入模块
factoryModule("B");

local b1 = get("B");
b1.test = 4;

local b2 = get("B");
b2.test = 5;

b1.log();
b2.log();


class C {
	test = 123;

	function log() {
		print(test);
	}
}
injectModule("C");

local c1 = get("C");
c1.test = 100;
c1.log();

local c2 = get("C");
c2.log();