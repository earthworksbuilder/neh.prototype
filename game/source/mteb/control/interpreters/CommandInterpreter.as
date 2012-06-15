package mteb.control.interpreters
{
	import flash.utils.Dictionary;

	import mteb.control.commands.IExecutableCommand;


	public class CommandInterpreter implements ICommandInterpreter
	{
		protected var commandMap:Dictionary = new Dictionary();
		protected var usageMap:Dictionary = new Dictionary();

		public function addCommand(command:String, impl:Class, usage:String = ""):void
		{
			debug(this, "addCommand() - adding '{0}'", command);
			commandMap[command] = impl;
			usageMap[command] = usage;
		}

		public function get commands():Vector.<String>
		{
			const list:Vector.<String> = new <String>[];
			for (var commandName:String in commandMap)
				list.push(usageMap[commandName]);
			return list;
		}

		public function processCommand(string:String):Boolean
		{
			var handled:Boolean = false;
			const tokens:Array = string.split(' ');
			const command:String = tokens.splice(0, 1)[0].toLowerCase();
			if (commandMap[command])
			{
				const Impl:Class = commandMap[command] as Class;
				if (Impl != null)
				{
					debug(this, "processCommand() - executing implementation for '{0}', with {1} args", command, tokens.length);
					const impl:IExecutableCommand = new Impl() as IExecutableCommand;
					impl.execute(tokens);
					handled = true;
				}
			}
			return handled;
		}
	}
}
