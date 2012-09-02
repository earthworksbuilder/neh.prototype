package mteb.control.commands
{
	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.control.SignalBus;
	import mteb.control.signals.PreferencesChanged;
	import mteb.data.DataLocator;
	import mteb.data.config.IConfig;


	public class ChangePreferences implements IExecutableCommand
	{

		protected const _command:String = "config";

		protected const _usage:String = "config name value (updates config.name to value)";

		public function get command():String  { return _command; }

		public function execute(args:Array):void
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			const preferencesChanged:IProtectedSignal = new PreferencesChanged();
			signalBus.addSignal(preferencesChanged as ISignal);

			const config:IConfig = DataLocator.getInstance().config;
			const configObject:Object = config as Object;
			const property:String = args[0];
			const value:String = args[1];

			if (configObject.hasOwnProperty(property))
			{
				if (value == "false" || value == "true")
					configObject[property] = (value == "true");
				else
					configObject[property] = value;

				debug(this, "execute() - setting preference '{0}' to '{1}'", property, value);
				preferencesChanged.send(config);
			}
			else
				warn(this, "execute() - no preference named '{0}' in config", property);
		}

		public function get usage():String  { return _usage; }
	}
}
