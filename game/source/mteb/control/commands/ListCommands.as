package mteb.control.commands
{
	import mteb.view.LayerLocator;
	import mteb.control.interpreters.ICommandInterpreter;


	public class ListCommands implements IExecutableCommand
	{
		protected const _command:String = "?";

		protected const _usage:String = "? (lists all commands)";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const commandParser:ICommandInterpreter = LayerLocator.getInstance().debug.commandParser;
			debug(this, "available commands:\n-----\n{0}\n-----", commandParser.commands.join("\n"));
		}

		public function get usage():String  { return _usage; }
	}
}
