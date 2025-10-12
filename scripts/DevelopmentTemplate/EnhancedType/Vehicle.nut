class VehicleClass extends Entity {
	static Type = "Vehicle";
	createInfoIndex = ["model", "pos", "rotation", "col1", "col2", "world"];

	static function CreateFormPlayer(plr, model = 191) {
		local v = VehicleClass().create(model, Pos.fromVector(plr.Pos), Rotation.fromPlayer(plr), -1, -1, plr.World);
		plr.Vehicle = v.entity;
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string, "^", "%");
		if (e.type == Type) {
			local model = TypeConversion.Conver("integer", e.valueArray[0]);
			local pos = TypeConversion.Conver("Pos", e.valueArray[1]);
			local rot = TypeConversion.Conver("Rotation", e.valueArray[2]);
			local col1 = TypeConversion.Conver("integer", e.valueArray[3]);
			local col2 = TypeConversion.Conver("integer", e.valueArray[4]);
			local world = TypeConversion.Conver("integer", e.valueArray[5]);
			return VehicleClass().create(model, pos, rot, col1, col2, world);
		} else {
			return null;
		}
	}

	function getSaveString() {
		local info = createTableInfo();
		local pos = TypeConversion.getSaveString(info.pos);
		local rot = TypeConversion.getSaveString(info.rotation)
		return info.model + "%" + pos + "%" + rot + "%" + info.col1 + "%" + info.col2 + "%" + info.world + "^" + Type;
	}


	function create(model, pos = Pos(), rotation = Rotation(), col1 = -1, col2 = -1, world = 1) {
		entity = ::CreateVehicle(model, pos.get(), rotation.getZAngle(), col1, col2);
		entity.Rotation = rotation.get();
		entity.World = world;

		createInfo = {
			model = model,
			pos = pos,
			rotation = rotation,
			col1 = col1,
			col2 = col2,
			world = world
		}

		return this;
	}

	function createTableInfo() {
		return {
			model = entity.Model,
			pos = Pos.fromVector(entity.Pos),
			rotation = Rotation.fromQuaternion(entity.Rotation),
			col1 = entity.Colour1,
			col2 = entity.Colour1,
			world = entity.World
		}
	}

	function getAngle() {
		return asin(entity.Rotation.z) * 2;
	}

	function getInfo() {
		if (entity == null) {
			return null;
		}
		return {
			Immunity = {
				type = "w",
				get = entity.Immunity,
				set = function(v) {
					entity.Immunity = v;
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
			World = {
				type = "w",
				get = entity.World,
				set = function(v) {
					entity.World = v;
					return v;
				}.bindenv(this)
			},
			SpawnPos = {
				type = "w",
				get = entity.SpawnPos,
				set = function(v) {
					entity.SpawnPos = v;
					return v;
				}.bindenv(this)
			},
			EulerSpawnAngle = {
				type = "w",
				get = entity.EulerSpawnAngle,
				set = function(v) {
					entity.EulerSpawnAngle = v;
					return v;
				}.bindenv(this)
			},
			SpawnAngle = {
				type = "w",
				get = entity.SpawnAngle,
				set = function(v) {
					entity.SpawnAngle = v;
					return v;
				}.bindenv(this)
			},
			RespawnTimer = {
				type = "w",
				get = entity.RespawnTimer,
				set = function(v) {
					entity.RespawnTimer = v;
					return v;
				}.bindenv(this)
			},
			Health = {
				type = "w",
				get = entity.Health,
				set = function(v) {
					entity.Health = v;
					return v;
				}.bindenv(this)
			},
			Colour1 = {
				type = "w",
				get = entity.Colour1,
				set = function(v) {
					entity.Colour1 = v;
					return v;
				}.bindenv(this)
			},
			Colour2 = {
				type = "w",
				get = entity.Colour2,
				set = function(v) {
					entity.Colour2 = v;
					return v;
				}.bindenv(this)
			},
			Locked = {
				type = "w",
				get = entity.Locked,
				set = function(v) {
					entity.Locked = v;
					return v;
				}.bindenv(this)
			},
			Damage = {
				type = "w",
				get = entity.Damage,
				set = function(v) {
					entity.Damage = v;
					return v;
				}.bindenv(this)
			},
			Alarm = {
				type = "w",
				get = entity.Alarm,
				set = function(v) {
					entity.Alarm = v;
					return v;
				}.bindenv(this)
			},
			Siren = {
				type = "w",
				get = entity.Siren,
				set = function(v) {
					entity.Siren = v;
					return v;
				}.bindenv(this)
			},
			Lights = {
				type = "w",
				get = entity.Lights,
				set = function(v) {
					entity.Lights = v;
					return v;
				}.bindenv(this)
			},
			Angle = {
				type = "w",
				get = entity.Angle,
				set = function(v) {
					entity.Angle = v;
					return v;
				}.bindenv(this)
			},
			Rotation = {
				type = "w",
				get = entity.Rotation,
				set = function(v) {
					entity.Rotation = v;
					return v;
				}.bindenv(this)
			},
			EulerAngle = {
				type = "w",
				get = entity.EulerAngle,
				set = function(v) {
					entity.EulerAngle = v;
					return v;
				}.bindenv(this)
			},
			EulerRotation = {
				type = "w",
				get = entity.EulerRotation,
				set = function(v) {
					entity.EulerRotation = v;
					return v;
				}.bindenv(this)
			},
			Speed = {
				type = "w",
				get = entity.Speed,
				set = function(v) {
					entity.Speed = v;
					return v;
				}.bindenv(this)
			},
			RelativeSpeed = {
				type = "w",
				get = entity.RelativeSpeed,
				set = function(v) {
					entity.RelativeSpeed = v;
					return v;
				}.bindenv(this)
			},
			TurnSpeed = {
				type = "w",
				get = entity.TurnSpeed,
				set = function(v) {
					entity.TurnSpeed = v;
					return v;
				}.bindenv(this)
			},
			RelativeTurnSpeed = {
				type = "w",
				get = entity.RelativeTurnSpeed,
				set = function(v) {
					entity.RelativeTurnSpeed = v;
					return v;
				}.bindenv(this)
			},
			Radio = {
				type = "w",
				get = entity.Radio,
				set = function(v) {
					entity.Radio = v;
					return v;
				}.bindenv(this)
			},
			RadioLocked = {
				type = "w",
				get = entity.RadioLocked,
				set = function(v) {
					entity.RadioLocked = v;
					return v;
				}.bindenv(this)
			},
			IsGhost = {
				type = "w",
				get = entity.IsGhost,
				set = function(v) {
					entity.IsGhost = v;
					return v;
				}.bindenv(this)
			},
			Model = {
				type = "r",
				get = entity.Model
			},
			Driver = {
				type = "r",
				get = entity.Driver
			},
			ID = {
				type = "r",
				get = entity.ID
			},
			SyncSource = {
				type = "r",
				get = entity.SyncSource
			},
			SyncType = {
				type = "r",
				get = entity.SyncType
			},
			TurretRotation = {
				type = "r",
				get = entity.TurretRotation
			},
			Wrecked = {
				type = "r",
				get = entity.Wrecked
			},
			Delete = {
				type = "e",
				get = entity.Delete
			},
			Remove = {
				type = "e",
				get = entity.Remove
			},
			Respawn = {
				type = "e",
				get = entity.Respawn
			},
			Kill = {
				type = "e",
				get = entity.Kill
			},
			KillEngine = {
				type = "e",
				get = entity.KillEngine
			},
			GetPart = {
				type = "e",
				get = entity.GetPart
			},
			SetPart = {
				type = "e",
				get = entity.SetPart
			},
			GetTyre = {
				type = "e",
				get = entity.GetTyre
			},
			SetTyre = {
				type = "e",
				get = entity.SetTyre
			},
			GetTire = {
				type = "e",
				get = entity.GetTire
			},
			SetTire = {
				type = "e",
				get = entity.SetTire
			},
			SetFlatTyres = {
				type = "e",
				get = entity.SetFlatTyres
			},
			StreamedForPlayer = {
				type = "e",
				get = entity.StreamedForPlayer
			},
			GetOccupant = {
				type = "e",
				get = entity.GetOccupant
			},
			SetHandlingData = {
				type = "e",
				get = entity.SetHandlingData
			},
			GetHandlingData = {
				type = "e",
				get = entity.GetHandlingData
			},
			ResetHandlingData = {
				type = "e",
				get = entity.ResetHandlingData
			},
			ResetAllHandling = {
				type = "e",
				get = entity.ResetAllHandling
			},
			IsHandlingSet = {
				type = "e",
				get = entity.IsHandlingSet
			},
			AddSpeed = {
				type = "e",
				get = entity.AddSpeed
			},
			AddRelSpeed = {
				type = "e",
				get = entity.AddRelSpeed
			},
			AddTurnSpeed = {
				type = "e",
				get = entity.AddTurnSpeed
			},
			AddRelTurnSpeed = {
				type = "e",
				get = entity.AddRelTurnSpeed
			},
		}
	}

	onPlayerEnteringVehicle = null;
	onPlayerEnterVehicle = null;
	onPlayerExitVehicle = null;
	onVehicleExplode = null;
	onVehicleRespawn = null;
	onVehicleHealthChange = null;
	onVehicleMove = null;

	function onPlayerEnteringVehicle(player, door) {
		return 1;
	}

	function onPlayerEnterVehicle(player, door) {

	}

	function onPlayerExitVehicle(player) {

	}

	function onVehicleExplode() {

	}

	function onVehicleRespawn() {

	}

	function onVehicleHealthChange(oldHp, newHp) {

	}

	function onVehicleMove(oldPos, newPos) {

	}
}