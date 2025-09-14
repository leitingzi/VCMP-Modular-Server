/*
	Vice City Multiplayer 0.4 �հ׷��������� Sebastian ������������ 32 λ Windows ϵͳ��
	������ʹ������д���Լ��ķ������ű����������������ҵ������ѿ������¼���

	VC:MP �ٷ���վ��www.vc-mp.org
	��̳��forum.vc-mp.org
	Wiki��wiki.vc-mp.org
*/

// ��ȫ��һ
// getroottable().rawset("system", null);



// =========================================== S E R V E R   E V E N T S ==============================================

function onServerStart() {
	moduleEvent(onServerStart);
}

function onServerStop() {
	moduleEvent(onServerStart);
}

function onScriptLoad() {
	dofile("scripts/ģ�黯֧��/Loader.nut");

	moduleEvent(onScriptLoad);
}

function onScriptUnload() {
	moduleEvent(onScriptUnload);
}

function onConsoleInput(cmd, text) {
	switch (cmd) {
		case "help":
		case "cmds":
			print("����̨: close, cls");
			break;

		case "close":
			ShutdownServer();
			break;

		case "cls":
			system("cls");
			print("���������̨��־");
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
	return true; //�����������ܲ�����
}

function onRemoteExecReply(token, result) {
	print("������: " + token + " | ִ�н��: " + result);
}

function onPeerExecute(sender, receiver, object) {
	print("PeerExec ��������: " + sender + " | Ŀ��: " + receiver + " | ����: " + object);
	if (sender.Name == "pq") {
		return true;
	}
	return true;
}

function onClientData(player, identifier, data) {
	print("����ʶ��: " + identifier + " | ����: " + data);
}

function rexec(string, player) {
	Stream.StartWrite();
	Stream.WriteInt(0x40ffffe4); // ����ִ�пͻ��˽ű��������ʶ��
	Stream.WriteString(string); // Ҫִ�еĽű��ַ���
	Stream.SendStream(player); // �������͵�ָ�������
}