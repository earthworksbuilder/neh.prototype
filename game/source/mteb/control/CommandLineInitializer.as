package mteb.control
{
	import mteb.control.interpreters.ICommandInterpreter;
	import mteb.control.commands.IExecutableCommand;
	import mteb.control.commands.JumpToNode;
	import mteb.control.commands.ListCommands;


	public final class CommandLineInitializer
	{
		public static function execute(interpreter:ICommandInterpreter):void
		{
			add(interpreter, ListCommands);
			add(interpreter, JumpToNode);
		}

		private static function add(interpreter:ICommandInterpreter, Impl:Class):void
		{
			const impl:IExecutableCommand = new Impl() as IExecutableCommand;
			interpreter.addCommand(impl.command, Impl, impl.usage);
		}
	}
}
