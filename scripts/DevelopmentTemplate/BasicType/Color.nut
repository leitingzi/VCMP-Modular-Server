class Color extends Any {
	static Type = "Colour";

	static White = "[#FFFFFF]";
	static Black = "[#000000]";
	static Red = "[#FF0000]";
	static Green = "[#00FF00]";
	static Blue = "[#0000FF]";
	static Yellow = "[#FFFF00]";
	static Cyan = "[#00FFFF]";
	static Magenta = "[#FF00FF]";
	static Gray = "[#808080]";
	static LightGray = "[#C0C0C0]";
	static DarkGray = "[#404040]";
	static Pink = "[#FFC0CB]";
	static Orange = "[#FFA500]";
	static Purple = "[#800080]";
	static Brown = "[#A52A2A]";
	static Navy = "[#000080]";
	static Teal = "[#008080]";
	static Olive = "[#808000]";

	r = 0;
	g = 0;
	b = 0;
	a = 0;

	constructor(r = 255, g = 255, b = 255, a = 255) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	static function fromRGBA(rgba) {
		return Color(rgba.r, rgba.g, rgba.b, rgba.a);
	}

	static function formRGB(rgb, alpha = 255) {
		return Color(rgb.r, rgb.g, rgb.b, alpha);
	}

	static function Convert(rgb) {
		return "[#" + format("%02X%02X%02X", rgb.r, rgb.g, rgb.b) + "]";
	}

	function get() {
		return RGBA(r, g, b, a);
	}

	function getRGB() {
		return RGB(r, g, b);
	}

	function getARGB() {
		return ARGB(a, r, g, b);
	}

	function _tostring() {
		return Type + "(" + r + ", " + g + ", " + b + ", " + a + ")";
	}

	function getString() {
		return "[#" + format("%02X%02X%02X", r, g, b) + "]";
	}

	function getSaveString() {
		return r + "_" + g + "_" + b + "_" + a + ":" + Type
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string);
		if (e.type == Type) {
			local r = e.valueArray[0].tointeger();
			local g = e.valueArray[1].tointeger();
			local b = e.valueArray[2].tointeger();
			local a = e.valueArray[3].tointeger();
			return Color(r, g, b, a);
		} else {
			return null;
		}
	}
}