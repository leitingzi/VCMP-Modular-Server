class Rotation extends Any {
	static Type = "Rotation";
	x = 0;
	y = 0;
	z = 0;
	w = 1;

	constructor(x = 0, y = 0, z = 0, w = 1) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string);
		if (e.type == Type) {
			local x = e.valueArray[0].tofloat();
			local y = e.valueArray[1].tofloat();
			local z = e.valueArray[2].tofloat();
			local w = e.valueArray[3].tofloat();
			return Rotation(x, y, z, w);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return x + "_" + y + "_" + z + "_" + w + ":" + Type;
	}

	static function fromAngle(angle) {
		local e = Euler(0, 0, angle);
		return e.toRotation();
	}

	static function fromEuler(euler) {
		return euler.toRotation();
	}

	static function fromPlayer(plr) {
		if (plr.Vehicle) {
			return fromAngle(plr.Vehicle.getAngle());
		} else {
			return fromAngle(plr.Angle);
		}
	}

	static function fromQuaternion(quaternion) {
		return Rotation(quaternion.x, quaternion.y, quaternion.z, quaternion.w);
	}

	static function fromAxisAngle(axis, angle) {
		local sinHalfAngle = sin(angle / 2);
		local cosHalfAngle = cos(angle / 2);
		return Rotation(axis.x * sinHalfAngle, axis.y * sinHalfAngle, axis.z * sinHalfAngle, cosHalfAngle);
	}

	function get() {
		return Quaternion(x, y, z, w);
	}

	function getZAngle() {
		return toEuler().z;
	}

	function magnitude() {
		return sqrt(x * x + y * y + z * z + w * w);
	}

	function normalize() {
		local mag = magnitude();
		if (mag > 0) {
			return Rotation(x / mag, y / mag, z / mag, w / mag);
		}
		return null;
	}

	function conjugate() {
		return Rotation(-x, -y, -z, w);
	}

	function inverse() {
		local mag = magnitude();
		if (mag > 0) {
			return Rotation(-x / mag, -y / mag, -z / mag, w / mag);
		}
		return Rotation();
	}

	function dot(other) {
		return x * other.x + y * other.y + z * other.z + w * other.w;
	}

	function rotateVector(vector) {
		local q = Rotation(vector.x, vector.y, vector.z, 0);
		local result = multiply(q).multiply(conjugate());
		return Vector(result.x, result.y, result.z);
	}

	function rotatePos(initialPos, length) {
		local q = normalize();
		if (q != null) {
			local v = Rotation(initialPos.x, initialPos.y, initialPos.z, 0);
			local qv = q.multiply(v);
			local qInv = q.conjugate();
			local r = qv.multiply(qInv);
			return Pos(r.x * length.x, r.y * length.y, r.z * length.z);
		}
		return null;
	}

	function getAxisAngle() {
		local angle = 2.0 * acos(w);
		local sinHalfAngle = sin(angle / 2);

		if (Abs(sinHalfAngle) < 0.001) {
			return {
				axis = Vector(1, 0, 0),
				angle = angle
			};
		}

		return {
			axis = Euler(x / sinHalfAngle, y / sinHalfAngle, z / sinHalfAngle),
			angle = angle
		};
	}

	function _tostring() {
		return Type + "(" + x + ", " + y + ", " + z + ", " + w + ")";
	}

	function _mul(other) {
		return multiply(other);
	}

	function multiply(other) {
		local x = w * other.x + x * other.w + y * other.z - z * other.y;
		local y = w * other.y - x * other.z + y * other.w + z * other.x;
		local z = w * other.z + x * other.y - y * other.x + z * other.w;
		local w = w * other.w - x * other.x - y * other.y - z * other.z;
		return Rotation(x, y, z, w);
	}

	function equals(other, epsilon = 0.000001) {
		return Abs(x - other.x) < epsilon && Abs(y - other.y) < epsilon && Abs(z - other.z) < epsilon && Abs(w - other.w) < epsilon;
	}

	function toEuler() {
		local norm = sqrt(x * x + y * y + z * z + w * w);
		local qx = x / norm;
		local qy = y / norm;
		local qz = z / norm;
		local qw = w / norm;

		local sinr_cosp = 2 * (qw * qx + qy * qz);
		local cosr_cosp = 1 - 2 * (qx * qx + qy * qy);
		local roll = atan2(sinr_cosp, cosr_cosp);

		local sinp = 2 * (qw * qy - qz * qx);
		local pitch;
		if (Abs(sinp) >= 1) {
			pitch = copysign(PI / 2, sinp);
		} else {
			pitch = asin(sinp);
		}

		local siny_cosp = 2 * (qw * qz + qx * qy);
		local cosy_cosp = 1 - 2 * (qy * qy + qz * qz);
		local yaw = atan2(siny_cosp, cosy_cosp);

		return Euler(roll, pitch, yaw);
	}
}