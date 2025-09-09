function SendReply(token, data, error = false) {
	//local stream = Stream();
	local stream = ::betterblob();
	stream.WriteInt(StreamType.Reply);
	stream.WriteInt(token);
	if (!error)
		WriteDataToStream(data, stream);
	else {
		stream.WriteByte('e');
		if (typeof(data) == "string")
			stream.WriteString(data);
		else
			stream.WriteString("");
	}
	//Server.SendData(stream);
	stream.Send();
}

function WriteDataToStream(data, stream) {
	switch (typeof(data)) {
		case "null":
			stream.WriteByte('o');
			break;
		case "integer":
			if (data <= 32767 && data >= -32768) {
				//int16_t
				//maximum value 32767
				//minimum value -32768
				stream.WriteByte('w');
				stream.WriteByte(data & 0xff);
				stream.WriteByte((data >> 8) & 0xff);
				break;
			} else {
				stream.WriteByte('i');
				stream.WriteInt(data);
				break;
			}
			break;
		case "float":
			stream.WriteByte('f');
			stream.WriteFloat(data);
			break;
		case "string":
			stream.WriteByte('s');
			stream.WriteString(data);
			break;
		case "bool":
			stream.WriteByte('b');
			stream.WriteByte(data.tointeger());
			break;
		case "array":
			stream.WriteByte('A');
			stream.WriteInt(data.len());
			for (local i = 0; i < data.len(); i++)
				WriteDataToStream(data[i], stream);
			break;
		case "Vector":
			stream.WriteByte('v');
			stream.WriteFloat(data.X);
			stream.WriteFloat(data.Y);
			stream.WriteFloat(data.Z);
			break;
		case "VectorScreen":
			stream.WriteByte('v');
			stream.WriteFloat(data.X);
			stream.WriteFloat(data.Y);
			stream.WriteFloat(0);
			break;
		case "table":
			stream.WriteByte('T');

			local len = 0;
			//First get len (no:of writable key-value pairs)
			foreach(a, b in data) {
				if (typeof(a) == "function" || typeof(b) == "function") continue; //shrink the table to avoid functions
				if (typeof(a) == "class" || typeof(b) == "class") continue;
				len++;
			}
			stream.WriteInt(len);
			foreach(a, b in data) {
				if (typeof(a) == "function" || typeof(b) == "function") continue; //shrink the table to avoid functions
				if (typeof(a) == "class" || typeof(b) == "class") continue;
				WriteDataToStream(a, stream);
				WriteDataToStream(b, stream);
			}
			break;

		case "blob":
			stream.WriteByte('B');
			local len = data.len();
			stream.WriteInt(len);
			for (local i = 0; i < len; i++) {
				stream.WriteByte(data[i]);
			}
			break;
			/*
			case "class": stream.WriteByte('c');local ln=0;
				foreach(a,b in data)
					ln++;//classes do not have len operator
				stream.WriteInt(ln);
				foreach(a,b in data)
				{
					WriteDataToStream(a, stream);
					WriteDataToStream(b, stream);
				}
				break;
				*/
		case "Player":
		case "Vehicle":
		case "Building":
		case "RayTrace":
		case "Colour":
		case "GUIElement":
		case "GUIButton":
		case "GUICanvas":
		case "GUICheckbox":
		case "GUIEditbox":
		case "GUILabel":
		case "GUIListbox":
		case "GUIMemobox":
		case "GUIProgressBar":
		case "GUIScrollbar":
		case "GUISprite":
		case "GUIWindow":
			if ("__getTable" in data) {
				local val;
				local table = {};
				foreach(key, value in data.__getTable) {
					if (typeof(value) == "function") //It must be function
					{
						val = value.call(data);
						table.rawset(key, val);
					}
				}
				WriteDataToStream(table, stream);
				break;
			} //else fall through the switch

		default:
			stream.WriteByte('s');
			stream.WriteString(typeof(data));
			break;

	}
}
function SendReplyToPeer(peerid, token, data, error = false) {
	//local stream = Stream();
	local stream = ::betterblob();
	stream.WriteInt(StreamType.SendResultToPeer);
	stream.WriteByte(peerid);
	stream.WriteInt(token);
	if (!error)
		WriteDataToStream(data, stream);
	else {
		stream.WriteByte('e');
		if (typeof(data) == "string")
			stream.WriteString(data);
		else
			stream.WriteString("");
	}
	//Server.SendData(stream);
	stream.Send();
}
//identifier, data must be any valid squirrel type which 'WriteDataToStream' can process
function PassDataToServer(identifier, data) {
	local stream = ::betterblob();
	stream.WriteInt(StreamType.ClientData);
	WriteDataToStream(identifier, stream);
	WriteDataToStream(data, stream);
	stream.Send();
}