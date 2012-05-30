package mteb.control.commands
{
	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.control.SignalBus;
	import mteb.control.signals.ActionTriggered;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.ActionTypeEnum;


	public class JumpToNode implements IExecutableCommand
	{

		protected const _command:String = "node";

		protected const _usage:String = "node id (jumps to node matching id)";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			const actionTriggered:IProtectedSignal = new ActionTriggered();
			signalBus.addSignal(actionTriggered as ISignal);

			const actionTrigger:ActionTrigger = new ActionTrigger();
			actionTrigger.type = ActionTypeEnum.JUMP_TO_NODE;
			actionTrigger.nodeId = args[0];

			debug(this, "execute() - jumping to node id '{0}'", actionTrigger.nodeId);
			actionTriggered.send(actionTrigger);
		}

		public function get usage():String  { return _usage; }
	}
}
