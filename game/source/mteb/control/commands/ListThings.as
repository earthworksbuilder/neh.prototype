package mteb.control.commands
{
	import mteb.control.interpreters.ICommandInterpreter;
	import mteb.data.DataLocator;
	import mteb.data.config.IConfig;
	import mteb.data.player.IInventory;
	import mteb.view.LayerLocator;


	public class ListThings implements IExecutableCommand
	{
		protected const _command:String = "?";

		protected const _usage:String = "? name (lists all types of name)\n  name: commands|config|inventory";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const name:String = String(args[0]).toLowerCase();

			switch (name)
			{
				case "commands":
					const commandParser:ICommandInterpreter = LayerLocator.getInstance().debug.commandParser;
					debug(this, "available commands:\n-----\n{0}\n-----", commandParser.commands.join("\n"));
					break;

				case "config":
					const config:IConfig = DataLocator.getInstance().config;
					debug(this, "current config:\n-----\n{0}\n-----", config);
					break;

				case "inventory":
					const inventory:IInventory = DataLocator.getInstance().inventory;
					debug(this, "current inventory:\n-----\n{0}\n-----", inventory);
					break;

				default:
					debug(this, "(?) - Missing or unknown name parameter. Try one of the following:\n  commands|config|inventory");
					break;
			}
		}

		public function get usage():String  { return _usage; }
	}
}