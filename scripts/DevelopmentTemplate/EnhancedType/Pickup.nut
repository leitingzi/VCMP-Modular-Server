class PickupClass extends Entity {
	static Type = "Pickup";
	createInfoIndex = ["model", "pos", "alpha", "world"];

	function create(model, pos = Pos(), alpha = 255, world = 1) {
		entity = ::CreatePickup(model, pos.get());
		entity.Alpha = alpha;
		entity.World = world;

		createInfo = {
			model = model,
			pos = pos,
			alpha = alpha,
			world = world
		}

		return this;
	}

	function createTableInfo() {
		return {
			model = entity.Model,
			pos = Pos.fromVector(entity.Pos),
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
			Alpha = {
				type = "w",
				get = entity.Alpha,
				set = function(v) {
					entity.Alpha = v;
					return v;
				}.bindenv(this)
			},
			Automatic = {
				type = "w",
				get = entity.Automatic,
				set = function(v) {
					entity.Automatic = v;
					return v;
				}.bindenv(this)
			},
			Timer = {
				type = "w",
				get = entity.Timer,
				set = function(v) {
					entity.Timer = v;
					return v;
				}.bindenv(this)
			},
			RespawnTime = {
				type = "w",
				get = entity.RespawnTime,
				set = function(v) {
					entity.RespawnTime = v;
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
			Model = {
				type = "r",
				get = entity.Model
			},
			Quantity = {
				type = "r",
				get = entity.Quantity
			},
			Remove = {
				type = "e",
				get = entity.Remove
			},
			Respawn = {
				type = "e",
				get = entity.Respawn
			},
			StreamedToPlayer = {
				type = "e",
				get = entity.StreamedToPlayer
			}
		}
	}

	onPickupClaimPicked = null;
	onPickupPickedUp = null;
	onPickupRespawn = null;

	function onPickupClaimPicked(player) {
		return 1;
	}

	function onPickupPickedUp(player) {

	}

	function onPickupRespawn() {

	}
}