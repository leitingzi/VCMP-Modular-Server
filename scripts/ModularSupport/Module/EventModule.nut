class EventModule {
	function onScriptLoad() {}
	function onScriptUnload() {}
	function onServerStart() {}
	function onServerStop() {}

	function onPlayerJoin(player) {}
	function onPlayerPart(player, reason) {}
	function onPlayerRequestClass(player, classID, team, skin) {}
	function onPlayerRequestSpawn(player) {}
	function onPlayerSpawn(player) {}
	function onPlayerDeath(player, reason) {}
	function onPlayerKill(player, killer, reason, bodypart) {}
	function onPlayerChat(player, text) {}
	function onPlayerCommand(player, cmd, text) {}
	function onKeyDown(player, key) {}
	function onKeyUp(player, key) {}

	function onClientData(player, identifier, data) {}

	function onConsoleInput(cmd, text) {}
}

function moduleEvent(func, ...) {
	local funcInfo = func.getinfos();
	local funcName = funcInfo.name;
	local returnDefaultValue = true;
	local returnValue = returnDefaultValue;

	for (local i = 0; i < moduleArray.len(); i++) {
		local module = moduleArray[i];
		local moduleClass = get(module);

		if (moduleClass.rawin(funcName)) {
			local moduleFuncInfo = moduleClass[funcName].getinfos();
			local parameters = moduleFuncInfo.parameters;
			local defparams = moduleFuncInfo.defparams;

			local varr = [moduleClass];
			for (local i = 0; i < vargv.len(); i++) {
				varr.append(vargv[i]);
			}

			if (vargv.len() < parameters.len()) {
				local len = parameters.len() - vargv.len();
				for (local i = len; i < defparams.len(); i++) {
					varr.append(defparams[i]);
				}
			}

			returnValue = moduleClass[funcName].acall(varr);
			if (returnValue == null) {
				returnValue = returnDefaultValue;
			}
		}
		break;
	}

	return returnValue;
}