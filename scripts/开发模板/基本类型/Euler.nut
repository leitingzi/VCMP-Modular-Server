class Euler extends Any {
	static Type = "Euler";
	x = 0;
	y = 0;
	z = 0;

	constructor(x = 0, y = 0, z = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	function toVector() {
		return Vector(x, y, z);
	}

	function toRotation() {
		local roll = x;
		local pitch = y;
		local yaw = z;

		local cr = cos(roll * 0.5);
		local sr = sin(roll * 0.5);
		local cp = cos(pitch * 0.5);
		local sp = sin(pitch * 0.5);
		local cy = cos(yaw * 0.5);
		local sy = sin(yaw * 0.5);

		local w = cr * cp * cy + sr * sp * sy;
		local x = sr * cp * cy - cr * sp * sy;
		local y = cr * sp * cy + sr * cp * sy;
		local z = cr * cp * sy - sr * sp * cy;

		return Rotation(x, y, z, w);
	}

	function _tostring() {
		return Type + "(" + x + ", " + y + ", " + z + ")";
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string);
		if (e.type == Type) {
			local x = e.valueArray[0].tofloat();
			local y = e.valueArray[1].tofloat();
			local z = e.valueArray[2].tofloat();
			return Euler(x, y, z);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return x + "_" + y + "_" + z + ":" + Type;
	}
}