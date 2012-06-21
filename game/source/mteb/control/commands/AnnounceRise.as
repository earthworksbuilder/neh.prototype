package mteb.control.commands
{
	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.control.SignalBus;
	import mteb.control.signals.RiseEnded;
	import mteb.control.signals.RiseStarted;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.view.scene.compass.CompassLightEnum;


	public class AnnounceRise implements IExecutableCommand
	{

		protected const _command:String = "rise";

		protected const _usage:String = "rise start|end index (updates moonpoint #index)";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			const action:String = String(args[0]).toLowerCase();
			const index:uint = parseInt(args[1]);

			var announcement:IProtectedSignal;
			var authority:ICompassLightStateProvider;

			switch (action)
			{
				case "start":
					var start:RiseStarted = new RiseStarted();
					start.pointIndex = index;
					start.pointState = CompassLightEnum.ON;
					announcement = start as IProtectedSignal;
					authority = start as ICompassLightStateProvider;
					break;

				case "end":
					var end:RiseEnded = new RiseEnded();
					end.pointIndex = index;
					end.pointState = CompassLightEnum.ENABLED;
					announcement = end as IProtectedSignal;
					authority = end as ICompassLightStateProvider;
					break;
			}

			if (announcement)
			{
				debug(this, "execute() - announcing rise {0} at index {1}", action, index);
				signalBus.addSignal(announcement as ISignal);
				announcement.send(authority);
			}
		}

		public function get usage():String  { return _usage; }
	}
}
