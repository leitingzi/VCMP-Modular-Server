class CheckpointClass extends Entity {
	static Type = "Checkpoint";
	isSphere = null;

	createInfoIndex = ["player", "pos", "radius", "color", "isSphere", "world"];

	function create(player = null, pos = Pos(), radius = 2.5, color = Color(), isSphere = false, world = 1) {
		entity = ::CreateCheckpoint(player, world, isSphere, pos.get(), color.get(), radius);
		this.isSphere = isSphere;

		createInfo = {
			player = player,
			pos = pos,
			radius = radius,
			color = color,
			isSphere = this.isSphere,
			world = world
		}

		onCreate();

		return this;
	}

	function createTableInfo() {
		return {
			player = entity.Owner,
			pos = Pos.fromVector(entity.Pos),
			radius = entity.Radius,
			color = Color.fromRGBA(entity.Color),
			isSphere = this.isSphere,
			world = entity.World
		}
	}

	function destoryOnly() {
		base.destoryOnly();
		isSphere = null;
	}

	function getInfo() {
		return {
			World = {
				type = "w",
				get = entity.World,
				set = function(v) {
					entity.World = v;
					return v;
				}.bindenv(this)
			},
			Color = {
				type = "w",
				get = entity.Color,
				set = function(v) {
					entity.Color = v;
					return v;
				}.bindenv(this)
			},
			Radius = {
				type = "w",
				get = entity.Radius,
				set = function(v) {
					entity.Radius = v;
					return v;
				}.bindenv(this)
			},
			Pos = {
				type = "w",
				get = entity.Pos,
				set = function(v) {
					entity.Pos = v;
					return v;
				}.bindenv(this)
			},
			ID = {
				type = "r",
				get = entity.ID
			},
			Owner = {
				type = "r",
				get = entity.Owner
			},
			isSphere = {
				type = "r",
				get = entity.isSphere
			},
			Remove = {
				type = "e",
				get = entity.Remove
			},
			StreamedToPlayer = {
				type = "e",
				get = entity.StreamedToPlayer
			},
		};
	}

	onCheckpointEntered = null;
	onCheckpointExited = null;

	function onCheckpointEntered(player) {

	}

	function onCheckpointExited(player) {

	}
}