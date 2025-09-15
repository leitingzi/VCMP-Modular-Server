class Math {
	static function abs(a) {
		return a < 0 ? -a : a;
	}

	static function copySign(a) {
		return a < 0 ? -a : a;
	}

	static function min(a, b) {
		return a <= b ? a : b;
	}

	static function max(a, b) {
		return a >= b ? a : b;
	}
}

function abs(a) {
	return a < 0 ? -a : a;
}

function copysign(a) {
	return a < 0 ? -1 : 1;
}

function random(min, max) {
	if (min < max) return rand() % (max - min + 1) + min.tointeger();
	else if (min > max) return rand() % (min - max + 1) + max.tointeger();
	else if (min == max) return min.tointeger();
}

function roundTo(num, n = 2) {
	local factor = pow(10, n);
	return floor(num * factor + 0.5) / factor;
}

function lerp(start, end, t) {
	return start + (end - start) * t;
}

function dist2D(v1, v2) {
	local dx = v2.x - v1.x, dy = v2.y - v1.y;
	return sqrt(dx * dx + dy * dy);
}

function dist3D(v1, v2) {
	local dx = v2.x - v1.x, dy = v2.y - v1.y, dz = v2.z - v1.z;
	return sqrt(dx * dx + dy * dy + dz * dz);
}

function radianToAngle(radian) {
	return (radian + PI) * (180.0 / PI);
}

function max(a, b) {
	if(a >= b) {
		return a;
	} else {
		return b;
	}
}

function min(a, b) {
	if(a <= b) {
		return a;
	} else {
		return b;
	}
}

// 来自 kl
function onCalQuaternion(x, y, z, w, pos) {
	local a, b, c, d;
	a = x * pos.x + y * pos.y + z * pos.z;
	b = w * pos.x + y * pos.z - z * pos.y;
	c = w * pos.y - x * pos.z + z * pos.x;
	d = w * pos.z + x * pos.y - y * pos.x;
	pos = Vector(a * x + b * w - c * z + d * y, a * y + b * z + c * w - d * x, a * z - b * y + c * x + d * w);
	return pos;
}

function onCalQuaternionEx(rotation, pos) {
	return onCalQuaternion(rotation.x, rotation.y, rotation.z, rotation.w, pos);
}

// 来自 Habi
function Multiply(a, b) { //Quaternions
	local v1 = Vector(a.x, a.y, a.z);
	local v2 = Vector(b.x, b.y, b.z);
	local r1 = a.w;
	local r2 = b.w;
	local r = r1 * r2 - Dot(v1, v2);
	local v = MultiplyWithScalar(v2, r1) + MultiplyWithScalar(v1, r2) + Cross(v1, v2);
	return Quaternion(v.x, v.y, v.z, r);
}
function Dot(v1, v2) {
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
}
function Cross(a, b) {
	local i = a.y * b.z - a.z * b.y
	local j = a.z * b.x - a.x * b.z
	local k = a.x * b.y - a.y * b.x
	return Vector(i, j, k); //you know these are not i j k, but components of it.
}
function MultiplyWithScalar(v, s) {
	return Vector(v.x * s, v.y * s, v.z * s);
}
function r(a) {
	return Quaternion(sin(a / 2), 0, 0, cos(a / 2))
};
function s(a) {
	return Quaternion(0, sin(a / 2), 0, cos(a / 2))
};
function t(a) {
	return Quaternion(0, 0, sin(a / 2), cos(a / 2))
};