/*
    �ͻ��˽ű�

    �������������ҵ�����ű�ʾ����http://forum.vc-mp.org/
    ������̳��Ȼ��ǰ�� ���ͻ��˽ű�����
    ף��һ��˳����

    VC:MP �ͻ����ĵ���http://wiki.vc-mp.org/wiki/Client-side_Scripting_Resources
*/

enum StreamType {
	RemoteExecute = 0x40ffffe1 //����ִ��
	RemoteExecuteSpecial = 0x40ffffe2 //����ִ�в�ʹ�����Ʒ��ؽ��
	Reply = 0x40ffffe3 //���ڽ�������͵�������
	CompileString = 0x40ffffe4
	RPrint = 0x40ffffe5
	PeerExec = 0x40ffffe6 //����һ���Եȵ���������ִ�д���
	PeerExecHere = 0x40ffffea
	SendResultToPeer = 0x40ffffe7 //����Ҫ���صĶԵȵ� ID���Լ�����ָ��ص���������Ч����
	ResultFromPeer = 0x40ffffe8
	PeerExecSpecial = 0x40ffffe9 //����ִ�в�ʹ�����Ʒ��ؽ��
	PeerExecHere2 = 0x40ffffeb
	SplitStream = 0x40ffffec //���ڷ��͵�������
	SplitStreamFromServer = 0x40ffffed //�ӷ������������ݡ�
	ClientData = 0x40ffffee //�����ݷ��͵�������
	LoadNutFile = 0x40ffffef //ʹ�� compilestring �������ַ�����ʽ���ݵ��ļ����ݡ�������->�ͻ���
	NutFileLoaded = 0x40fffff0 //���� LoadNutFile ������ NutFile �ķ���ֵ
	Exec = 0x40fffff1 //�ڷ�������ִ��
	ExecSpecial = 0x40fffff2 //�ڷ�������ִ�в�����ֵ
	ResultFromServer = 0x40fffff3 //���Է������Ľ����ExecSpecial �Ľ����
}

sX <- GUI.GetScreenSize().X;
sY <- GUI.GetScreenSize().Y;

errorTimes <- 0;
function errorHandling(err) {
	local stackInfos = getstackinfos(2);
	if (stackInfos) {
		local locals = "";
		foreach(index, value in stackInfos.locals) {
			locals = locals + "[" + index + ": " + type(value) + "] " + value + "\n";
		}

		local callStacks = "";
		local level = 2;
		do {
			callStacks += "*FUNCTION [" + stackInfos.func + "()] " + stackInfos.src + " line [" + stackInfos.line + "]\n";
			level++;
		} while ((stackInfos = getstackinfos(level)));

		local errorMsg = "AN ERROR HAS OCCURRED [" + err + "]\n";
		errorMsg += "\nCALLSTACK\n";
		errorMsg += callStacks;
		errorMsg += "\nLOCALS\n";
		errorMsg += locals;
		errorTimes++;

		foreach(i, msg in split(errorMsg, "\n")) {
			Console.Print("[#FFFFFF]" + msg);
		}

		if (errorTimes >= 5) {
			seterrorhandler(null);
		}
	}
}
seterrorhandler(errorHandling);

dofile("remote/RemoteExec.nut");
dofile("remote/SendReply.nut");
dofile("remote/PeerExec.nut");
dofile("remote/SplitReply.nut");
dofile("remote/SplitStream.nut");

//-------------------------------------------------------------------

function Script::ScriptLoad() {
	Console.Print("[#AAAAAA]*> Client-side script was loaded. <*");
}

function Script::ScriptUnload() {}

function Script::ScriptProcess() {}

function Player::PlayerDeath(player) {}

function Player::PlayerShoot(player, weapon, hitEntity, hitPosition) {}

function Server::ServerData(stream) {
	local i = stream.ReadInt();
	if (stream.Error) {
		return;
	}
	if (i == StreamType.CompileString) {
		local script = compilestring(stream.ReadString());
		try {
			local result = script.call(getroottable());
		} catch (e) {
			rprint("CompileString: " + e);
		}
	} else if (i == StreamType.RemoteExecute) {
		try {
			local res = ProcessData(stream);
		} catch (e) {
			SendReply(-1, e, true);
		}
	} else if (i == StreamType.RemoteExecuteSpecial) {
		local token = stream.ReadInt();
		try {
			local res = ProcessData(stream);
			SendReply(token, res);
		} catch (e) {
			SendReply(token, e, true);
		}
	} else if (i == StreamType.ResultFromPeer) {
		local fromid = stream.ReadByte();
		local token = stream.ReadInt();
		local b = [0, 0];
		local res = ProcessData(stream, b);
		if (b[1] == 'e')
			onPeerReply(fromid, token, res, true);
		else
			onPeerReply(fromid, token, res);
	} else if (i == StreamType.PeerExecHere) {
		local fromid;
		try {
			fromid = stream.ReadByte();
			local res = ProcessData(stream);
		} catch (e) {
			SendReplyToPeer(fromid, -1, e, true);
		}
	} else if (i == StreamType.PeerExecHere2) {
		local fromid, token;
		try {
			fromid = stream.ReadByte();
			token = stream.ReadInt();
			local res = ProcessData(stream);
			SendReplyToPeer(fromid, token, res);
		} catch (e) {
			SendReplyToPeer(fromid, token, "PeerExecHere2: " + e, true);
		}
	} else if (i == StreamType.SplitStreamFromServer) {
		try {
			ProcessSplitStream(stream);
		} catch (e) {
			SendReply(-1, "SplitStreamFromServer: " + e, true);
		}
	} else if (i == StreamType.LoadNutFile) {
		local token = stream.ReadInt();
		local str = stream.ReadString();
		local script = compilestring.call(getroottable(), str);
		try {
			local result = script.call(getroottable());
			if (token != -1) //here -1 means do not 'return the return value'
			{
				local stream = ::betterblob();
				stream.WriteInt(StreamType.NutFileLoaded);
				stream.WriteInt(token);
				WriteDataToStream(result, stream);
				stream.Send();
			}
		} catch (e) {
			rprint("LoadNutFile: " + e);
		}
	} else if (i == StreamType.ResultFromServer) {
		local token = stream.ReadInt();
		local b = [0, 0];
		local res = ProcessData(stream, b);
		if (b[1] == 'e')
			onServerReply(token, res, true);
		else
			onServerReply(token, res);
	}
}

function onGameResize(width, height) {}

function GUI::GameResize(width, height) {}

function GUI::ElementClick(element, mouseX, mouseY) {}

function GUI::ElementRelease(element, mouseX, mouseY) {}

function GUI::ElementFocus(element) {}

function GUI::ElementBlur(element) {}

function GUI::ElementHoverOver(element) {}

function GUI::ElementHoverOut(element) {}

function GUI::ElementDrag(element, mouseX, mouseY) {}

function GUI::CheckboxToggle(checkbox, checked) {}

function GUI::InputReturn(editbox) {}

function GUI::ListboxSelect(listbox, text) {}

function GUI::ScrollbarScroll(scrollbar, position, change) {}

function GUI::WindowClose(window) {}

function GUI::WindowResize(window, width, height) {}

function GUI::KeyPressed(key) {}

function KeyBind::OnDown(keyBind) {}

function KeyBind::OnUp(keyBind) {}