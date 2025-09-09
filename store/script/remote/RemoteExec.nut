function ProcessData(stream, bytesread = [0]) {
	local byte = stream.ReadByte();
	local len, item, b, counter, array, func, arg, table;
	local obj, key, value;
	local op1, op2;
	switch (byte) {
		case 'o':
			bytesread[0] = 1;
			return null;
		case 'i':
			bytesread[0] = 5;
			return stream.ReadInt();
		case 'w':
			bytesread[0] = 3;
			item = stream.ReadByte() + 256 * stream.ReadByte();
			if (item > 32767) {
				item -= 65536; // Convert to negative value in two's complement
			}
			return item;
		case 'f':
			bytesread[0] = 5;
			return stream.ReadFloat();
		case 'v':
			bytesread[0] = 13;
			return Vector(stream.ReadFloat(), stream.ReadFloat(), stream.ReadFloat());
		case 'q':
			bytesread[0] = 17;
			return {
				X = stream.ReadFloat(), Y = stream.ReadFloat(), Z = stream.ReadFloat(), W = stream.ReadFloat()
			};
		case 's':
			item = stream.ReadString();
			bytesread[0] = 1 + 2 + item.len();
			return item;
		case 'b':
			bytesread[0] = 2;
			value = stream.ReadByte();
			if (value == 0) return false;
			else return true;
			//Array created by SendReply
		case 'A':
			len = stream.ReadInt();
			array = [];
			counter = 0;
			for (local i = 0; i < len; i++) {
				b = [0];
				item = ProcessData(stream, b);
				counter += b[0];
				array.append(item);
			}
			bytesread[0] = 5 + counter;
			return array;
			//Blob
		case 'B':
			len = stream.ReadInt();
			item = blob();
			for (local i = 0; i < len; i++) {
				item.writen(stream.ReadByte(), 'b');
			}
			bytesread[0] = 5 + len; //1 for 'B', 4 for len and 'len' items.
			return item;
			//Array create by Server or InsertSQObject in client side
		case 'a':
			len = stream.ReadInt();
			array = [];
			counter = 0;
			do {
				b = [0];
				item = ProcessData(stream, b);
				counter += b[0];
				array.append(item);
			} while (counter < len);
			bytesread[0] = 5 + len;
			return array;
			//Table created by SendReply
		case 'T':
			len = stream.ReadInt();
			table = {};
			counter = 0;
			for (local i = 0; i < len; i++) {
				b = [0];
				key = ProcessData(stream, b);
				counter += b[0];
				b = [0];
				value = ProcessData(stream, b);
				counter += b[0];
				table.rawset(key, value);
			}
			bytesread[0] = 5 + counter;
			return table;
			//Table originated in Server
		case 't':
			len = stream.ReadInt();
			table = {};
			counter = 0;
			while (counter < len) {
				b = [0];
				key = ProcessData(stream, b);
				counter += b[0];
				if (counter >= len && len != 0) //precaution against case when key is given but value is not. len!=0 for empty tables
				{
					break;
				}
				b = [0];
				value = ProcessData(stream, b);
				counter += b[0];
				table.rawset(key, value);
			};
			bytesread[0] = 5 + len;
			return table;
			//get
		case 'g':
			len = stream.ReadInt();
			bytesread[0] = 5 + len;
			key = ProcessData(stream);
			if (key in getroottable())
				return getroottable().rawget(key);
			else if (key in getconsttable())
				return getconsttable().rawget(key);
			else
				throw ("key " + key + " not found in roottable or consttable.");
			break;
			//set
		case 'h':
			len = stream.ReadInt();
			bytesread[0] = 5 + len;
			key = ProcessData(stream);
			value = ProcessData(stream);
			return getroottable().rawset(key, value);

			break;
			//extended get
		case 'k':
			len = stream.ReadInt();
			bytesread[0] = 5 + len;
			obj = ProcessData(stream);
			key = ProcessData(stream);
			try {
				if (typeof(obj) == "array" && typeof(key) == "integer") {
					return obj[key];
				}
				return obj.rawget(key);
			} catch (e) {

				//Now check if instance is of Player class
				if (typeof(obj) == "Player" || typeof(obj) == "Vehicle" || typeof(obj) == "Building" ||
					typeof(obj) == "Colour" || typeof(obj) == "instance" || typeof(obj) == "Vector" || typeof(obj) == "RayTrace" ||
					typeof(obj) == "GUIProgressBar" || typeof(obj) == "GUICanvas" || typeof(obj) == "GUIEditbox" || typeof(obj) == "GUISprite" ||
					typeof(obj) == "GUIMemobox" || typeof(obj) == "GUIButton" || typeof(obj) == "GUIWindow" || typeof(obj) == "GUIListbox" ||
					typeof(obj) == "GUICheckbox" || typeof(obj) == "GUIElement" || typeof(obj) == "GUILabel" || typeof(obj) == "VectorScreen" ||
					typeof(obj) == "Stream" || typeof(obj) == "GUIScrollbar") {
					try {
						local c = obj.getclass();
						if ("__getTable" in c) {
							if (key in c.__getTable) {
								local func = c.__getTable.rawget(key);
								if (typeof(func) == "function") {
									return func.call(obj);
								}
							} else throw ("Property " + key + " not found in " + c);
						}
					} catch (e) {
						throw (e);
					}
				} else throw (e);
			}
			break;
			//extended set
		case 'j':
			len = stream.ReadInt();
			bytesread[0] = 5 + len;
			obj = ProcessData(stream);
			key = ProcessData(stream);
			value = ProcessData(stream);
			try {
				return obj.rawset(key, value);
			} catch (e) {
				//Now check if instance is of Player class
				if (typeof(obj) == "Player" || typeof(obj) == "Vehicle" ||
					typeof(obj) == "Colour" || typeof(obj) == "instance" || typeof(obj) == "Vector" ||
					typeof(obj) == "GUIProgressBar" || typeof(obj) == "GUICanvas" || typeof(obj) == "GUIEditbox" || typeof(obj) == "GUISprite" ||
					typeof(obj) == "GUIMemobox" || typeof(obj) == "GUIButton" || typeof(obj) == "GUIWindow" || typeof(obj) == "GUIListbox" ||
					typeof(obj) == "GUICheckbox" || typeof(obj) == "GUIElement" || typeof(obj) == "GUILabel" || typeof(obj) == "VectorScreen" ||
					typeof(obj) == "GUIScrollbar") {
					try {
						local c = obj.getclass();
						if ("__setTable" in c) {
							if (key in c.__setTable) {
								local func = c.__setTable.rawget(key);
								if (typeof(func) == "function") {
									return func.call(obj, value);
								}
							} else throw ("Property " + key + " not found in " + c);
						}
					} catch (e) {
						throw (e);
					}
				} else throw (e);
			}
			break;
			//calls
		case 'F':
			len = stream.ReadInt();
			b = [0];
			counter = 0;
			func = ProcessData(stream, b);
			counter += b[0];
			array = [];

			while (counter < len) {
				arg = ProcessData(stream, b);
				counter += b[0];
				array.append(arg);
			}
			bytesread[0] = 5 + len;
			if (typeof(func) == "function") {
				array.insert(0, getroottable());
				try {
					return func.pacall(array);
				} catch (e) {
					throw (e);
				}
			} else if (typeof(func) == "class" && "constructor" in func) {
				local inst = func.instance();
				array.insert(0, inst); //instance as this
				try {
					inst.constructor.acall(array);
					return inst;
				} catch (e) {
					throw (e);
				}
			} else throw ("cannot call " + typeof(func) + ": " + func);
			break;
		case 'E':
			len = stream.ReadInt();
			b = [0];
			counter = 0;
			func = ProcessData(stream, b);
			counter += b[0];
			array = [];

			while (counter < len) {
				arg = ProcessData(stream, b);
				counter += b[0];
				array.append(arg);
			}
			bytesread[0] = 5 + len;

			if (typeof(func) == "function") {
				try {
					return func.acall(array);
				} catch (e) {
					throw (e);
				}
			} else if (typeof(func) == "class" && "constructor" in func) {
				local inst = func.instance();
				array.remove(0); //we do not need the 'this'
				array.insert(0, inst); //instance as this
				try {
					inst.constructor.acall(array);
					return inst;
				} catch (e) {
					throw (e);
				}
			} else throw ("cannot call " + typeof(func) + ": " + func);
			break;
			//Addition, Subtraction, Multiplication, Division and modulo
		case '+':
		case '-':
		case '*':
		case '/':
		case '%':
			len = stream.ReadInt();
			bytesread[0] = 5 + len;
			op1 = ProcessData(stream);
			op2 = ProcessData(stream);
			try {
				value = byte == '+' ? op1 + op2 : byte == '-' ? op1 - op2 : byte == '*' ? op1 * op2 : byte == '/' ? op1 / op2 : op1 % op2;
			} catch (e) {
				throw (e);
			}
			return value;
			break;
			//Unary minus operator
		case 'u':
			len = stream.ReadInt();
			bytesread[0] = 5 + len;
			item = ProcessData(stream);
			return -item;
			//Error
		case 'e':
			item = stream.ReadString();
			bytesread[0] = 1 + 2 + item.len();
			if (bytesread.len() > 1)
				bytesread[1] = 'e';
			return item;
	}

}