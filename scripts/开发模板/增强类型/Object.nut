class ObjectClass extends Entity {
	static Type = "Object";
	createInfoIndex = ["model", "pos", "rotation", "alpha", "world"];

	function create(model, pos = Pos(), rotation = Rotation(), alpha = 255, world = 1) {
		entity = ::CreateObject(model, world, pos.get(), alpha);
		entity.RotateTo(rotation.get(), 0);

		createInfo = {
			model = model,
			pos = pos,
			rotation = rotation,
			alpha = alpha,
			world = world
		}

		return this;
	}

	function createTableInfo() {
		return {
			model = entity.Model,
			pos = Pos.fromVector(entity.Pos),
			rotation = Rotation.fromQuaternion(entity.Rotation),
			alpha = entity.Alpha,
			world = entity.World
		}
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
			Pos = {
				type = "w",
				get = entity.Pos,
				set = function(v) {
					entity.Pos = v;
					return v;
				}.bindenv(this)
			},
			TrackingShots = {
				type = "w",
				get = entity.TrackingShots,
				set = function(v) {
					entity.TrackingShots = v;
					return v;
				}.bindenv(this)
			},
			TrackingBumps = {
				type = "w",
				get = entity.TrackingBumps,
				set = function(v) {
					entity.TrackingBumps = v;
					return v;
				}.bindenv(this)
			},
			ID = {
				type = "r",
				get = entity.ID
			},
			Model = {
				type = "r",
				get = entity.Model
			},
			Alpha = {
				type = "r",
				get = entity.Alpha
			},
			Rotation = {
				type = "r",
				get = entity.Rotation
			},
			RotationEuler = {
				type = "r",
				get = entity.RotationEuler
			},
			Delete = {
				type = "e",
				get = entity.Delete
			},
			MoveTo = {
				type = "e",
				get = entity.MoveTo
			},
			MoveBy = {
				type = "e",
				get = entity.MoveBy
			},
			RotateTo = {
				type = "e",
				get = entity.RotateTo
			},
			RotateBy = {
				type = "e",
				get = entity.RotateBy
			},
			RotateToEuler = {
				type = "e",
				get = entity.RotateToEuler
			},
			RotateByEuler = {
				type = "e",
				get = entity.RotateByEuler
			},
			SetAlpha = {
				type = "e",
				get = entity.SetAlpha
			},
		};
	}

	onObjectShot = null;
	onObjectBump = null;

	function onObjectShot(player, weapon) {

	}

	function onObjectBump(player) {

	}
}