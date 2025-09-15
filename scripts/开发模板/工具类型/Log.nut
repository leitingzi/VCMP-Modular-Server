
class Log {
	function printTitle(color, title) {
		::hprint(color + cBOLD, "[" + title + "] ");
	}

	static function Null() {
		::hprint(cWHITE + cBOLD, "\n");
	}

	static function e(msg, title = "����") {
		printTitle(cRED, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function w(msg, title = "����") {
		printTitle(cYELLOW, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function i(msg, title = "��Ϣ") {
		printTitle(cBLUE, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function s(msg, title = "�ɹ�") {
		printTitle(cGREEN, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function t(msg, title = "����") {
		printTitle(cMAGENTA, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function r(msg, title = "��¼") {
		printTitle(cWHITE, title);
		message(msg);

		saveInFile("[" + title + "] " + msg);
	}

	static function a(msg, title = "����") {
		printTitle(cCYAN, "����");
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
		local fileName = "��������־.txt";
		local d = Date();
		FileUtil.addLine(fileName, "[" + d.getCurrentTime() + "] -> " + msg);
	}
}

function Log::Print(msg) {
	hprint(cCYAN + cBOLD, "[�ű�] ");
	hprint(cWHITE + cBOLD, msg + "\n");
	Log.saveInFile("[�ű�] " + msg);
}
print <- Log.Print;