// ģ��ע��

moduleArray <- [];

function getModule(moduleName) {
	local root = getroottable();
	return root[lowerFirst(moduleName)];
}

// ͬgetModule
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

	print("�Ƴ�ģ��: " + moduleName);
}

function injectModule(moduleName) {
	local key = lowerFirst(moduleName);

	local script = compilestring(key + " <-" + moduleName + "();");
	script();

	local script = compilestring("moduleArray.append(\"" + moduleName + "\");");
	script();

	print("ע��ģ��: " + moduleName);
}

// ���ߺ���

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
	if (basePath != "ģ�黯֧��") {
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
			print("����: " + path);
			try {
				dofile(path);
			} catch (exception) {
				print(exception);
			}
		}
	}
}


// ����ģ���б�
local myModule = [
	"����ģ��", "ģ�黯֧��"
];

// ����ģ���е�nut�ļ�
foreach (value in myModule) {
	loadNutFiles(value);
}



// ģ����Դ���

// ע��ģ��
injectModule("A");
print("ģ��A �Ƿ����: " + hasModule("A"));

// ִ��ģ�麯��
local a = get("A"); //��ȡע���ģ��
a.test();

// ����ģ���¼�
function test() {

}
moduleEvent(test);

// �Ƴ�ģ��
removeModule("A");
print("ģ��A �Ƿ����: " + hasModule("A"));