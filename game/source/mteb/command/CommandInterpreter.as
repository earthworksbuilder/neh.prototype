package mteb.command
{
	import flash.utils.Dictionary;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.command.signals.ActionTriggered;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.ActionTypeEnum;
	import mteb.view.debug.commandline.ICommandInterpreter;


	public class CommandInterpreter implements ICommandInterpreter
	{
		protected var commandMap:Dictionary = new Dictionary();
		protected var usageMap:Dictionary = new Dictionary();

		protected const actionTriggered:IProtectedSignal = new ActionTriggered();


		public function CommandInterpreter()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(actionTriggered as ISignal);

			addCommand("?", listCommands, "? (lists all commands)");
			addCommand("node", jumpToNode, "node id (jumps to node matching id)");
		}

		public function addCommand(command:String, callback:Function, usage:String = ""):void
		{
			debug(this, "addCommand() - adding '{0}'", command);
			commandMap[command] = callback;
			usageMap[command] = usage;
		}

		public function processCommand(string:String):Boolean
		{
			var handled:Boolean = false;
			const tokens:Array = string.split(' ');
			const command:String = tokens.splice(0, 1);
			if (commandMap[command])
			{
				const action:Function = commandMap[command] as Function;
				if (action != null)
				{
					debug(this, "processCommand() - executing action for '{0}', with {1} args", command, tokens.length);
					action(tokens);
					handled = true;
				}
			}
			return handled;
		}

		protected function jumpToNode(args:Array):void
		{
			debug(this, "jumpToNode() - args: {0}", args);
			const actionTrigger:ActionTrigger = new ActionTrigger();
			actionTrigger.type = ActionTypeEnum.JUMP_TO_NODE;
			actionTrigger.nodeId = args[0];
			actionTriggered.send(actionTrigger);
		}

		protected function listCommands(args:Array):void
		{
			var list:String = "\n";
			for (var commandName:String in commandMap)
				list += usageMap[commandName] + "\n";
			debug(this, "available commands:\n-----{0}-----", list);
		}
	}
}
