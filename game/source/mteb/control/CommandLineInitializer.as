package mteb.control
{
	import mteb.control.commands.ChangePreferences;
	import mteb.control.commands.IExecutableCommand;
	import mteb.control.commands.JumpToNode;
	import mteb.control.commands.ListCommands;
	import mteb.control.commands.ToggleHotspots;
	import mteb.control.interpreters.ICommandInterpreter;


	public final class CommandLineInitializer
	{
		public static function execute(interpreter:ICommandInterpreter):void
		{
			add(interpreter, ListCommands);
			add(interpreter, JumpToNode);
			add(interpreter, ToggleHotspots);
			add(interpreter, ChangePreferences);
		}

		private static function add(interpreter:ICommandInterpreter, Impl:Class):void
		{
			const impl:IExecutableCommand = new Impl() as IExecutableCommand;
			interpreter.addCommand(impl.command, Impl, impl.usage);
		}
	}
}
