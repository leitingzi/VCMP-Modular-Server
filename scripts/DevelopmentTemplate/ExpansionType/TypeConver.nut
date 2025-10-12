class TypeConver {
	static function Conver(type, data) {
		local v = null;
		switch (type) {
			case "integer":
				v = data.tointeger();
				break;
			case "string":
				v = data;
				break;
			case "float":
				v = data.tofloat();
				break;
			case "bool":
				v = data == "true" ? true : false;
				break;
			case Pos.Type:
				v = Pos.fromSaveString(data);
				break;
			case Euler.Type:
				v = Euler.fromSaveString(data);
				break;
			case Rotation.Type:
				v = Rotation.fromSaveString(data);
				break;
			case Color.Type:
				v = Color.fromSaveString(data);
				break;
			case Range.Type:
				v = Range.fromSaveString(data);
				break;
			case Pair.Type:
				v = Pair.fromSaveString(data);
				break;
			case List.Type:
				v = List.fromSaveString(data);
				break;
		}
		return v;
	}

	static function getSaveString(data) {
		switch (typeof data) {
			case Color.Type:
			case Range.Type:
			case Pos.Type:
			case Euler.Type:
			case Rotation.Type:
			case Pair.Type:
			case List.Type:
				return data.getSaveString();

			default:
				return data.tostring();
		}
	}
}

function splitForValue(string, valueSplit = "_") {
	local arr = split(string, valueSplit);
	local newarr = [];
	for (local i = 0; i < arr.len(); i++) {
		newarr.append(strip(arr[i]));
	}
	return newarr;
}

function getValueAndType(string, typeSplit = ":", valueSplit = "_") {
	local arr = split(string, typeSplit);
	return {
		valueArray = splitForValue(arr[0], valueSplit),
		type = arr[1]
	};
}