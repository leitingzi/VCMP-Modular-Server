
//Entity
entityArray <- array(10000 * 10, null);

function entityForEach(f) {
	for (local i = 0; i < entityArray.len(); i++) {
		if (entityArray[i] == null) {
			continue;
		}

		f(entityArray[i]);
	}
}

function entityForEachIndex(f) {
	for (local i = 0; i < entityArray.len(); i++) {
		if (entityArray[i] == null) {
			continue;
		}

		f(i, entityArray[i]);
	}
}

function entityfilter(f) {
	local list = List();
	for (local i = 0; i < entityArray.len(); i++) {
		if (entityArray[i] == null) {
			continue;
		}

		if (f(entityArray[i])) {
			list.add(entityArray[i]);
		}
	}
	return list;
}

function entityFind(type, id) {
	for (local i = 0; i < entityArray.len(); i++) {
		if (entityArray[i] == null) {
			continue;
		}

		if (typeof entityArray[i] != type) {
			continue;
		}

		if (entityArray[i].entity.ID == id) {
			return entityArray[i];
		}
	}
	return null;
}

// ========================================== V E H I C L E   E V E N T S =============================================

function onPlayerEnteringVehicle(player, vehicle, door) {
	return Entity.Event(vehicle.ID, "Vehicle", "onPlayerEnteringVehicle", player, door);
}

function onPlayerEnterVehicle(player, vehicle, door) {
	Entity.Event(vehicle.ID, "Vehicle", "onPlayerEnterVehicle", player, door);
}

function onPlayerExitVehicle(player, vehicle) {
	Entity.Event(vehicle.ID, "Vehicle", "onPlayerExitVehicle", player);
}

function onVehicleExplode(vehicle) {
	Entity.Event(vehicle.ID, "Vehicle", "onVehicleExplode");
}

function onVehicleRespawn(vehicle) {
	Entity.Event(vehicle.ID, "Vehicle", "onVehicleRespawn");
}

function onVehicleHealthChange(vehicle, oldHP, newHP) {
	Entity.Event(vehicle.ID, "Vehicle", "onVehicleHealthChange", oldHP, newHP);
}

function onVehicleMove(vehicle, lastX, lastY, lastZ, newX, newY, newZ) {
	Entity.Event(vehicle.ID, "Vehicle", "onVehicleMove", Pos(lastX, lastY, lastZ), Pos(newX, newY, newZ));
}

// =========================================== P I C K U P   E V E N T S ==============================================

function onPickupClaimPicked(player, pickup) {
	return Entity.Event(pickup.ID, "Pickup", "onPickupClaimPicked", player);
}

function onPickupPickedUp(player, pickup) {
	Entity.Event(pickup.ID, "Pickup", "onPickupPickedUp", player);
}

function onPickupRespawn(pickup) {
	Entity.Event(pickup.ID, "Pickup", "onPickupRespawn");
}

// ========================================== O B J E C T   E V E N T S ==============================================

function onObjectShot(object, player, weapon) {
	Entity.Event(object.ID, "Object", "onObjectShot", player, weapon);
}

function onObjectBump(object, player) {
	Entity.Event(object.ID, "Object", "onObjectBump", player);
}

// ====================================== C H E C K P O I N T   E V E N T S ==========================================

function onCheckpointEntered(player, checkpoint) {
	Entity.Event(checkpoint.ID, "Checkpoint", "onCheckpointEntered", player);
}

function onCheckpointExited(player, checkpoint) {
	Entity.Event(checkpoint.ID, "Checkpoint", "onCheckpointExited", player);
}