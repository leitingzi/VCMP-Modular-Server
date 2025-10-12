class MarkerClass extends Entity {
	static Type = "Marker";
	World = null;
	Pos = null;
	Size = null;
	Color = null;
	Sprite = null;

	createInfoIndex = ["sprite", "pos", "size", "color", "world"];

	function create(sprite, pos = Pos(), size = 2, color = Color(), world = 1) {
		entity = ::CreateMarker(world, pos.get(), size, color.get(), sprite);
		this.World = world;
		this.Pos = pos;
		this.Size = size;
		this.Color = color;
		this.Sprite = sprite;

		createInfo = {
			sprite = sprite,
			pos = pos,
			size = size,
			color = color,
			world = world
		}

		return this;
	}

	function createTableInfo() {
		return {
			sprite = this.Sprite,
			pos = this.Pos,
			size = this.Size,
			color = this.Color,
			world = this.World
		}
	}

	function destoryOnly() {
		::DestroyMarker(entity);
		entity = null;

		World = null;
		Pos = null;
		Size = null;
		Color = null;
		Sprite = null;
	}

	function getInfo() {
		return {
			World = {
				type = "w",
				get = this.World,
				set = function(v) {
					local info = createTableInfo();
					info.world = v;
					return reBuild(info);
				}.bindenv(this)
			},
			Pos = {
				type = "w",
				get = this.Pos,
				set = function(v) {
					local info = createTableInfo();
					info.pos = v;
					return reBuild(info);
				}.bindenv(this)
			},
			Size = {
				type = "w",
				get = this.Size,
				set = function(v) {
					local info = createTableInfo();
					info.size = v;
					return reBuild(info);
				}.bindenv(this)
			},
			Color = {
				type = "w",
				get = this.Color,
				set = function(v) {
					local info = createTableInfo();
					info.color = v;
					return reBuild(info);
				}.bindenv(this)
			},
			Sprite = {
				type = "w",
				get = this.Sprite,
				set = function(v) {
					local info = createTableInfo();
					info.sprite = v;
					return reBuild(info);
				}.bindenv(this)
			},
		}
	}
}