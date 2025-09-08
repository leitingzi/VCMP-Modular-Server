class Pos extends Any {
	static Type = "Pos";
	x = 0;
	y = 0;
	z = 0;

	static function fromSaveString(string) {
		local e = getValueAndType(string);
		if (e.type == Type) {
			local x = e.valueArray[0].tofloat();
			local y = e.valueArray[1].tofloat();
			local z = e.valueArray[2].tofloat();
			return Pos(x, y, z);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return x + "_" + y + "_" + z + ":" + Type;
	}

	static function fromString(string) {
		local a = getTextBetween(string, "(", ")");
		if (a == null) {
			return false;
		}
		local b = split(a, ",");
		if (b.len() <= 1) {
			return false;
		}
		return Pos(b[0].tofloat(), b[1].tofloat(), b[2].tofloat());
	}

	static function fromVector(vector) {
		return Pos(vector.x, vector.y, vector.z);
	}

	static function Dist2D(vector1, vector2) {
		local dx = vector1.x - vector2.x;
		local dy = vector1.y - vector2.y;
		local dz = vector1.z - vector2.z;
		return sqrt(dx * dx + dy * dy + dz * dz);
	}

	constructor(x = 0, y = 0, z = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	function dot(other) {
		return x * other.x + y * other.y + z * other.z;
	}

	function cross(other) {
		return Pos(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);
	}

	function angleCos(other) {
		return dot(other) / (getMagnitude() * other.getMagnitude());
	}

	function getMagnitude() {
		return sqrt(x * x + y * y + z * z);
	}

	function normalize() {
		local a = getMagnitude();
		if (a > 0) {
			return Pos(x / a, y / a, z / a);
		}
		return null;
	}

	function equal(other) {
		local a = getMagnitude();
		local b = other.getMagnitude();
		return a == b;
	}

	function distanceTo(other) {
		local dx = x - other.x;
		local dy = y - other.y;
		local dz = z - other.z;
		return sqrt(dx * dx + dy * dy + dz * dz);
	}

	function midpoint(other) {
		return Pos((x + other.x) / 2, (y + other.y) / 2, (z + other.z) / 2);
	}

	function lerp(other, t) {
		return Pos(x + (other.x - x) * t, y + (other.y - y) * t, z + (other.z - z) * t);
	}

	function rotateX(angle) {
		local s = sin(angle);
		local c = cos(angle);
		local newY = y * c - z * s;
		local newZ = y * s + z * c;
		return Pos(x, newY, newZ);
	}

	function rotateY(angle) {
		local s = sin(angle);
		local c = cos(angle);
		local newX = x * c + z * s;
		local newZ = -x * s + z * c;
		return Pos(newX, y, newZ);
	}

	function rotateZ(angle) {
		local s = sin(angle);
		local c = cos(angle);
		local newX = x * c - y * s;
		local newY = x * s + y * c;
		return Pos(newX, newY, z);
	}

	function rotate(rotX, rotY, rotZ) {
		return rotateX(rotX).rotateY(rotY).rotateZ(rotZ);
	}

	function get() {
		return Vector(x, y, z);
	}

	function _tostring() {
		return Type + "(" + x + ", " + y + ", " + z + ")";
	}

	function _add(other) {
		this.x += other.x;
		this.y += other.y;
		this.z += other.z;
		return this;
	}

	function _sub(other) {
		this.x -= other.x;
		this.y -= other.y;
		this.z -= other.z;
		return this;
	}

	function _cmp(other) {
		local a = getMagnitude();
		local b = other.getMagnitude();

		if (a > b) {
			return 1;
		} else if (a < b) {
			return -1;
		} else {
			return 0;
		}
	}

	function _cloned(original) {
		return Pos(original.x, original.y, original.z);
	}
}