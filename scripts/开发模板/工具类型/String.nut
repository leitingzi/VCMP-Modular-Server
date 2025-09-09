function getTextBetween(text, begin_str, end_str, must_end = true) {
	local start_idx = text.find(begin_str, 0);
	if (start_idx == null) {
		return null;
	}

	start_idx += begin_str.len();
	local a = start_idx;
	if (must_end) {
		local find = true;
		do {
			local i = text.find(end_str, a);
			if (i != null) {
				a += end_str.len();
				find = true;
			} else {
				find = false;
			}
		} while (find)
	}

	local end_idx = a - end_str.len();

	// if `start_idx` is `null` then it wasn't found
	if (end_idx == null) {
		// If the end string must be present
		if (must_end) {
			return null; // Then return null
			// If the end string doesn't have to be present
		} else {
			// Return everything after `begin_str` (excluding `begin_str`)
			return text.slice(start_idx);
		}
	}
	// We have a beginning and an ending, so get that slice of text
	return text.slice(start_idx, end_idx);
}

