function dump(var, indent = 0) {
	if (indent == 0) {
		print(typeof
			var +" " +
			var);
		try {
			dump(var, indent + 1);
		} catch (exception) {

		}
	} else {
		foreach(idx, value in
			var) {
			local isindexable = function(v) {
				try {
					if (typeof v == "string") {
						return false;
					}

					v.len();
					return true;
				} catch (e) {
					return false;
				}
			}

			local indents = "";
			for (local i = 0; i < indent; ++i) indents += "\t";
			print(indents + idx + ":\t" + typeof value + "\t" + value);
			if (isindexable(value)) dump(value, indent + 1);
		}
	}
}