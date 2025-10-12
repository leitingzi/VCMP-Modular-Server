
class Log {
	function printTitle(color, title) {
		::hprint(color + cBOLD, "[" + title + "] ");
	}

	static function Null() {
		::hprint(cWHITE + cBOLD, "\n");
	}

	static function e(msg, title = "错误") {
		printTitle(cRED, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function w(msg, title = "警告") {
		printTitle(cYELLOW, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function i(msg, title = "信息") {
		printTitle(cBLUE, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function s(msg, title = "成功") {
		printTitle(cGREEN, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function t(msg, title = "调试") {
		printTitle(cMAGENTA, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function r(msg, title = "记录") {
		printTitle(cWHITE, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function a(msg, title = "操作") {
		printTitle(cCYAN, "操作");
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function message(msg) {
		::hprint(cWHITE + cBOLD, msg + "\n");
	}

	static function messageEx(...) {
		if (vargv.len() > 0) {
			local data = "";
			for (local i = 0; i < vargv.len(); i++) {
				data += i == 0 ? vargv[i] + "" : ", " + vargv[i];
			}
			message(data);
		}
	}

	static function saveInFile(msg) {
		local fileName = "服务器日志.txt";
		local d = Date();
		FileUtil.addLine(fileName, "[" + d.getCurrentTime() + "] -> " + msg);
	}
}

function Log::Print(msg) {
	hprint(cCYAN + cBOLD, "[脚本] ");
	hprint(cWHITE + cBOLD, msg + "\n");
	Log.saveInFile("[脚本] " + msg);
}
print <- Log.Print;