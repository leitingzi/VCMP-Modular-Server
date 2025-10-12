
class Log {
	function printTitle(color, title) {
		::hprint(color + cBOLD, "[" + title + "] ");
	}

	static function Null() {
		::hprint(cWHITE + cBOLD, "\n");
	}

	static function e(msg, title = "Error") {
		printTitle(cRED, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function w(msg, title = "Warning") {
		printTitle(cYELLOW, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function i(msg, title = "Info") {
		printTitle(cBLUE, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function s(msg, title = "Success") {
		printTitle(cGREEN, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function t(msg, title = "Debug") {
		printTitle(cMAGENTA, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function r(msg, title = "Record") {
		printTitle(cWHITE, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function a(msg, title = "Operation") {
		printTitle(cCYAN, title);
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
		local fileName = "ServerLog.txt";
		local d = Date();
		File.addLine(fileName, "[" + d.getCurrentTime() + "] -> " + msg);
	}
}