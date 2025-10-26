class Container extends Any {
	container = null;

	constructor(...) {
		container = vargv.len() > 0 ? vargv : [];
	}

	function forEach(func = print) {
		for (local i = 0; i < container.len(); i++) {
			func(container[i]);
		}
	}

	function forEachIndex(
		func = @(index, eneity) print("index: " + index + " entity: " + entity)
	) {
		for (local i = 0; i < container.len(); i++) {
			func(i, container[i]);
		}
	}

	function map(func) {
		return container.map(func);
	}

	function clear() {
		container.clear();
	}
}

local c = Container(1, 2, 3);
c.map(@(v) v + 1);
c.forEach();