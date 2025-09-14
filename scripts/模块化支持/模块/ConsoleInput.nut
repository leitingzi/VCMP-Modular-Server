class ConsoleInput extends EventModule {
	function onConsoleInput(cmd, text) {
		switch (cmd) {
			case "testmodule":
				print("this is test module.");
				break;

			default:
				break;
		}
	}
}