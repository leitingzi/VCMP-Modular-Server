keyProcessMap <- Map();
keyProcessTimer <- NewTimer("KeyProcess", 100, 0);

function KeyProcess() {
	keyProcessMap.forEach(function(v) {
		local keyList = v.value;
		keyList.forEach(@(k) KeyDown(v.key, k));
	});
}

function isKeyProcess(player, key) {
	local keyList = keyProcessMap.get(player.ID);
	return keyList.contain(key);
}

function onKeyDown(player, key) {
	local keyList = keyProcessMap.get(player.ID);
	if (keyList != null) {
		if (!keyList.contain(key)) {
			keyList.add(key);
		}
	}

	KeyDown(player.ID, key);
}

function onKeyUp(player, key) {
	local keyList = keyProcessMap.get(player.ID);
	if (keyList != null) {
		keyList.remove(key);
	}
}

function KeyDown(playerID, key) {
	local plr = ::FindPlayer(playerID);
	if (plr == null) {
		return;
	}

	switch (key) {
		case 1:
			break;

		default:
			break;
	}
}