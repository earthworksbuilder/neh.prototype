package mteb.control.commands
{
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.control.SignalBus;
	import mteb.control.signals.ArtifactChanged;
	import mteb.control.signals.HorizonEventSignal;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.view.scene.compass.CompassLightEnum;


	public class ChangeArtifact implements IExecutableCommand
	{

		protected const _command:String = "artifact";

		protected const _usage:String = "artifact index lock|unlock|activate|capture (updates compass artifact light #index)";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			const index:uint = parseInt(args[0]);
			const state:String = String(args[1]).toLowerCase();

			const announcement:HorizonEventSignal = new ArtifactChanged();
			const authority:ICompassLightStateProvider = announcement as ICompassLightStateProvider;
			announcement.pointIndex = index;
			var ready:Boolean = true;

			switch (state)
			{
				case "lock":
					announcement.pointState = CompassLightEnum.LOCKED;
					break;

				case "unlock":
					announcement.pointState = CompassLightEnum.UNLOCKED;
					break;

				case "activate":
					announcement.pointState = CompassLightEnum.ACTIVATED;
					break;

				case "capture":
					announcement.pointState = CompassLightEnum.CAPTURED;
					break;

				default:
					debug(this, "\n  unrecognized action. try 'lock', 'unlock', 'activate', or 'capture'");
					ready = false;
					break;
			}

			if (ready)
			{
				debug(this, "execute() - changing artifact {0} to {1}", index, state);
				signalBus.addSignal(announcement as ISignal);
				announcement.send(authority);
			}
		}

		public function get usage():String  { return _usage; }
	}
}
