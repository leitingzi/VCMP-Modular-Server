class Sqlite extends Any {
	db = null;
	lastQuery = null;
	constructor(path) {
		db = ::ConnectSQL(path);
	}

	function close() {
		::DisconnectSQL(db);
	}

	function escape(string) {
		return::escapeSQLString(string);
	}

	function query(sql) {
		lastQuery = ::QuerySQL(db, sql);
		return lastQuery;
	}

	function free() {
		::FreeSQLQuery(lastQuery)
	}

	function select(tableName) {
		return query("SELECT * FROM " + escape(tableName) + ";");
	}

	function getColumnInfo(tableName) {
		local q = query("PRAGMA table_info(" + escape(tableName) + ");");
		if (q) {
			local arr = [];
			do {
				local table = {
					cid = GetSQLColumnData(q, 0),
					name = GetSQLColumnData(q, 1),
					type = GetSQLColumnData(q, 2),
					notnull = GetSQLColumnData(q, 3),
					dflt_value = GetSQLColumnData(q, 4),
					pk = GetSQLColumnData(q, 5)
				};
				arr.append(table);
			}
			while (GetSQLNextRow(q));
			return arr;
		}
		return null;
	}
}

local db = Sqlite("database.db");