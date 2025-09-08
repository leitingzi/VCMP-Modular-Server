
// ģ��ע��

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
		s += format(@"%c", f.readn('b'));
	}
	f.close();
	return s;
}

function loadNutFiles(basePath) {
	local a = split(basePath, "/");
	if(a.len() <= 2) {
		basePath = basePath += "/nutFiles.nut";
	}

	local readPath = getFilePath(basePath, "nutFiles.nut");
	local text = ReadTextFromFile(readPath);
	local array = split(text, "\n");

	foreach(value in array) {
		if (strip(value) != "" && value.tolower().find("loader") == null) {
			local path = getFilePath(basePath, strip(value));
			print("����: " + path);
			dofile(path);
		}
	}
}

// ���س���Loader.nut ��������nut�ļ�

loadNutFiles(__FILE__); //ģ�黯֧��
loadNutFiles("scripts/����ģ��");

print("");


// ����ģ��

injectModule("A");
print("ģ��A �Ƿ����: " + hasModule("A"));

local a = get("A");
a.test()

function test() {

}

moduleEvent(test);

removeModule("A");
print("ģ��A �Ƿ����: " + hasModule("A"));