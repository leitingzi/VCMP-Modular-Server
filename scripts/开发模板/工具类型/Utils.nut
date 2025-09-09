function repeat(t, f) {
	for (local i = 0; i < t; i++) {
		f();
	}
}

function getArrayNullIndex(array) {
	for (local i = 0; i < array.len(); i++) {
		if (array[i] == null) {
			return i;
		}
	}
	return -1;
}

function with(e, f) {
	f.acall([e]);
	return e;
}