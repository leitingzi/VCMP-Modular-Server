class Entity extends Any {
	static Type = "Entity";
	index = -1;
	entity = null;
	createInfoIndex = null;
	createInfo = null;
	hideInfo = null;
	hidden = false;

	onInit = null;
	onCreate = null;
	onDestory = null;
	onDestoryOnly = null;
	onHide = null;
	onShow = null;
	onReBuild = null;
	onCopy = null;

	constructor() {
		index = getArrayNullIndex(entityArray);
		if (index != -1) {
			entityArray[index] = this;
			onInit();
		}
	}

	static function Find(id, type) {
		for (local i = 0; i < entityArray.len(); i++) {
			if (entityArray[i] == null) {
				continue;
			}

			if (entityArray[i].Type != type || entityArray[i].entity == null) {
				continue;
			}

			if (entityArray[i].Type != MarkerClass.Type) {
				if (entityArray[i].entity.ID != id) {
					continue;
				}
			} else {
				if (entityArray[i].entity != id) {
					continue;
				}
			}
			return entityArray[i];
		}

		return -1;
	}

	static function Event(id, type, eventName, ...) {
		local e = Find(id, type);
		if (e != -1) {
			local arr = [e];
			for (local i = 0; i < vargv.len(); i++) {
				arr.append(vargv[i]);
			}
			return e[eventName].acall(arr);
		}
	}

	static function Function(id, type, key, ...) {
		local e = Find(id, type);
		if (e != -1) {
			local arr = [e, key];
			for (local i = 0; i < vargv.len(); i++) {
				arr.append(vargv[i]);
			}
			return e.doFunction.acall(arr);
		}
	}

	function doFunc(key, ...) {
		return doFunction(key, vargv);
	}

	function doFunction(key, ...) {
		local info = getInfo();
		if (info == null) {
			return null;
		}

		if (!info.rawin(key)) {
			return;
		}

		local val = info.rawget(key);
		switch (val.type) {
			case "w":
				if (vargv.len() > 0) {
					return val.set(vargv[0]);
				}
				return val.get;

			case "r":
				return val.get;
			case "e":
				local arr = [entity];
				for (local i = 0; i < vargv.len(); i++) {
					arr.append(vargv[i]);
				}
				return val.get.acall(arr);
		}
	}

	function allFunctions() {
		local info = getInfo();
		if (info == null) {
			return null;
		}
		local data = {
			w = [],
			r = [],
			e = []
		};
		foreach(i, value in info) {
			data[value.type].append(i);
		}
		return data;
	}

	function create() {

	}

	function createEx(e) {
		if (type == MarkerClass.type) {
			return null;
		}

		entity = e;
		createInfo = createTableInfo();

		onCreate();
		return this;
	}

	function createTableInfo() {

	}

	function createFromInfo(table) {
		if (table != null) {
			local array = create.getinfos().parameters;
			local arr = [this];
			for (local i = 1; i < array.len(); i++) {
				arr.append(table[array[i]]);
			}
			create.acall(arr);
		}
	}

	function destory() {
		destoryOnly();

		createInfoIndex = null;
		createInfo = null;
		hideInfo = null;
		hidden = false;

		entityArray[index] = null;
		index = -1;

		onDestory();
	}

	function destoryOnly() {
		try {
			entity.Delete();
		} catch (exception) {

		}
		try {
			entity.Remove();
		} catch (exception) {

		}
		entity = null;

		onDestoryOnly();
	}

	function hide() {
		hideInfo = createTableInfo();

		destoryOnly();
		hidden = true;

		onHide();
	}

	function show() {
		if (hidden) {
			createFromInfo(hideInfo);
			hidden = false;

			onShow();
		}
	}

	function reBuild(info = null) {
		if (info == null) {
			info = createTableInfo();
		}
		destoryOnly();
		createFromInfo(info);
		onReBuild();
		return this;
	}

	function copy() {

		onCopy();

		switch (type) {
			case VehicleClass.Type:
				return VehicleClass().createEx(this.entity);
			case PickupClass.Type:
				return PickupClass().createEx(this.entity);
			case ObjectClass.Type:
				return ObjectClass().createEx(this.entity);
			case CheckpointClass.Type:
				return CheckpointClass().createEx(this.entity);
			case MarkerClass.Type:
				local marker = MarkerClass();
				marker.createFromInfo(this.createTableInfo());
				return marker;
		}
	}

	function _tostring() {
		return exportCode(false);
	}

	function exportCode(isNow = true) {
		local table = createInfo;
		if (isNow) {
			table = createTableInfo();
		}

		local data = "";
		for (local i = 0; i < createInfoIndex.len(); i++) {
			local a = createInfoIndex[i];
			// data += a + " = " + table[a];
			data += table[a];
			if (i != createInfoIndex.len() - 1) {
				data += ", ";
			}
		}
		return Type + "(" + data + ")";
	}

	function getInfo() {

	}

	function getNearTable() {
		if (this.entity == null) {
			return null;
		}

		local table = {
			"Pickup": []
			"Object": []
			"Checkpoint": []
			"Vehicle": []
			"Marker": []
		}

		for (local i = 0; i < entityArray.len(); i++) {
			local e = entityArray[i];
			if (e == null || e.entity == null) {
				continue;
			}

			if (e.index == this.index) {
				continue;
			}

			local dis = 0;
			if (this.Type != "Marker") {
				if (e.Type != "Marker") {
					dis = Pos.Dist2D(e.entity.Pos, this.entity.Pos);
				} else {
					dis = e.Pos.distanceTo(this.entity.Pos);
				}
			} else {
				if (e.Type != "Marker") {
					dis = Pos.Dist2D(e.entity.Pos, this.entity.Pos);
				} else {
					dis = e.Pos.distanceTo(this.Pos);
				}
			}

			local arr = table.rawget(e.Type);
			arr.append({
				entityClass = e,
				dis = dis
			});
		}

		local sortFunc = function(a, b) {
			if (a.dis > b.dis) return 1;
			else if (a.dis < b.dis) return -1;
			return 0;
		}

		foreach(i, value in table) {
			value.sort(sortFunc);
		}
		return table;
	}

	function onInit() {

	}

	function onCreate() {

	}

	function onDestory() {

	}

	function onDestoryOnly() {

	}

	function onHide() {

	}

	function onShow() {

	}

	function onReBuild() {

	}

	function onCopy() {

	}

	function getId() {
        return entity ? (Type == MarkerClass.Type ? entity : entity.ID) : null;
    }

	function isValid() {
        return index != -1 && entity != null;
    }
}