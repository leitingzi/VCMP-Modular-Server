split_stream_sequence_no <- 0;
const MAX_PAYLOAD_LEN = 4075
class betterblob extends blob {
	Error = false;
	function WriteInt(i) {
		writen(i, 'i'); //integer
	}
	function WriteByte(b) {
		writen(b, 'b'); //byte
	}
	function WriteFloat(f) {
		writen(f, 'f'); //floating point
	}
	function WriteString(s) {
		local l = s.len();
		local val = ::swap2(l);
		writen(val, 'w'); // big-endian
		foreach(c in s)
		writen(c, 'b');
	}

	//Used when reading split streams
	function ReadInt() {
		if (tell() + 4 <= len())
			return readn('i');
		else Error = true;
		throw ("betterblob: reading past length, integer");
	}
	function ReadFloat() {
		if (tell() + 4 <= len())
			return readn('f');
		else Error = true;
		throw ("betterblob: reading past length, float");
	}
	function ReadByte() {
		if (tell() + 1 <= len())
			return readn('b');
		else Error = true;
		throw ("betterblob: reading past length, byte( tell=" + tell() + " and len=" + len() + ")");
	}
	function ReadString() {
		if (tell() + 2 <= len()) {
			local l = readn('w'); //big-endian
			local val = ::swap2(l); //Length of the string
			local str = "";
			local c;
			if (tell() + val <= len()) {
				for (local i = 0; i < val; i++) {
					c = readn('b');
					str += ::format("%c", c);
				}
				return str;
			} else
				Error = true;
			throw ("betterblob: cannot read string");
		} else
			Error = true;
		throw ("betterblob: cannot read string length");
	}
	function _typeof() {
		return "betterblob";
	}
	function Send() {
		if (len() < 4095) {
			//Make a stream and send!!
			local stream = ::Stream();
			foreach(byte in this) {
				stream.WriteByte(byte);
			}::Server.SendData(stream)
		} else {
			local chunk_ID = 0; //4-bytes
			local total_chunk; //4-bytes
			local payload_length; //two-bytes
			total_chunk = ceil(len() / (MAX_PAYLOAD_LEN.tofloat()));
			local index = 0;
			while (index < len()) {
				local chunk = ::betterblob();
				chunk.WriteInt(StreamType.SplitStream);
				chunk.WriteInt(split_stream_sequence_no);
				chunk.WriteInt(chunk_ID++); //chunk ID
				chunk.WriteInt(total_chunk); //total chunks
				payload_length = (len() - index) < MAX_PAYLOAD_LEN ? (len() - index) : MAX_PAYLOAD_LEN;
				chunk.writen(payload_length, 'w');
				for (local i = 0; i < payload_length; i++) {
					if (index < len()) //reduntant
						chunk.WriteByte(this[index]);
					else {
						//Reached End of Blob
						//Never happens
					}
					index++;
				}
				//Now chunk is fully written. Just send it
				if (chunk.len() < 4095)
					chunk.Send();
				else
					throw ("Error: chunk length exceeded 4095 bytes");
			}::split_stream_sequence_no++;
		}
	}
}