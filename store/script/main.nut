/*
    客户端脚本

    您可以在这里找到更多脚本示例：http://forum.vc-mp.org/
    访问论坛，然后前往 “客户端脚本”。
    祝您一切顺利！

    VC:MP 客户端文档：http://wiki.vc-mp.org/wiki/Client-side_Scripting_Resources
*/

enum StreamType {
	RemoteExecute = 0x40ffffe1 //用于执行
	RemoteExecuteSpecial = 0x40ffffe2 //用于执行并使用令牌返回结果
	Reply = 0x40ffffe3 //用于将结果发送到服务器
	CompileString = 0x40ffffe4
	RPrint = 0x40ffffe5
	PeerExec = 0x40ffffe6 //在另一个对等点的虚拟机中执行代码
	PeerExecHere = 0x40ffffea
	SendResultToPeer = 0x40ffffe7 //包含要返回的对等点 ID，以及可能指向回调函数的有效令牌
	ResultFromPeer = 0x40ffffe8
	PeerExecSpecial = 0x40ffffe9 //用于执行并使用令牌返回结果
	PeerExecHere2 = 0x40ffffeb
	SplitStream = 0x40ffffec //用于发送到服务器
	SplitStreamFromServer = 0x40ffffed //从服务器接收数据。
	ClientData = 0x40ffffee //将数据发送到服务器
	LoadNutFile = 0x40ffffef //使用 compilestring 加载以字符串形式传递的文件内容。服务器->客户端
	NutFileLoaded = 0x40fffff0 //返回 LoadNutFile 函数中 NutFile 的返回值
	Exec = 0x40fffff1 //在服务器中执行
	ExecSpecial = 0x40fffff2 //在服务器中执行并返回值
	ResultFromServer = 0x40fffff3 //来自服务器的结果（ExecSpecial 的结果）
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