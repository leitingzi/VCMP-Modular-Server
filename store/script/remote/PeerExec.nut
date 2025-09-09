pe_token <- 1; //token 0 for no callback function in caller peer
callback_table <- {};
callback_table2 <- {}; //for callbacks from server
exec_token <- 1; //for exec in server
function PeerExec(buffer, playerid, callback_func = null) {
	local stream = ::betterblob();
	if (callback_func) {
		if (typeof(callback_func) == "function")
			stream.WriteInt(StreamType.PeerExecSpecial);
		else {
			throw ("PeerExec.nut: function expected but got " + typeof(callback_func));
			return;
		}
	} else
		stream.WriteInt(StreamType.PeerExec);
	stream.WriteByte(playerid);
	if (callback_func) {
		callback_table.rawset(pe_token, callback_func);
		stream.WriteInt(::pe_token);::pe_token++;
		if (pe_token == 0)
			::pe_token++; //reset to 1.
	}

	if (typeof(buffer) != "superblob") {
		throw ("PeerExec: superblob expected but got " + typeof(buffer));
		return;
	}
	buffer.seek(0, 'b');
	for (local i = 0; i < buffer.len(); i++)
		stream.WriteByte(buffer.readn('b'));
	//foreach(c in buffer)
	//	stream.WriteByte(c);
	//Server.SendData(stream);
	stream.Send();
}
function InsertSQObject(buffer, index, object) {
	if (typeof(buffer) != "superblob")
		return 0;
	//Make write position to index. Also enlarge buffer if necessary.
	if (buffer.tell() != index) {
		if (index <= buffer.len())
			buffer.seek(index);
		else {
			//i want to resize buffer to length 100. Current length is 50
			//Write zero bytes.
			while (buffer.len() < index) buffer.writen(0, 'b');
		}
	}
	switch (typeof(object)) {
		case "null":
			buffer.writen('o', 'b');
			return 1;
		case "integer":
			//Check if it is int16_t?
			if (object <= 32767 && object >= -32768) {
				buffer.writen('w', 'b');
				buffer.writen(object, 's');
				return 3; //'s'->16 bit signed integer
			} else {
				buffer.writen('i', 'b');
				buffer.writen(object, 'i');
				return 5;
			}
		case "float":
			buffer.writen('f', 'b');
			buffer.writen(object, 'f');
			return 5;
		case "bool":
			buffer.writen('b', 'b');
			if (object) buffer.writen(1, 'b');
			else buffer.writen(0, 'b');
			return 2;
		case "string": {
			local len = object.len();
			if (len > 65535) {
				print("string too large\n");
				return 0;
			}
			buffer.writen('s', 'b');
			buffer.writen(swap2(len), 'w'); //16 bits unsigned integer
			foreach(c in object)
			buffer.writen(c, 'b'); //This writes the string
			return 1 + 2 + len;
		}
		case "Vector":
			buffer.writen('v', 'b');
			buffer.writen(object.X, 'f');
			buffer.writen(object.Y, 'f');
			buffer.writen(object.Z, 'f');
			return 13;
		case "VectorScreen":
			buffer.writen('v', 'b');
			buffer.writen(object.X, 'f');
			buffer.writen(object.Y, 'f');
			buffer.writen(0, 'f');
			return 13;
		case "array":
			buffer.writen('a', 'b');
			{
				//Reserve space for L
				buffer.writen(0, 'i');
				local totalsize = 0;
				local result = 0;
				for (local i = 0; i < object.len(); i++) {
					result = InsertSQObject(buffer, buffer.tell(), object[i]);
					if (result == 0) {
						print("Error occured while writing array\n");
						return 0;
					}
					totalsize += result;
				}
				buffer.seek(-totalsize - 4, 'e'); //go back
				buffer.writen(totalsize, 'i');
				buffer.seek(0, 'e'); //come to end of superblob
				return 5 + totalsize;
			}
		case "blob": {
			buffer.writen('B', 'b');
			buffer.writen(object.len(), 'i');
			buffer.writeblob(object); //writes a blob into the stream
			buffer.seek(0, 'e');
			return 5 + object.len();
		}
		case "table": {
			buffer.writen('t', 'b');
			buffer.writen(0, 'i');
			local totalsize = 0;
			local result = 0;
			foreach(key, value in object) {
				if (typeof(key) == "function" || typeof(key) == "class") return 0;
				if (typeof(value) == "function" || typeof(value) == "class") return 0;
				result = InsertSQObject(buffer, buffer.tell(), key);
				if (result == 0) {
					print("Error occured while writing key\n");
					return 0;
				}
				totalsize += result;
				result = InsertSQObject(buffer, buffer.tell(), value);
				if (result == 0) {
					print("Error occured while writing value\n");
					return 0;
				}
				totalsize += result;
			}
			buffer.seek(-totalsize - 4, 'e'); //go back
			buffer.writen(totalsize, 'i');
			buffer.seek(0, 'e'); //come to end
			return 5 + totalsize;
		}
		case "superblob": {
			object.seek(0);
			local i = object.len();
			if (i < 5) {
				print("Invalid buffer passed\n");
				return 0;
			}
			local h = object.readn('b');
			if (h != 'E' && h != 'F' && h != 'g' && h != 'k' && h != 'j' && h != 'h' &&
				h != '+' && h != '-' && h != '*' && h != '/' && h != '%' &&
				h != 'u' //unary minus
			) {
				print("Error unknown buffer passed\n");
				return 0;
			}
			local len = object.readn('i') + 5;
			if (len > i)
				return 0;
			//foreach(c in object)
			//buffer.writen(c,'b');
			buffer.writeblob(object);
			return len;
		}
	}
}
function GetRemoteValue(key) {
	local buffer = superblob();
	buffer.writen('g', 'b'); //8 bits unsigned integer
	buffer.writen(0, 'i'); //L or size
	local n_bytes = InsertSQObject(buffer, buffer.tell(), key);
	if (n_bytes == 0)
		throw ("Error writing key");
	local len = buffer.len() - 5;
	buffer.seek(1, 'b'); //1 byte from begining
	buffer.writen(len, 'i');
	buffer.seek(0, 'e'); //to end of stream
	return buffer;
}
function GetRemoteValueEx(obj, key) {
	local buffer = superblob();
	buffer.writen('k', 'b'); //8 bits unsigned integer
	buffer.writen(0, 'i'); //L or size
	local n_bytes = InsertSQObject(buffer, buffer.tell(), obj);
	if (n_bytes == 0)
		throw ("Error writing object");
	n_bytes = InsertSQObject(buffer, buffer.tell(), key);
	if (n_bytes == 0)
		throw ("Error writing key");
	local len = buffer.len() - 5;
	buffer.seek(1, 'b'); //1 byte from begining
	buffer.writen(len, 'i');
	buffer.seek(0, 'e'); //to end of stream
	return buffer;
}

function SetRemoteValue(key, value) {
	local buffer = superblob();
	buffer.writen('h', 'b'); //code for set
	buffer.writen(0, 'i'); //L or size
	local n_bytes = InsertSQObject(buffer, buffer.tell(), key);
	if (n_bytes == 0)
		throw ("Error writing key");
	n_bytes = InsertSQObject(buffer, buffer.tell(), value);
	if (n_bytes == 0)
		throw ("Error writing value");
	local len = buffer.len() - 5;
	buffer.seek(1, 'b'); //1 byte from begining
	buffer.writen(len, 'i');
	buffer.seek(0, 'e'); //to end of stream
	return buffer;
}
function SetRemoteValueEx(obj, key, value) {
	local buffer = superblob();
	buffer.writen('j', 'b'); //code for set-ex
	buffer.writen(0, 'i'); //L or size
	local n_bytes = InsertSQObject(buffer, buffer.tell(), obj);
	if (n_bytes == 0)
		throw ("Error writing obj");
	n_bytes = InsertSQObject(buffer, buffer.tell(), key);
	if (n_bytes == 0)
		throw ("Error writing key");
	n_bytes = InsertSQObject(buffer, buffer.tell(), value);
	if (n_bytes == 0)
		throw ("Error writing value");
	local len = buffer.len() - 5;
	buffer.seek(1, 'b'); //1 byte from begining
	buffer.writen(len, 'i');
	buffer.seek(0, 'e'); //to end of stream
	return buffer;
}
function CallRemoteFunc(...) {
	local buffer = superblob();
	buffer.writen('F', 'b'); //F for CallRemoteFunc
	buffer.writen(0, 'i'); //L or size
	local n_bytes;
	local i = 0;
	if (vargv.len() == 0) {
		print("CallRemoteFunc: Atleast one parameter is required\n");
		return 0;
	}
	while (i < vargv.len()) {
		n_bytes = InsertSQObject(buffer, buffer.tell(), vargv[i++]);
		if (n_bytes == 0)
			throw ("Error writing data " + typeof(other));
	}

	local len = buffer.len() - 5;
	buffer.seek(1, 'b'); //1 byte from begining
	buffer.writen(len, 'i');
	buffer.seek(0, 'e'); //to end of stream
	return buffer;
}
function CallRemoteFuncEx(...) {
	local buffer = superblob();
	buffer.writen('E', 'b'); //E for CallRemoteFuncEx
	buffer.writen(0, 'i'); //L or size
	local n_bytes;
	local i = 0;
	if (vargv.len() < 2) {
		print("CallRemoteFuncEx: Atleast two parameters are required\n");
		return 0;
	}
	while (i < vargv.len()) {
		n_bytes = InsertSQObject(buffer, buffer.tell(), vargv[i++]);
		if (n_bytes == 0)
			throw ("Error writing data " + typeof(other));
	}

	local len = buffer.len() - 5;
	buffer.seek(1, 'b'); //1 byte from begining
	buffer.writen(len, 'i');
	buffer.seek(0, 'e'); //to end of stream
	return buffer;
}
function onPeerReply(from, token, result, error = false) {
	if (token == 0) return; //no callback
	if (token == -1) {
		//It is some error PeerExecHere. Output to debug log
		print("onPeerReply: (from:" + from + ") :" + result);
		return;
	} else if (error) {
		print("onPeerReply: (from:" + from + ") (" + token + "): " + result);
		return;
	}
	local func = callback_table.rawget(token);
	if (func && typeof(func) == "function") {
		func.call(getroottable(), result);
		callback_table.rawdelete(token);
	}
}


class superblob extends blob {
	function _get(key) {
		return::GetRemoteValueEx(this, key);
	}
	function _typeof() {
		return "superblob";
	}
	_call = function(...) {
		if (this.len() > 0) {
			if (vargv.len() < 1) {
				throw ("superblob/_call: vargv.len() < 1");
				//return;//never happens
			} else {
				local func;
				local array_args = [::getroottable()];
				array_args.append(this);
				if (typeof(vargv[0]) == "superblob") {
					//This means GetRemoteValue("something").Something() and vargv[0]=GetRemoteValue("something")
					//and //vargv[1]=GetRemoteValue("something").Something
					func = ::CallRemoteFuncEx;
					array_args.append(vargv[0]); //env
				} else if (typeof(vargv[0]) == "table" ||
					typeof(vargv[0]) == "class" || typeof(vargv[0]) == "instance")
				//&&(vargv[0]==::Server || vargv[0]==::Player || vargv[0]==::GUI || vargv[0]==::Script || vargv[0]==::KeyBind ||
				//vargv[0]==Server)	//for compability - unknown reasons
				//))
				{
					//GetRemoteValue("Something")(..)
					func = ::CallRemoteFunc
				} else {
					throw ("superblob/_call: vargv[0] is neither superblob, nor table, class or instance");
					//return;//usually never happens unless superblob.pacall is used
				}

				for (local i = 1; i < vargv.len(); i++)
					array_args.append(vargv[i]);
				return func.acall(array_args);
			}
		}
	}
	_add = function(other) {
		if (this.len() > 0) {
			//if(['o','i','f','b','s','v','a','t','g','k','h','j','F','E','+','-','*','/','%','u'].find(this[0])!=null)
			{
				local buffer = ::superblob();
				buffer.writen('+', 'b');
				buffer.writen(0, 'i'); //L
				//this.seek(0,'b');
				//for(local i=0;i<this.len();i++)
				//buffer.writen(this.readn('b'),'b');
				buffer.writeblob(this);
				local n_bytes = ::InsertSQObject(buffer, buffer.tell(), other);
				if (n_bytes == 0)
					throw ("Error writing data type: " + typeof(other));

				local len = buffer.len() - 5;
				buffer.seek(1, 'b'); //1 byte from begining
				buffer.writen(len, 'i');
				buffer.seek(0, 'e'); //to end of stream
				return buffer;
			}
		}
	}
	_sub = function(other) {
		if (this.len() > 0) {
			//if(['o','i','f','b','s','v','a','t','g','k','h','j','F','E','+','-','*','/','%','u'].find(this[0])!=null)
			{
				//it is buffer
				local buffer = ::superblob();
				buffer.writen('-', 'b');
				buffer.writen(0, 'i'); //L
				buffer.writeblob(this);
				local n_bytes = ::InsertSQObject(buffer, buffer.tell(), other);
				if (n_bytes == 0)
					throw ("Error writing data " + typeof(other));
				local len = buffer.len() - 5;
				buffer.seek(1, 'b'); //1 byte from begining
				buffer.writen(len, 'i');
				buffer.seek(0, 'e'); //to end of stream
				return buffer;
			}
		}
	}
	_mul = function(other) {
		if (this.len() > 0) {
			//if(['o','i','f','b','s','v','a','t','g','k','h','j','F','E','+','-','*','/','%','u'].find(this[0])!=null)
			{
				//it is buffer
				local buffer = ::superblob();
				buffer.writen('*', 'b');
				buffer.writen(0, 'i'); //L
				buffer.writeblob(this);
				local n_bytes = ::InsertSQObject(buffer, buffer.tell(), other);
				if (n_bytes == 0)
					throw ("Error writing data " + typeof(other));
				local len = buffer.len() - 5;
				buffer.seek(1, 'b'); //1 byte from begining
				buffer.writen(len, 'i');
				buffer.seek(0, 'e'); //to end of stream
				return buffer;
			}
		}
	}
	_div = function(other) {
		if (this.len() > 0) {
			//if(['o','i','f','b','s','v','a','t','g','k','h','j','F','E','+','-','*','/','%','u'].find(this[0])!=null)
			{
				//it is buffer
				local buffer = ::superblob();
				buffer.writen('/', 'b');
				buffer.writen(0, 'i'); //L
				buffer.writeblob(this);
				local n_bytes = ::InsertSQObject(buffer, buffer.tell(), other);
				if (n_bytes == 0)
					throw ("Error writing data " + typeof(other));
				local len = buffer.len() - 5;
				buffer.seek(1, 'b'); //1 byte from begining
				buffer.writen(len, 'i');
				buffer.seek(0, 'e'); //to end of stream
				return buffer;
			}
		}
	}
	_modulo = function(other) {
		if (this.len() > 0) {
			//if(['o','i','f','b','s','v','a','t','g','k','h','j','F','E','+','-','*','/','%','u'].find(this[0])!=null)
			{
				//it is buffer
				local buffer = ::superblob();
				buffer.writen('%', 'b');
				buffer.writen(0, 'i'); //L
				buffer.writeblob(this);
				local n_bytes = ::InsertSQObject(buffer, buffer.tell(), other);
				if (n_bytes == 0)
					throw ("Error writing data " + typeof(other));
				local len = buffer.len() - 5;
				buffer.seek(1, 'b'); //1 byte from begining
				buffer.writen(len, 'i');
				buffer.seek(0, 'e'); //to end of stream
				return buffer;
			}
		}
	}
	_unm = function() {
		if (this.len() > 0) {
			//if(['o','i','f','b','s','v','a','t','g','k','h','j','F','E','+','-','*','/','%','u'].find(this[0])!=null)
			{
				//it is buffer
				local buffer = ::superblob();
				buffer.writen('u', 'b');
				buffer.writen(0, 'i'); //L
				buffer.writeblob(this);
				local len = buffer.len() - 5;
				buffer.seek(1, 'b'); //1 byte from begining
				buffer.writen(len, 'i');
				buffer.seek(0, 'e'); //to end of stream
				return buffer;
			}
		}
	}
}
//For executing squirrel statements in server
function Exec(buffer, callback_func = null) {
	local stream = ::betterblob();
	if (callback_func) {
		if (typeof(callback_func) == "function")
			stream.WriteInt(StreamType.ExecSpecial);
		else {
			throw ("Exec: function expected but got " + typeof(callback_func));
			return;
		}
	} else
		stream.WriteInt(StreamType.Exec);
	if (callback_func) {
		callback_table2.rawset(exec_token, callback_func);
		stream.WriteInt(::exec_token);::exec_token++;
		if (exec_token == 0)
			::exec_token++; //reset to 1.
	}

	if (typeof(buffer) != "superblob") {
		throw ("Exec: superblob expected but got " + typeof(buffer));
		return;
	}
	buffer.seek(0, 'b');
	for (local i = 0; i < buffer.len(); i++)
		stream.WriteByte(buffer.readn('b'));
	stream.Send();
}

function onServerReply(token, result, error = false) {
	if (token == 0) return; //no callback
	if (token == -1) {
		//It is some error. Output to debug log
		print("onServerReply :" + result);
		return;
	} else if (error) {
		print("onServerReply: (" + token + "): " + result);
		return;
	}
	local func = callback_table2.rawget(token);
	if (func && typeof(func) == "function") {
		func.call(getroottable(), result);
		callback_table2.rawdelete(token);
	}
}