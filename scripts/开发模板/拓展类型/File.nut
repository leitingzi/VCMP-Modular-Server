class File {
	static function read(path) {
		local f = file(path, "rb"), s = "";
		while (!f.eos()) {
			s += format(@"%c", f.readn('b'));
		}
		f.close();
		return s;
	}

	static function write(path, text) {
		local f = file(path, "rb+"), s = "";
		f.seek(0, 'e');
		foreach (c in text) {
			f.writen(c, 'b');
		}
		f.close();
	}

	static function addLine(path, text) {
		local f = file(path, "a+");
		foreach(char in text) {
			f.writen(char, 'c');
		}
		f.writen('\n', 'c');
		f.close();
	}

	static function create(path) {
		local f = file(path, "a+");
		f.close();
	}

	static function isExist(path, needCreate = false) {
		try {
			local f = file(path, "rb");
			f.close();
		} catch (exception) {
			if(needCreate) {
				create(path);
			}
			return false;
		}
		return true;
	}
}

