package mteb.control.commands
{
	import mteb.data.DataLocator;
	import mteb.data.config.IConfig;


	public class ToggleHotspots implements IExecutableCommand
	{
		protected const _command:String = "hotspots";

		protected const _usage:String = "hotspots true|false (reveals|hides hotspots)";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const config:IConfig = DataLocator.getInstance().config;
			const old:Boolean = config.showHotspots;
			const neu:Boolean = (args[0] == "true");
			if (old != neu)
			{
				debug(this, "execute() - updating config.showHotspots from {0} to {1}", old, neu);
				config.showHotspots = neu;
				refresh();
			}
			else
				debug(this, "execute() - config.showHotspots is already {0}", old);
		}

		public function get usage():String  { return _usage; }

		protected function refresh():void
		{
			const currentNodeId:String = DataLocator.getInstance().map.currentNode.id;
			new JumpToNode().execute([currentNodeId]);
		}
	}
}
